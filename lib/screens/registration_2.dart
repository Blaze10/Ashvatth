import 'dart:io';

import 'package:Ashvatth/Providers/onboarding_provider.dart';
import 'package:Ashvatth/pickers/image_picker.dart';
import 'package:Ashvatth/screens/registration_3.dart';
import 'package:Ashvatth/widgets/top_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Registration2 extends StatefulWidget {
  @override
  _Registration2State createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {
  File userImageFile;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<OnboardingProvier>(context, listen: false);
    print(provider.firstName);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.keyboard_backspace, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                    color: Color(0xff8d6e52),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 45),
                      child: TopLogo(),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(
                '${provider.firstName}, Your connections accross the',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 16),
              ),
              // SizedBox(height: 8),
              Text(
                'patform would like to see how you look',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Add a picture of yourself',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 16),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.08),
                        child: UserImagePicker(imagePickedFn: _pickedImage),
                      ),
                      RaisedButton(
                        child: Text(
                          'Continue',
                          style: TextStyle(fontSize: 18, fontFamily: 'Laila'),
                        ),
                        onPressed: () {
                          if (userImageFile == null) {
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Picture is required'),
                                backgroundColor: Theme.of(context).errorColor,
                              ),
                            );
                          } else {
                            provider.setProfileImageFile(userImageFile);
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (ctx) => Registration3()));
                          }
                        },
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  void _pickedImage(File image) {
    setState(() {
      userImageFile = image;
    });
  }
}
