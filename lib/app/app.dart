import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/features/login/login_screen.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';

export 'package:wow_shopping/app/config.dart';

const _appTitle = 'Shop Wow';

class ShopWowApp extends StatefulWidget with WatchItStatefulWidgetMixin {
  const ShopWowApp({
    super.key,
    required this.config,
  });

  final AppConfig config;

  @override
  State<ShopWowApp> createState() => _ShopWowAppState();
}

class _ShopWowAppState extends State<ShopWowApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigatorState => _navigatorKey.currentState!;

  StreamSubscription<bool>? _subIsLoggedIn;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
  }

  Future<void> _loadApp() async {
    await initializeDateFormatting();
    await di.allReady();
    _subIsLoggedIn =
        di<AuthRepo>().streamIsLoggedIn.listen(_onLoginStateChanged);
  }

  @override
  void dispose() {
    _subIsLoggedIn?.cancel();
    super.dispose();
  }

  void _onLoginStateChanged(bool newIsLoggedIn) {
    if (_isLoggedIn && !newIsLoggedIn) {
      _isLoggedIn = newIsLoggedIn;
      navigatorState.pushAndRemoveUntil(LoginScreen.route(), (route) => false);
    } else if (!_isLoggedIn && newIsLoggedIn) {
      _isLoggedIn = newIsLoggedIn;
      navigatorState.pushAndRemoveUntil(MainScreen.route(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayDarkIcons,
      child: FutureBuilder<void>(
        future: _loadApp(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Theme(
              data: generateLightTheme(),
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: SplashScreen(),
              ),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: _navigatorKey,
              title: _appTitle,
              theme: generateLightTheme(),
              onGenerateRoute: (RouteSettings settings) {
                if (settings.name == Navigator.defaultRouteName) {
                  if (!_isLoggedIn) {
                    return LoginScreen.route();
                  }
                  return MainScreen.route();
                } else {
                  return null; // Page not found
                }
              },
            );
          }
        },
      ),
    );
  }
}
