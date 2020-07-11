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

  // get user by username
  Future<dynamic> getUserByUsername(String username) async {
    try {
      var userSnap = (await _db
              .collection('users')
              .where('username', isEqualTo: username)
              .getDocuments())
          .documents[0];

      return userSnap.data;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // get usernames lsit
  Future<List<dynamic>> getUsernameList() async {
    try {
      var collectionRef = (await _db.collection('usernames').getDocuments());
      var list = collectionRef.documents.map((doc) => doc.data).toList();
      return list;
    } catch (err) {
      print('Error getting usernames list');
      return null;
    }
  }
}
