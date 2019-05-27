import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lott/singletons/app_data.dart';//import 'package:lott/mixins/app_utils_mixin.dart';
import 'package:lott/common/route_list.dart';

//https://medium.com/@vignesh_prakash/flutter-splash-screen-84fb0307ac55
//https://github.com/vignesh7501/flutter-UI-splash-screen
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(AppData().getNextSplash() != null ? AppData().getNextSplash() : ROUTE_HOME);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}