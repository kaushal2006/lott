import 'package:flutter/material.dart';
import 'package:lott/mixins/theme_mixin.dart';
import 'package:lott/common/route_list.dart';
import 'package:lott/screens/home_screen.dart';
import 'package:lott/screens/splash_screen.dart';
import 'package:lott/screens/auth_screen.dart';
import 'package:lott/screens/root_screen.dart';

class Routes {
  Routes() {
    runApp(Root());
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with ThemeMixin {
  ThemeData _themeData;
  @override
  void initState() {
    super.initState();
    _themeData = buildThemeData2();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      checkerboardOffscreenLayers: false,
      title: 'Lott App',
      theme: _themeData,
      onGenerateRoute: routes,
    );
  }

  Route routes(RouteSettings settings) {
    switch (settings.name) {
      //case '/launcher':
      //return buildCustomRoute(LauncherScreen(), settings);
      case ROUTE_SCREEN:
        return buildCustomRoute(RootScreen(), settings);

      case ROUTE_AUTH:
        return buildCustomRoute(AuthScreen(), settings);

      case ROUTE_FORGOT_PASS:
      //return buildCustomRoute(ForgotPasswordScreen(), settings);

      case ROUTE_SPLASH:
        return buildCustomRoute(SplashScreen(), settings);

      case ROUTE_HOME:
        return buildCustomRoute(HomeScreen(), settings);
    }
    return buildCustomRoute(RootScreen(), settings);
  }
}

CustomRoute buildCustomRoute(Widget widget, RouteSettings settings) {
  return CustomRoute(
      builder: (_) {
        return widget;
      },
      settings: settings);
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return FadeTransition(opacity: animation, child: child);
  }
}
