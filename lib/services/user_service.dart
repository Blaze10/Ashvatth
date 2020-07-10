import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _db = Firestore.instance;

  // get current user data
  Future<dynamic> getCurrentUserData() async {
    try {
      String userId = (await FirebaseAuth.instance.currentUser()).uid;
      var userRef = (await _db.document('users/$userId').get());
      return userRef.data;
    } catch (err) {
      print('Error getting user data');
      return null;
    }
  }
}
