import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/app_config.dart';
import 'router/app_router.dart';
import 'core/settings/settings_screen.dart';
import 'shared_ui/theme/app_theme.dart';

/// Root widget of the app.
///
/// Wrapping order (outer → inner):
///   EasyLocalization (main.dart)
///     ProviderScope (main.dart)
///       App (here)
///         ScreenUtilInit
///           MaterialApp.router
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return ScreenUtilInit(
      // Base design canvas — matches AppConfig values
      designSize: Size(AppConfig.designWidth, AppConfig.designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: AppConfig.appName,

          // ── Theme ───────────────────────────────────────────
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,

          // ── Routing ─────────────────────────────────────────
          routerConfig: router,

          // ── Localization (easy_localization delegates) ───────
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
