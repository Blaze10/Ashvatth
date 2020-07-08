import 'package:Ashvatth/screens/registration_1.dart';
import 'package:Ashvatth/screens/registration_4.dart';
import 'package:Ashvatth/widgets/top_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TopLogo(),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Hello \nI\'m Ashvatth',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      SizedBox(height: 8),
                      Text('I will help you map \nyour family tree',
                          style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            'Hi, Ashvatth',
                            style: TextStyle(fontSize: 18, fontFamily: 'Laila'),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (ctx) => Registration1()));
                          },
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 12,
                          ),
                        ),
                        SizedBox(height: 16),
                        FlatButton(
                          child: Text(
                            'I already have an ccount',
                            style: TextStyle(
                              fontFamily: 'Laila',
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (ctx) => Registration4(isLogin: true),
                              )
                            );
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
