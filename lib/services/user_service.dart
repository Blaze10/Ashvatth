import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _db = Firestore.instance;

  // get current user data
  Future<dynamic> getCurrentUserData() async {
    try {
      String userId = (await FirebaseAuth.instance.currentUser()).uid;
      var userRef = (await _db.document('users/$userId').get());
      return {"id": userRef.documentID, ...userRef.data};
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

      return {"id": userSnap.documentID, ...userSnap.data};
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

  // get user parent relations
  Future<List<dynamic>> getUserParentRelations({String userId}) async {
    try {
      List<dynamic> list = List<dynamic>();

      // get father
      var fatherRef =
          (await _db.document('users/$userId/addedMembers/Father').get());

      if (fatherRef.exists) {
        var fatherData = {"id": fatherRef.documentID, ...fatherRef.data};
        list.add(fatherData);
      }

      // get mother
      var motherRef =
          (await _db.document('users/$userId/addedMembers/Mother').get());

      if (motherRef.exists) {
        var motherData = {"id": motherRef.documentID, ...motherRef.data};
        list.add(motherData);
      }

      if (list.length > 0) {
        return list;
      }

      return null;
    } catch (err) {
      print('Error getting users parent relations');
      print(err.toString());
      return null;
    }
  }

  // get borther and sister
  Future<List<dynamic>> getUserBrotherAndSisters({String userId}) async {
    try {
      List<dynamic> list = List<dynamic>();

      // get user data
      var userRef = (await _db.document('users/$userId').get());
      list.add({"id": userRef.documentID, ...userRef.data});

      // get all brothers
      var brothersRef = (await _db
          .collection('users/$userId/addedMembers')
          .where('relation', isEqualTo: 'Brother')
          .getDocuments());

      if (brothersRef != null &&
          brothersRef.documents != null &&
          brothersRef.documents.length > 0) {
        brothersRef.documents.forEach((broDoc) {
          list.add({"id": broDoc.documentID, ...broDoc.data});
        });

        // get all sisters
        var sisterRef = (await _db
            .collection('users/$userId/addedMembers')
            .where('relation', isEqualTo: 'Sister')
            .getDocuments());

        if (sisterRef != null &&
            sisterRef.documents != null &&
            sisterRef.documents.length > 0) {
          sisterRef.documents.forEach((sisDoc) {
            list.add({"id": sisDoc.documentID, ...sisDoc.data});
          });
        }
      }

      return list;
    } catch (err) {
      print('Error getting users brother sister relations');
      print(err.toString());
      return null;
    }
  }

  // get son and daugher
  Future<List<dynamic>> getSonAndDaughter({String userId}) async {
    try {
      print('userId: $userId');
      List<dynamic> list = List<dynamic>();

      // get all sons
      var sonsRef = (await _db
          .collection('users/$userId/addedMembers')
          .where('relation', isEqualTo: 'Son')
          .getDocuments());

      if (sonsRef != null &&
          sonsRef.documents != null &&
          sonsRef.documents.length > 0) {
        sonsRef.documents.forEach((sonDoc) {
          list.add({"id": sonDoc.documentID, ...sonDoc.data});
        });

        // get all daughterRef
        var daughterRef = (await _db
            .collection('users/$userId/addedMembers')
            .where('relation', isEqualTo: 'Daughter')
            .getDocuments());

        if (daughterRef != null &&
            daughterRef.documents != null &&
            daughterRef.documents.length > 0) {
          daughterRef.documents.forEach((doc) {
            list.add({"id": doc.documentID, ...doc.data});
          });
        }
      }

      if (list != null && list.length > 0) {
        return list;
      }

      return null;
    } catch (err) {
      print('Error getting users son daughter relations');
      print(err.toString());
      return null;
    }
  }
}
