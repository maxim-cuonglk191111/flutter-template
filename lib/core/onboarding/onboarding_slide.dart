import 'package:flutter/material.dart';

/// A single onboarding slide. Configurable via constructor parameters.
class OnboardingSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const OnboardingSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Illustration ────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 64, color: iconColor),
              ),
            ),
          ),
          const SizedBox(height: 48),

          // ── Title ───────────────────────────────────────────
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // ── Subtitle ────────────────────────────────────────
          Text(
            subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
