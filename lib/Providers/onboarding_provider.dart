import 'dart:io';

import 'package:flutter/foundation.dart';

class OnboardingProvier extends ChangeNotifier {
  String _firstName;
  String _lastName;
  // String _username;
  File _profileImageFile;
  bool _isMarried;

  String get firstName => _firstName;
  get lastName => _lastName;
  // get userName => _username;
  get profileImageFile => _profileImageFile;
  get isMarried => _isMarried;

  setFirstName(String firstname) {
    _firstName = firstname;
    notifyListeners();
  }

  setLastname(String lastName) {
    _lastName = lastName;
    notifyListeners();
  }

  // setUsername(String username) {
  //   _username = username;
  //   notifyListeners();
  // }

  setProfileImageFile(File image) {
    _profileImageFile = image;
    notifyListeners();
  }

  setIsMarried(bool ismarried) {
    _isMarried = ismarried;
    notifyListeners();
  }
}
