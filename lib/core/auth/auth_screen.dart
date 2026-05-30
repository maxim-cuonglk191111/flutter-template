import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'auth_service.dart';
import '../../core/analytics/analytics_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final cred = await AuthService.instance.signInWithGoogle();
      if (cred != null && mounted) {
        await AnalyticsService.instance.logSignIn(method: 'google');
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${'auth.sign_in_failed'.tr()}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInAnonymously() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.instance.signInAnonymously();
      if (mounted) {
        await AnalyticsService.instance.logSignIn(method: 'anonymous');
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('errors.auth_failed'.tr())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                Center(
                  child: Container(
                    width: 96.w,
                    height: 96.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [cs.primary, cs.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: cs.onPrimary,
                      size: 48.sp,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                Text(
                  'auth.welcome'.tr(),
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(fontSize: 32.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'auth.sign_in_subtitle'.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onSurface.withOpacity(0.6),
                    fontSize: 15.sp,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 3),

                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _GoogleSignInButton(onTap: _signInWithGoogle),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(child: Divider(color: cs.outline)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w),
                                child: Text(
                                  'or',
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        cs.onSurface.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: cs.outline)),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          OutlinedButton(
                            onPressed: _signInAnonymously,
                            child: Text('auth.continue_as_guest'.tr()),
                          ),
                        ],
                      ),

                SizedBox(height: 24.h),
                Text(
                  'auth.legal_notice'.tr(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.4),
                    fontSize: 11.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GoogleSignInButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding:
              EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: cs.outline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: const Color(0xFF4285F4),
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'auth.continue_with_google'.tr(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: cs.onSurface,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
