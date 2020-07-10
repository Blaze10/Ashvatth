import 'package:Ashvatth/Providers/onboarding_provider.dart';
import 'package:Ashvatth/screens/registration_4.dart';
import 'package:Ashvatth/widgets/top_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Registration3 extends StatefulWidget {
  @override
  _Registration3State createState() => _Registration3State();
}

class _Registration3State extends State<Registration3> {
  bool isMarried = true;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<OnboardingProvier>(context, listen: false);
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
              // Text(
              //   'Raj',
              //   style: Theme.of(context)
              //       .textTheme
              //       .headline1
              //       .copyWith(fontSize: 16),
              // ),
              // SizedBox(height: 8),
              Text(
                'What is your marital status?',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Providing this would help us enable features \nwithin the app accordingly.',
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
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Container(
                            padding: const EdgeInsets.only(left: 28),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff8d6e52), width: 2),
                            ),
                            child: DropdownButton(
                              underline: SizedBox(),
                              value: isMarried,
                              isExpanded: true,
                              onChanged: onChangeMaritalStatus,
                              iconSize: 40,
                              iconEnabledColor: Colors.black,
                              items: [
                                DropdownMenuItem(
                                  child: Text(
                                    'Married',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontFamily: 'Laila',
                                    ),
                                  ),
                                  value: true,
                                ),
                                DropdownMenuItem(
                                  child: Text(
                                    'Single',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontFamily: 'Laila',
                                    ),
                                  ),
                                  value: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        child: Text(
                          'Continue',
                          style: TextStyle(fontSize: 18, fontFamily: 'Laila'),
                        ),
                        onPressed: () {
                          provider.setIsMarried(isMarried);
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (ctx) => Registration4()));
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

  onChangeMaritalStatus(bool value) {
    setState(() {
      isMarried = value;
    });
  }
}
