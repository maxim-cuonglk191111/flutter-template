import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_template/core/analytics/analytics_service.dart';
import 'package:flutter_template/core/auth/auth_service.dart';
import 'package:flutter_template/core/paywall/paywall_provider.dart';
import 'package:flutter_template/core/paywall/paywall_modal.dart';
import 'package:flutter_template/config/app_config.dart';

// ── Theme Mode Provider ──────────────────────────────────────

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
        (ref) => ThemeModeNotifier());

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark_mode');
    if (isDark != null) {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> toggle() async {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', !isDark);
  }
}

// ── Language Provider ────────────────────────────────────────

final _languageLabels = {
  'en': '🇺🇸 English',
  'vi': '🇻🇳 Tiếng Việt',
};

// ── Settings Screen ──────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isPremium = ref.watch(isPremiumProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final currentLocale = context.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text('settings.title'.tr()),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // ── Account ──────────────────────────────────────────
          _SectionHeader('settings.section_account'.tr()),
          _SettingsTile(
            icon: Icons.logout,
            title: 'auth.sign_out'.tr(),
            subtitle: 'auth.sign_out_subtitle'.tr(),
            onTap: () async {
              await AuthService.instance.signOut();
              await AnalyticsService.instance.logSignOut();
              if (context.mounted) context.go('/auth');
            },
          ),

          // ── Appearance ───────────────────────────────────────
          _SectionHeader('settings.section_appearance'.tr()),
          _SettingsTile(
            icon: isDark ? Icons.dark_mode : Icons.light_mode,
            title: 'settings.dark_mode'.tr(),
            subtitle: isDark
                ? 'settings.dark_mode_on'.tr()
                : 'settings.dark_mode_off'.tr(),
            trailing: Switch(
              value: isDark,
              onChanged: (val) async {
                await ref.read(themeModeProvider.notifier).toggle();
                AnalyticsService.instance.logThemeToggled(isDark: val);
              },
            ),
          ),

          // ── Language selector ─────────────────────────────────
          _SettingsTile(
            icon: Icons.language,
            title: 'settings.language'.tr(),
            subtitle: _languageLabels[currentLocale] ?? currentLocale,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context),
          ),

          // ── Subscription ─────────────────────────────────────
          if (AppConfig.enablePaywall) ...[
            _SectionHeader('settings.section_subscription'.tr()),
            if (!isPremium)
              _SettingsTile(
                icon: Icons.workspace_premium,
                iconColor: const Color(0xFF6C63FF),
                title: 'settings.go_premium'.tr(),
                subtitle: 'settings.go_premium_subtitle'.tr(),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'settings.upgrade_label'.tr(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) =>
                      const PaywallModal(source: 'settings'),
                ),
              )
            else
              _SettingsTile(
                icon: Icons.star,
                iconColor: const Color(0xFFFFD700),
                title: 'settings.premium_active'.tr(),
                subtitle: 'settings.premium_active_subtitle'.tr(),
              ),
            _SettingsTile(
              icon: Icons.restore,
              title: 'settings.restore_purchase'.tr(),
              subtitle: 'settings.restore_subtitle'.tr(),
              onTap: () async {
                final restored = await ref
                    .read(paywallProvider.notifier)
                    .restorePurchases();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        restored
                            ? 'paywall.premium_restored'.tr()
                            : 'paywall.no_purchases_to_restore'.tr(),
                      ),
                    ),
                  );
                }
              },
            ),
          ],

          // ── Legal ─────────────────────────────────────────────
          _SectionHeader('settings.section_legal'.tr()),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'settings.privacy_policy'.tr(),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _launchUrl(AppConfig.privacyPolicyUrl),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'settings.terms_of_service'.tr(),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => _launchUrl(AppConfig.termsOfServiceUrl),
          ),

          // ── Support ───────────────────────────────────────────
          _SectionHeader('settings.section_support'.tr()),
          _SettingsTile(
            icon: Icons.mail_outline,
            title: 'settings.contact_support'.tr(),
            subtitle: AppConfig.supportEmail,
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () =>
                _launchUrl('mailto:${AppConfig.supportEmail}'),
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'settings.app_version'.tr(),
            subtitle: AppConfig.appVersion,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConfig.supportedLocales.map((locale) {
            final code = locale.languageCode;
            final label = _languageLabels[code] ?? code;
            final isSelected = ctx.locale.languageCode == code;

            return ListTile(
              leading: Text(
                label.split(' ').first, // Flag emoji
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(label.split(' ').skip(1).join(' ')),
              trailing: isSelected
                  ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
                  : null,
              onTap: () {
                ctx.setLocale(locale);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Reusable components ──────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: (iconColor ?? cs.primary).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: iconColor ?? cs.primary),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
