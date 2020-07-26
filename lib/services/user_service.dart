import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _db = Firestore.instance;

  // get current user data
  Future<dynamic> getCurrentUserData() async {
    try {
      String userId = (await FirebaseAuth.instance.currentUser()).uid;
      var userRef = (await _db.document('users/$userId').get());
      var userData = {"id": userRef.documentID, ...userRef.data};
      return userData;
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

      var userData = (await _db.document('users/$userId').get()).data;

      if (userData['isMarried'] != null && userData['isMarried']) {
        if (userData['gender'] != null) {
          if (userData['gender'] == 'Male') {
            relations.removeWhere((item) => (item == 'Husband'));
          } else {
            relations.removeWhere((item) => (item == 'Wife'));
          }
        }
      }

      List<String> list = List<String>();

      for (var el in relations) {
        if (el == "Father" || el == "Mother") {
          var ref =
              (await _db.document('users/$userId/addedMembers/$el').get());
          if (!ref.exists) {
            list.add(el);
          }
        } else {
          var userData = (await _db.document('users/$userId').get()).data;
          if ((el == 'Son' ||
              el == 'Daughter' ||
              el == 'Wife' ||
              el == 'Husband')) {
            if (userData['isMarried'] != null && userData['isMarried']) {
              if (el == 'Wife') {
                var ref = (await _db
                    .document('users/$userId/addedMembers/$el')
                    .get());
                if (!ref.exists) {
                  print('adding wife');
                  list.add(el);
                }
              } else if (el == 'Husband') {
                var ref = (await _db
                    .document('users/$userId/addedMembers/$el')
                    .get());
                if (!ref.exists) {
                  print('adding husband');
                  list.add(el);
                }
              } else {
                list.add(el);
              }
            }
          } else {
            list.add(el);
          }
        }
      }

      print('returning list');
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
      print('user parent relation userid: $userId');
      List<dynamic> list = List<dynamic>();

      // get father
      var fatherRef =
          (await _db.document('users/$userId/addedMembers/Father').get());

      if (fatherRef.exists) {
        var fatherData = {
          "id": fatherRef.documentID,
          ...fatherRef.data,
        };
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
        for (var item in list) {
          var collectionRef = (await _db
              .collection('users')
              .where('firstName', isEqualTo: item['firstName'])
              .where('middleName', isEqualTo: item['middleName'])
              .where('lastName', isEqualTo: item['lastName'])
              .where('motherName', isEqualTo: item['motherName'])
              .where('gender', isEqualTo: item['gender'])
              .where('isMarried', isEqualTo: item['isMarried'])
              .getDocuments());

          if (collectionRef != null && collectionRef.documents.length > 0) {
            var newData = {
              "id": collectionRef.documents[0].documentID,
              ...collectionRef.documents[0].data
            };

            var indx = list.indexWhere((item) =>
                (item['firstName'] == newData['firstName'] &&
                    item['lastName'] == newData['lastName'] &&
                    item['middleName'] == newData['middleName'] &&
                    item['motherName'] == newData['motherName'] &&
                    item['gender'] == newData['gender'] &&
                    item['isMarried'] == newData['isMarried']));

            if (indx != -1) {
              list[indx] = {
                ...item,
                "id": collectionRef.documents[0].documentID,
                ...collectionRef.documents[0].data,
                "relation": item['relation'],
                "path": "users/${collectionRef.documents[0].documentID}",
              };
            }
          }
        }
      }

      return list;
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
      // var userRef = (await _db.document('users/$userId').get());
      // list.add({"id": userRef.documentID, ...userRef.data});

      // get all brothers
      var brothersRef =
          (await _db.collection('users/$userId/addedMembers').getDocuments());

      if (brothersRef != null &&
          brothersRef.documents != null &&
          brothersRef.documents.length > 0) {
        brothersRef.documents.forEach((doc) {
          if (doc.data['relation'].toString().indexOf('Brother') != -1) {
            list.add({"id": doc.documentID, ...doc.data});
          }

          if (doc.data['relation'].toString().indexOf('Sister') != -1) {
            list.add({"id": doc.documentID, ...doc.data});
          }
        });
      }

      if (list.length > 0) {
        for (var item in list) {
          var collectionRef = (await _db
              .collection('users')
              .where('firstName', isEqualTo: item['firstName'])
              .where('middleName', isEqualTo: item['middleName'])
              .where('lastName', isEqualTo: item['lastName'])
              .where('motherName', isEqualTo: item['motherName'])
              .where('gender', isEqualTo: item['gender'])
              .where('isMarried', isEqualTo: item['isMarried'])
              .getDocuments());

          if (collectionRef != null && collectionRef.documents.length > 0) {
            var newData = {
              "id": collectionRef.documents[0].documentID,
              ...collectionRef.documents[0].data
            };

            var indx = list.indexWhere((item) =>
                (item['firstName'] == newData['firstName'] &&
                    item['lastName'] == newData['lastName'] &&
                    item['middleName'] == newData['middleName'] &&
                    item['motherName'] == newData['motherName'] &&
                    item['gender'] == newData['gender'] &&
                    item['isMarried'] == newData['isMarried']));

            if (indx != -1) {
              list[indx] = {
                ...item,
                "id": collectionRef.documents[0].documentID,
                ...collectionRef.documents[0].data,
                "relation": item['relation'],
                "path": "users/${collectionRef.documents[0].documentID}",
              };
            }
          }
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
      List<dynamic> list = List<dynamic>();

      // get all sons
      var sonsRef =
          (await _db.collection('users/$userId/addedMembers').getDocuments());

      if (sonsRef != null &&
          sonsRef.documents != null &&
          sonsRef.documents.length > 0) {
        sonsRef.documents.forEach((doc) {
          if (doc.data['relation'].toString().indexOf('Son') != -1) {
            list.add({"id": doc.documentID, ...doc.data});
          }
          if (doc.data['relation'].toString().indexOf('Daughter') != -1) {
            list.add({"id": doc.documentID, ...doc.data});
          }
        });
      }

      if (list.length > 0) {
        for (var item in list) {
          var collectionRef = (await _db
              .collection('users')
              .where('firstName', isEqualTo: item['firstName'])
              .where('middleName', isEqualTo: item['middleName'])
              .where('lastName', isEqualTo: item['lastName'])
              .where('motherName', isEqualTo: item['motherName'])
              .where('gender', isEqualTo: item['gender'])
              .where('isMarried', isEqualTo: item['isMarried'])
              .getDocuments());

          if (collectionRef != null && collectionRef.documents.length > 0) {
            var newData = {
              "id": collectionRef.documents[0].documentID,
              ...collectionRef.documents[0].data
            };

            var indx = list.indexWhere((item) =>
                (item['firstName'] == newData['firstName'] &&
                    item['lastName'] == newData['lastName'] &&
                    item['middleName'] == newData['middleName'] &&
                    item['motherName'] == newData['motherName'] &&
                    item['gender'] == newData['gender'] &&
                    item['isMarried'] == newData['isMarried']));

            if (indx != -1) {
              list[indx] = {
                ...item,
                "id": collectionRef.documents[0].documentID,
                ...collectionRef.documents[0].data,
                "relation": item['relation'],
                "path": "users/${collectionRef.documents[0].documentID}",
              };
            }
          }
        }
      }

      return list;
    } catch (err) {
      print('Error getting users son daughter relations');
      print(err.toString());
      return null;
    }
  }

  // get user by userId
  Future<Map<String, dynamic>> getUserById({String userId}) async {
    try {
      var userRef = (await _db.document('users/$userId').get());

      if (!userRef.exists) {
        return null;
      }

      return {"id": userRef.documentID, ...userRef.data};
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // get wife
  Future<Map<String, dynamic>> getWifeRelation({String userId}) async {
    try {
      var wifeRef =
          (await _db.document('users/$userId/addedMembers/Wife').get());

      if (!wifeRef.exists) {
        return null;
      }

      var wifeData = {"id": wifeRef.documentID, ...wifeRef.data};

      var collectionRef = (await _db
          .collection('users')
          .where('firstName', isEqualTo: wifeData['firstName'])
          .where('middleName', isEqualTo: wifeData['middleName'])
          .where('lastName', isEqualTo: wifeData['lastName'])
          .where('motherName', isEqualTo: wifeData['motherName'])
          .where('gender', isEqualTo: wifeData['gender'])
          .where('isMarried', isEqualTo: wifeData['isMarried'])
          .getDocuments());

      if (collectionRef != null && collectionRef.documents.length > 0) {
        wifeData = {
          ...wifeData,
          "id": collectionRef.documents[0].documentID,
          ...collectionRef.documents[0].data,
          "relation": wifeData['relation'],
          "path": "users/${collectionRef.documents[0].documentID}",
        };
      }

      return wifeData;
    } catch (err) {
      print(err.toString());
      print('Error getting wife relations');
      return null;
    }
  }

  Future<Map<String, dynamic>> getHusbandRelation({String userId}) async {
    try {
      var husbandRef =
          (await _db.document('users/$userId/addedMembers/Husband').get());

      if (!husbandRef.exists) {
        return null;
      }

      var husbandData = {"id": husbandRef.documentID, ...husbandRef.data};

      var collectionRef = (await _db
          .collection('users')
          .where('firstName', isEqualTo: husbandData['firstName'])
          .where('middleName', isEqualTo: husbandData['middleName'])
          .where('lastName', isEqualTo: husbandData['lastName'])
          .where('motherName', isEqualTo: husbandData['motherName'])
          .where('gender', isEqualTo: husbandData['gender'])
          .where('isMarried', isEqualTo: husbandData['isMarried'])
          .getDocuments());

      if (collectionRef != null && collectionRef.documents.length > 0) {
        husbandData = {
          ...husbandData,
          "id": collectionRef.documents[0].documentID,
          ...collectionRef.documents[0].data,
          "relation": husbandData['relation'],
          "path": "users/${collectionRef.documents[0].documentID}",
        };
      }

      return husbandData;
    } catch (err) {
      print(err.toString());
      print('Error getting wife relations');
      return null;
    }
  }

  // get user members data
  Future<Map<String, dynamic>> getUserMemberDataByPath(String docPath) async {
    try {
      var userRef = (await _db.document(docPath).get());
      var userData = {"id": userRef.documentID, ...userRef.data};

      print(userData.toString());

      // check in database if user exists
      var dbRef = (await _db
          .collection('users')
          .where('firstName', isEqualTo: userRef.data['firstName'] ?? '')
          .where('middleName', isEqualTo: userRef.data['middleName'] ?? '')
          .where('lastName', isEqualTo: userRef.data['lastName'] ?? '')
          .getDocuments());

      print(dbRef.documents.length);

      // check is found
      if (dbRef != null && dbRef.documents.length > 0) {
        print('Innn');
        // print(dbRef.documents[0].documentID);
        userData = {...userData, "matchUserId": dbRef.documents[0].documentID};
        return userData;
      } else {
        return userData;
      }
    } catch (err) {
      print(err.toString());
      print('Error getting added member data');
      return null;
    }
  }

  // get all members from the database
  Future<List<Map<String, dynamic>>> getAllMembers() async {
    try {
      List<Map<String, dynamic>> userList = [];
      List<Map<String, dynamic>> membersList = [];

      // get all users
      var userRef = (await _db.collection('users').getDocuments());
      var refList = userRef.documents
          .map((e) =>
              {"id": e.documentID, ...e.data, "path": "users/${e.documentID}"})
          .toList();
      userList = [...refList];

      if (userList != null && userList.length > 0) {
        for (var user in userList) {
          var addedMembersRef = (await _db
              .collection('users/${user['id']}/addedMembers')
              .getDocuments());

          if (addedMembersRef != null &&
              addedMembersRef.documents != null &&
              addedMembersRef.documents.length > 0) {
            var addedMembersList = addedMembersRef.documents
                .map((e) => {
                      "id": e.documentID,
                      ...e.data,
                      "path": "users/${user['id']}/addedMembers/${e.documentID}"
                    })
                .toList();

            for (var mem in addedMembersList) {
              var exists = userList.any((u) =>
                  (u['firstName'] == mem['firstName'] &&
                      u['middleName'] == mem['middleName'] &&
                      u['lastName'] == mem['lastName'] &&
                      u['motherName'] == mem['motherName']));

              if (!exists) {
                membersList.add(mem);
              }
            }
          }
        }
      }
      userList = [...userList, ...membersList];
      return userList;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // get dashboard cards data
  Future<Map<String, int>> getDashboardStats() async {
    try {
      var registeredUsersCount = 0;
      var tempUserList = [];
      List<String> familyList = [];

      var userRef = (await _db.collection('users').getDocuments());
      if (userRef != null && userRef.documents.length > 0) {
        registeredUsersCount = userRef.documents.length;
        var list = userRef.documents.map((e) => e.data).toList();
        tempUserList = userRef.documents
            .map((e) => {"id": e.documentID, ...e.data})
            .toList();
        for (var user in list) {
          if (!familyList
              .any((el) => el.toLowerCase().indexOf(user['lastName']) != -1)) {
            familyList.add(user['lastName']);
          }
        }
      }

      for (var user in tempUserList) {
        var memberRef = (await _db
            .collection('users/${user['id']}/addedMembers')
            .getDocuments());

        if (memberRef != null && memberRef.documents.length > 0) {
          var list = memberRef.documents.map((e) => e.data).toList();
          for (var user in list) {
            if (!(familyList.any((el) =>
                el.toLowerCase() ==
                user['lastName'].toString().toLowerCase()))) {
              familyList.add(user['lastName']);
            }
          }
        }
      }

      return {
        "registeredCount": registeredUsersCount,
        "familyCount": familyList.toSet().length
      };
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
