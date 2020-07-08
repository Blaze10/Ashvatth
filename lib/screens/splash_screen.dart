import 'dart:async';

import 'package:Ashvatth/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _initialOpactiy = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _initialOpactiy = 1;
      });

      Timer(Duration(milliseconds: 2500), () {
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (ctx) => HomeScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _initialOpactiy,
          duration: Duration(milliseconds: 1500),
          curve: Curves.easeOut,
          child: Image.asset(
            'assets/logo.png',
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
        ),
      ),
    );
  }
}
