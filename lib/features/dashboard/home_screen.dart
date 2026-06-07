import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/core/ads/banner_ad_widget.dart';
import 'package:flutter_template/core/paywall/paywall_modal.dart';
import 'package:flutter_template/core/paywall/paywall_provider.dart';
import 'package:flutter_template/core/paywall/paywall_service.dart';
import 'package:flutter_template/core/analytics/analytics_service.dart';
import 'package:flutter_template/core/remote_config/remote_config_service.dart';
import 'package:flutter_template/config/app_config.dart';
import 'package:flutter_template/shared_ui/skeleton/skeleton_loader.dart';

/// Home screen dashboard with:
/// - Remote Config driven free limit
/// - easy_localization strings
/// - ScreenUtil responsive sizing
/// - Skeleton loading state demo
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isPageLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate initial data load — replace with real data fetch
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isPageLoading = false);
    });
  }

  Future<void> _useFeature() async {
    final isPremium = ref.read(isPremiumProvider);
    // Use Remote Config limit if available, otherwise fall back to AppConfig
    final limit = ref.read(freeAiLimitProvider);
    final limitNotifier = ref.read(freeLimitProvider.notifier);

    if (!isPremium) {
      final canUse = limitNotifier.consume('main_feature', limit: limit);
      if (!canUse) {
        await AnalyticsService.instance
            .logFreeLimitHit(featureName: 'main_feature');
        if (mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) =>
                const PaywallModal(source: 'home_limit_hit'),
          );
        }
        return;
      }
    }

    await AnalyticsService.instance
        .logFeatureUsed(featureName: 'main_feature');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('home.use_feature'.tr()),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isPremium = ref.watch(isPremiumProvider);
    final usage = ref.watch(freeLimitProvider);
    final limit = ref.watch(freeAiLimitProvider);
    final todayKey =
        'main_feature::${DateTime.now().toIso8601String().substring(0, 10)}';
    final usedToday = usage[todayKey] ?? 0;
    final remaining = limit - usedToday;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.appName),
        actions: [
          if (isPremium)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: const Icon(Icons.star, color: Color(0xFFFFD700)),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SkeletonLoader(
              isLoading: _isPageLoading,
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  // ── Free limit banner ─────────────────────────
                  if (!isPremium && !_isPageLoading)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      margin: EdgeInsets.only(bottom: 20.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF9C88FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.bolt,
                              color: Colors.white, size: 28.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'home.uses_remaining'.tr(
                                    namedArgs: {'count': '$remaining'},
                                  ),
                                  style:
                                      theme.textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                Text(
                                  'home.upgrade_prompt'.tr(),
                                  style:
                                      theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => const PaywallModal(
                                  source: 'home_banner'),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.2),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8.r)),
                            ),
                            child: Text('home.upgrade'.tr(),
                                style: TextStyle(fontSize: 12.sp)),
                          ),
                        ],
                      ),
                    ),

                  // ── Feature card ──────────────────────────────
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: cs.primaryContainer,
                                  borderRadius:
                                      BorderRadius.circular(12.r),
                                ),
                                child: Icon(Icons.auto_awesome,
                                    color: cs.onPrimaryContainer,
                                    size: 22.sp),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'home.your_feature'.tr(),
                                style:
                                    theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'home.feature_placeholder'.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  cs.onSurface.withValues(alpha: 0.65),
                              height: 1.6,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _useFeature,
                              icon: Icon(Icons.play_arrow,
                                  size: 20.sp),
                              label: Text('home.use_feature'.tr()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Stat row ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'home.used_today'.tr(),
                          value: '$usedToday',
                          icon: Icons.today,
                          color: cs.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _StatCard(
                          label: 'home.daily_limit'.tr(),
                          value: isPremium ? '∞' : '$limit',
                          icon: Icons.loop,
                          color: isPremium
                              ? const Color(0xFFFFD700)
                              : cs.secondary,
                        ),
                      ),
                    ],
                  ),

                  // ── Skeleton demo section ─────────────────────
                  SizedBox(height: 24.h),
                  if (_isPageLoading)
                    const SkeletonCardList(itemCount: 3),
                ],
              ),
            ),
          ),

          // ── Banner ad (auto-hides for premium) ──────────────
          const BannerAdWidget(),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22.sp),
            SizedBox(height: 8.h),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 24.sp,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
