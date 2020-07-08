import 'package:Ashvatth/screens/registration_2.dart';
import 'package:Ashvatth/widgets/input_form_field.dart';
import 'package:Ashvatth/widgets/top_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Registration1 extends StatelessWidget {
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
                'Nice to meet you!',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 16),
              ),
              // SizedBox(height: 8),
              Text(
                'What name do you go by',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 16),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.08),
                        child: Column(
                          children: <Widget>[
                            InputFormField(labelText: 'First Name'),
                            SizedBox(height: 16),
                            InputFormField(labelText: 'Last Name'),
                          ],
                        ),
                      ),
                      RaisedButton(
                        child: Text(
                          'Continue',
                          style: TextStyle(fontSize: 18, fontFamily: 'Laila'),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (ctx) => Registration2()));
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
}
