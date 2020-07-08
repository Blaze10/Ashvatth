import 'package:Ashvatth/screens/registration_complete.dart';
import 'package:Ashvatth/widgets/input_form_field.dart';
import 'package:Ashvatth/widgets/top_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Registration4 extends StatelessWidget {
  final bool isLogin;

  Registration4({this.isLogin = false});

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
              if (!isLogin)
              Text(
                'One last thing Raj,',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 16),
              ),
              if (isLogin)
              SizedBox(height: 16),
              Text(
                !isLogin ? 'What is your mobile no. ?' : 'Enter your registered mobile no.',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 16),
              ),
              if (!isLogin)
              SizedBox(height: 8),
              if (!isLogin)
              Text(
                'We promise not to call and disturb you.',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
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
                            horizontal:
                                MediaQuery.of(context).size.width * 0.08),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            InputFormField(
                              labelText: '+91 XXXX-XXXXXX',
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '01:00 till OTP expires...',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 16),
                            ),
                            FlatButton(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                'Resend OTP',
                                style: TextStyle(
                                  fontFamily: 'Laila',
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        child: Text(
                          'Request OTP',
                          style: TextStyle(fontSize: 18, fontFamily: 'Laila'),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(CupertinoPageRoute(
                              builder: (ctx) => RegistrationComplete()));
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
