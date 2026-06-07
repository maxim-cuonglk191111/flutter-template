import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_template/core/paywall/paywall_provider.dart';
import 'package:flutter_template/core/analytics/analytics_service.dart';
import 'package:flutter_template/shared_ui/theme/app_colors.dart';

/// Displays available subscription packages from RevenueCat.
/// Show via: showModalBottomSheet(context, builder: (_) => const PaywallModal())
class PaywallModal extends ConsumerStatefulWidget {
  final String? source;
  const PaywallModal({super.key, this.source});

  @override
  ConsumerState<PaywallModal> createState() => _PaywallModalState();
}

class _PaywallModalState extends ConsumerState<PaywallModal> {
  List<Package>? _packages;
  bool _isLoading = true;
  bool _isPurchasing = false;
  final _log = Logger();

  @override
  void initState() {
    super.initState();
    _loadOfferings();
    AnalyticsService.instance.logPaywallShown(source: widget.source);
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (mounted) {
        setState(() {
          _packages = current?.availablePackages ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      _log.e('Failed to load offerings', error: e);
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _purchase(Package pkg) async {
    setState(() => _isPurchasing = true);
    final success = await ref.read(paywallProvider.notifier).purchase(pkg);
    if (mounted) {
      setState(() => _isPurchasing = false);
      if (success) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ─────────────────────────────────────────
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Header ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Go Premium',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock unlimited access and all premium features.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // ── Feature bullets ─────────────────────────
                ..._features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: cs.primary, size: 18),
                        const SizedBox(width: 10),
                        Text(f, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Package list ────────────────────────────────────
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            )
          else if (_packages == null || _packages!.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No plans available. Please try again later.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                itemCount: _packages!.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final pkg = _packages![i];
                  return _PackageCard(
                    package: pkg,
                    onTap: _isPurchasing ? null : () => _purchase(pkg),
                  );
                },
              ),
            ),

          // ── Restore + Close ─────────────────────────────────
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _isPurchasing || _packages == null
                        ? null
                        : () => _purchase(_packages!.first),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: cs.primary,
                    ),
                    child: _isPurchasing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Subscribe Now'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final restored = await ref
                              .read(paywallProvider.notifier)
                              .restorePurchases();
                          if (context.mounted) {
                            if (restored) {
                              Navigator.of(context).pop(true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('No purchases to restore.')),
                              );
                            }
                          }
                        },
                        child: const Text('Restore Purchase'),
                      ),
                      TextButton(
                        onPressed: () {
                          AnalyticsService.instance.logPaywallDismissed();
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          'Maybe Later',
                          style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.5)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<String> _features = [
    'Unlimited AI messages per day',
    'Access all premium content',
    'No ads',
    'Priority support',
  ];
}

class _PackageCard extends StatelessWidget {
  final Package package;
  final VoidCallback? onTap;
  const _PackageCard({required this.package, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final product = package.storeProduct;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.primary, width: 1.5),
          color: cs.primaryContainer.withValues(alpha: 0.15),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: theme.textTheme.titleSmall,
                  ),
                  if (product.description.isNotEmpty)
                    Text(
                      product.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              product.priceString,
              style: theme.textTheme.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
