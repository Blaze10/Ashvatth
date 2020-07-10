import 'package:Ashvatth/Providers/onboarding_provider.dart';
import 'package:Ashvatth/screens/registration_2.dart';
import 'package:Ashvatth/widgets/input_form_field.dart';
import 'package:Ashvatth/widgets/top_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Registration1 extends StatefulWidget {
  @override
  _Registration1State createState() => _Registration1State();
}

class _Registration1State extends State<Registration1> {
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.08),
                          child: Column(
                            children: <Widget>[
                              InputFormField(
                                labelText: 'First Name',
                                controller: _firstNameController,
                                isRequired: true,
                              ),
                              SizedBox(height: 16),
                              InputFormField(
                                labelText: 'Last Name',
                                controller: _lastNameController,
                                isRequired: true,
                              ),
                              // SizedBox(height: 16),
                              // InputFormField(
                              //   labelText: 'Choose your username',
                              // ),
                            ],
                          ),
                        ),
                        RaisedButton(
                          child: Text(
                            'Continue',
                            style: TextStyle(fontSize: 18, fontFamily: 'Laila'),
                          ),
                          onPressed: _onContinue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 12,
                          ),
                        ),
                      ],
                    ),
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

  _onContinue() {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      var provider = Provider.of<OnboardingProvier>(context, listen: false);
      print(_firstNameController.text);
      provider.setFirstName(_firstNameController.text.trim());
      provider.setLastname(_lastNameController.text.trim());
      Navigator.of(context)
          .push(CupertinoPageRoute(builder: (ctx) => Registration2()));
    }
  }
}
