import 'package:Ashvatth/Providers/onboarding_provider.dart';
import 'package:Ashvatth/screens/registration_complete.dart';
import 'package:Ashvatth/screens/user_home.dart';
import 'package:Ashvatth/widgets/input_form_field.dart';
import 'package:Ashvatth/widgets/top_logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Registration4 extends StatefulWidget {
  final bool isLogin;

  Registration4({this.isLogin = false});

  @override
  _Registration4State createState() => _Registration4State();
}

class _Registration4State extends State<Registration4> {
  var _phoneNumberController = TextEditingController();
  // var _otpController = TextEditingController();
  var _isLoading = false;
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String verificationId;

  String _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.trim().isEmpty ||
        phoneNumber.trim().length > 10 ||
        phoneNumber.trim().length < 10) {
      return 'Please enter a valid 10 digit mobile number';
    }
    return null;
  }

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
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
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
              if (!widget.isLogin)
                Text(
                  'One last thing,',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 16),
                ),
              if (widget.isLogin) SizedBox(height: 16),
              Text(
                !widget.isLogin
                    ? 'What is your mobile no. ?'
                    : 'Enter your registered mobile no.',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 16),
              ),
              if (!widget.isLogin) SizedBox(height: 8),
              if (!widget.isLogin)
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
                            Form(
                              key: _formKey,
                              child: InputFormField(
                                controller: _phoneNumberController,
                                labelText: '+91 XXXX-XXXXXX',
                                isRequired: true,
                                keyboardType: TextInputType.phone,
                                validatorFunction: _validatePhoneNumber,
                              ),
                            ),
                            // SizedBox(height: 10),
                            // InputFormField(
                            //   controller: _otpController,
                            //   labelText: 'Enter OTP',
                            //   keyboardType: TextInputType.phone,
                            //   hintText: 'XXXXXX',
                            // ),
                            if (verificationId != null)
                              SizedBox(height: 8),
                            if (verificationId != null)
                              Text(
                                'Sit back and relax..',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 18),
                              ),
                            // FlatButton(
                            //   padding: const EdgeInsets.all(0),
                            //   child: Text(
                            //     'Resend OTP',
                            //     style: TextStyle(
                            //       fontFamily: 'Laila',
                            //       color: Theme.of(context).primaryColor,
                            //       fontSize: 18,
                            //     ),
                            //   ),
                            //   onPressed: () {},
                            // ),
                          ],
                        ),
                      ),
                      if (!_isLoading)
                        RaisedButton(
                          child: Text(
                            'Request OTP',
                            style: TextStyle(fontSize: 18, fontFamily: 'Laila'),
                          ),
                          onPressed: _isLoading ? null : _onRequestOTP,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 12,
                          ),
                        ),
                      if (_isLoading)
                        Column(
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Text(
                              'Please wait...',
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                          ],
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

  // show hide loader
  _hideShowLoader(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  // on request otp
  _onRequestOTP() {
    if (_formKey.currentState.validate()) {
      _hideShowLoader(true);
      FirebaseAuth _auth = FirebaseAuth.instance;
      _auth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        timeout: Duration(seconds: 60),
        verificationCompleted: _verificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          _hideShowLoader(false);
          print(verificationId);
          _showErrorToast('Auto Retrieval Timeout', true);
        },
      );
    }
  }

  // ** OTP verficication complete for auto retrival ** //
  _verificationCompleted(AuthCredential authCredential) {
    // sign in
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signInWithCredential(authCredential).then((AuthResult result) async {
      bool saveUserData = await _saveDataToFirestore(
        _phoneNumberController.text,
        result.user.uid,
      );
      _hideShowLoader(false);
      if (saveUserData) {
        if (!widget.isLogin) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (ctx) => RegistrationComplete(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (ctx) => UserHomeScreen(),
            ),
          );
        }
      } else {
        if (widget.isLogin) {
          setState(() {
            verificationId = null;
          });
          _showErrorToast(
              'Login Failed. Make sure your account is registered.', true);
        } else {
          _showErrorToast('Some error occured, Please try again later', true);
        }
      }
    }).catchError((err) {
      _hideShowLoader(false);
      print(err.toString());
      _showErrorToast('Some error occured, Please try again later', true);
    });
  }

  // ***** OTP Verification Failed **** //
  _verificationFailed(AuthException exception) {
    _hideShowLoader(false);
    _showErrorToast(exception.message, true);
  }

  // **** User types OTP if auto retrival fails ****
  _onCodeSent(String verificationId, [int forceResendingToken]) {
    setState(() {
      this.verificationId = verificationId;
    });
    _showErrorToast('OTP Sent', false);
  }

  // save user data to firestore
  Future<bool> _saveDataToFirestore(String contact, String userId) async {
    try {
      var provider = Provider.of<OnboardingProvier>(context, listen: false);
      Firestore _db = Firestore.instance;

      if (widget.isLogin) {
        var userRef = (await _db.document('users/$userId').get());
        if (!userRef.exists) {
          FirebaseAuth.instance.signOut();
          return false;
        } else {
          // later update fcm tokens
          return true;
        }
      }

      if (!widget.isLogin) {
        var userRef = (await _db.document('users/$userId').get());
        if (userRef.exists) {
          return true;
        }
      }

      // ***** upload userimage ***** //

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile')
          .child(userId + '.jpg');
      await storageRef.putFile(provider.profileImageFile).onComplete;
      final imageUrl = await storageRef.getDownloadURL();

      //  ***** save date to firestore ***** //

      await _db.document('users/$userId').setData({
        'firstName': provider.firstName,
        'lastName': provider.lastName,
        'profileImageUrl': imageUrl,
        'isMarried': provider.isMarried,
        'contact': contact,
        'whenCreated': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  // showErrorToast
  _showErrorToast(String message, bool isError) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).errorColor
            : Theme.of(context).accentColor,
      ),
    );
  }

  // otp dialog
  // _openOtpDialog(String verificationId) {
  //   return showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (ctx) {
  //       return AlertDialog(
  //         title:
  //             Text('Enter OTP', style: Theme.of(context).textTheme.headline1),
  //         content: Column(
  //           children: <Widget>[
  //             Text(
  //               'We will try to auto retrive the otp, Sit back and relax',
  //               style: Theme.of(context).textTheme.subtitle1,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: InputFormField(
  //                 controller: _otpController,
  //                 keyboardType: TextInputType.number,
  //                 labelText: 'OTP',
  //                 hintText: 'XXXXXX',
  //                 isDisabled: _isLoading,
  //               ),
  //             )
  //           ],
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Confirm'),
  //             textColor: Theme.of(context).primaryColor,
  //             onPressed: () {
  //               String smsCode = _otpController.text.trim();

  //               if (smsCode.isEmpty ||
  //                   smsCode.length < 6 ||
  //                   smsCode.length > 6) {
  //                 _showErrorToast('Please enter a valid 6 digit OTP', true);
  //                 return;
  //               }
  //               AuthCredential _credential = PhoneAuthProvider.getCredential(
  //                 verificationId: verificationId,
  //                 smsCode: smsCode,
  //               );
  //               _verificationCompleted(_credential);
  //             },
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}
