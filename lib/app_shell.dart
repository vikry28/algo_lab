import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme_provider.dart';
import 'core/constants/app_localizations.dart';
import 'core/services/notification_service.dart';
import 'core/config/screenutil_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final AppRouter _appRouter;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(navigatorKey: _navigatorKey);
    NotificationService.navigatorKey = _navigatorKey;
    _setupNotifications();
  }

  void _setupNotifications() {
    final notificationService = sl<NotificationService>();
    notificationService.onNotificationClick = (payload) {
      if (payload != null) {
        try {
          _appRouter.router.push('/achievements');
        } catch (e) {
          debugPrint('Navigation error: $e');
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilConfig.init(
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Algo Lab',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            routerConfig: _appRouter.router,
            locale: theme.locale,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('id')],
          );
        },
      ),
    );
  }
}
