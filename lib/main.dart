import 'package:Ashvatth/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ashvatth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff341C10),
        accentColor: Color(0xffDD8933),
        fontFamily: 'Rajdhani',
        textTheme: TextTheme(
          headline1: TextStyle(
            color:  Color(0xff341C10),
            fontFamily: 'Laila',
            fontSize: 24,
          ),
          subtitle1: TextStyle(
            color:  Color(0xff341C10),
            fontSize: 20,
          ),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          buttonColor: Color(0xff341C10),
          textTheme: ButtonTextTheme.primary,
        ),
        scaffoldBackgroundColor: Color(0xfff5f5f5),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}