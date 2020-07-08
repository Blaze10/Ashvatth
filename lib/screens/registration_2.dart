import 'dart:io';

import 'package:Ashvatth/pickers/image_picker.dart';
import 'package:Ashvatth/screens/registration_3.dart';
import 'package:Ashvatth/widgets/top_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Registration2 extends StatefulWidget {
  @override
  _Registration2State createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {

  File userImageFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                'Raj, Your connections accross the',
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
                        child: UserImagePicker(_pickedImage),
                      ),
                      RaisedButton(
                        child: Text(
                          'Continue',
                          style: TextStyle(fontSize: 18, fontFamily: 'Laila'),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (ctx) => Registration3()));
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
