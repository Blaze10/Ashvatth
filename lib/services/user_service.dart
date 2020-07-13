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

  // get relations
  Future<List<String>> checkRelation(List<String> relations) async {
    try {
      String userId = (await FirebaseAuth.instance.currentUser()).uid;

      // var userData = (await _db.document('users/$userId').get()).data;

      // if (userData['isMarried'] != null && !userData['isMarried']) {
      //   relations.removeWhere(
      //       (item) => (item == 'Wife' || item == 'Son' || item == 'Daughter'));
      // }

      List<String> list = List<String>();

      relations.forEach((el) async {
        if (el == "Grandfather" ||
            el == "Grandmother" ||
            el == "Father" ||
            el == "Mother") {
          var ref =
              (await _db.document('users/$userId/addedMembers/$el').get());
          if (!ref.exists) {
            list.add(el);
          }
        } else {
          var userData = (await _db.document('users/$userId').get()).data;
          if ((el == 'Son' || el == 'Daughter' || el == 'Wife')) {
            if (userData['isMarried'] != null && userData['isMarried']) {
              list.add(el);
            }
          } else {
            list.add(el);
          }
        }
      });

      print(list.toString());
      return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // ****** get added relations ******
  Future<List<Map<String, dynamic>>> getAddedRelations() async {
    try {
      var userId = (await FirebaseAuth.instance.currentUser()).uid;
      var addedMemberCollectionRef =
          (await _db.collection('users/$userId/addedMembers').getDocuments());

      var list = addedMemberCollectionRef.documents
          .map((doc) => {
                "id": doc.documentID,
                ...doc.data,
              })
          .toList();

      return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
