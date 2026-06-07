import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/core/onboarding/onboarding_provider.dart';
import 'package:flutter_template/core/onboarding/onboarding_slide.dart';
import 'package:flutter_template/core/analytics/analytics_service.dart';
import 'package:flutter_template/core/paywall/paywall_modal.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 3;

  // Slide data pulled from localization strings
  List<_SlideData> get _slides => [
        _SlideData(
          title: 'onboarding.slide1_title'.tr(),
          subtitle: 'onboarding.slide1_subtitle'.tr(),
          icon: Icons.bolt_rounded,
          iconColor: const Color(0xFF6C63FF),
          bgColor: const Color(0xFF6C63FF),
        ),
        _SlideData(
          title: 'onboarding.slide2_title'.tr(),
          subtitle: 'onboarding.slide2_subtitle'.tr(),
          icon: Icons.auto_awesome,
          iconColor: const Color(0xFF00BFA5),
          bgColor: const Color(0xFF00BFA5),
        ),
        _SlideData(
          title: 'onboarding.slide3_title'.tr(),
          subtitle: 'onboarding.slide3_subtitle'.tr(),
          icon: Icons.workspace_premium,
          iconColor: const Color(0xFFFFD700),
          bgColor: const Color(0xFFFFD700),
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    AnalyticsService.instance
        .logOnboardingSkipped(slideIndex: _currentPage);
    _completeAndContinue();
  }

  Future<void> _completeAndContinue() async {
    await ref.read(onboardingProvider.notifier).complete();
    await AnalyticsService.instance.logOnboardingCompleted();
    if (mounted) context.go('/auth');
  }

  void _showPaywall() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PaywallModal(source: 'onboarding'),
    ).then((_) => _completeAndContinue());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isLastPage = _currentPage == _totalPages - 1;
    final slides = _slides;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 8.h),
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'common.skip'.tr(),
                    style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.5)),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (i) =>
                    setState(() => _currentPage = i),
                itemBuilder: (_, i) {
                  final s = slides[i];
                  return OnboardingSlide(
                    title: s.title,
                    subtitle: s.subtitle,
                    icon: s.icon,
                    iconColor: s.iconColor,
                    backgroundColor: s.bgColor,
                  );
                },
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalPages,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: i == _currentPage ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? cs.primary
                        : cs.outline,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // CTA buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isLastPage) ...[
                    ElevatedButton(
                      onPressed: _showPaywall,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(52.h),
                        backgroundColor: cs.primary,
                      ),
                      child: Text('onboarding.get_premium'.tr()),
                    ),
                    SizedBox(height: 12.h),
                    OutlinedButton(
                      onPressed: _completeAndContinue,
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size.fromHeight(52.h)),
                      child: Text('onboarding.start_free'.tr()),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(52.h)),
                      child: Text('common.next'.tr()),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _SlideData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _SlideData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}
