import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RelationsService {
  final db = Firestore.instance;
  final auth = FirebaseAuth.instance;

  // generate relationships for users who are not registered

  Future<List<Map<String, dynamic>>> generateMotherFatherRelation(
      {@required Map<String, dynamic> userData}) async {
    try {
      List<Map<String, dynamic>> list = [];
      bool fatherFound = false;
      bool motherFound = false;

      var canFatherCollection = (await db.collection('users').getDocuments());

      // return if no such users are found
      if (canFatherCollection == null ||
          canFatherCollection.documents == null ||
          canFatherCollection.documents.length <= 0) {
        print('No users found');
        return null;
      }

      var canFatherList = canFatherCollection.documents
          .map((doc) => {"id": doc.documentID, ...doc.data})
          .toList();

      for (var mem in canFatherList) {
        if (userData['isMarried'] && userData['gender'] == 'Female') {
          if (mem['firstName'].toString().indexOf(userData['fatherName']) !=
              -1) {
            list.add(
                {"relation": "Father", "path": "users/${mem['id']}", ...mem});
            fatherFound = true;
          }
        } else {
          if (mem['firstName'].toString().indexOf(userData['middleName']) !=
              -1) {
            list.add(
                {"relation": "Father", "path": "users/${mem['id']}", ...mem});
            fatherFound = true;
          }
        }
        if (fatherFound) break;
      }

      if (!fatherFound) {
        for (var mem in canFatherList) {
          QuerySnapshot memAddedMembersRef;
          if (userData['gender'] == 'Female' && userData['isMarried']) {
            memAddedMembersRef = (await db
                .collection('users/${mem['id']}/addedMembers')
                .where('gender', isEqualTo: 'Male')
                .where('firstName', isEqualTo: userData['fatherName'])
                .where('lastName', isEqualTo: userData['oldSurname'])
                .getDocuments());
          } else {
            memAddedMembersRef = (await db
                .collection('users/${mem['id']}/addedMembers')
                .where('gender', isEqualTo: 'Male')
                .where('firstName', isEqualTo: userData['middleName'])
                .where('lastName', isEqualTo: userData['lastName'])
                .getDocuments());
          }

          if (memAddedMembersRef != null &&
              memAddedMembersRef.documents != null &&
              memAddedMembersRef.documents.length > 0) {
            var memAddedList = memAddedMembersRef.documents
                .map((doc) => {"id": doc.documentID, ...doc.data})
                .toList();

            for (var el in memAddedList) {
              if (userData['isMarried'] && userData['gender'] == 'Female') {
                if (el['firstName']
                        .toString()
                        .indexOf(userData['fatherName']) !=
                    -1) {
                  list.add({
                    "relation": "Father",
                    "path": "users/${mem['id']}/addedMembers/${el['id']}",
                    ...el
                  });
                  fatherFound = true;
                }
              } else {
                if (el['firstName']
                        .toString()
                        .indexOf(userData['middleName']) !=
                    -1) {
                  list.add({
                    "relation": "Father",
                    "path": "users/${mem['id']}/addedMembers/${el['id']}",
                    ...el
                  });
                  fatherFound = true;
                }
              }
              if (fatherFound) break;
            }
          }
        }
      }

      // checking for father complete

      // ** check for mother now ** //

      for (var mem in canFatherList) {
        if (mem['firstName'].toString().indexOf(userData['motherName']) != -1) {
          list.add(
              {"relation": "Mother", "path": "users/${mem['id']}", ...mem});
          motherFound = true;
        }
        if (motherFound) break;
      }

      if (!motherFound) {
        for (var mem in canFatherList) {
          var memAddedMembersRef = (await db
              .collection('users/${mem['id']}/addedMembers')
              .where('gender', isEqualTo: 'Female')
              .where('firstName', isEqualTo: userData['motherName'])
              .where('lastName', isEqualTo: userData['lastName'])
              .getDocuments());

          if (memAddedMembersRef != null &&
              memAddedMembersRef.documents != null &&
              memAddedMembersRef.documents.length > 0) {
            var memAddedList = memAddedMembersRef.documents
                .map((doc) => {"id": doc.documentID, ...doc.data})
                .toList();

            for (var el in memAddedList) {
              if (el['firstName'].toString().indexOf(userData['motherName']) !=
                  -1) {
                list.add({
                  "relation": "Mother",
                  "path": "users/${mem['id']}/addedMembers/${el['id']}",
                  ...el
                });
                motherFound = true;
              }
              if (motherFound) break;
            }
          }
        }
      }

      return list;
    } catch (err) {
      print('Error generating mother father relation');
      print(err.toString());
      return null;
    }
  }

  // check for husband or wife
  Future<Map<String, dynamic>> generateSpouseRelations(
      {@required Map<String, dynamic> userData}) async {
    try {
      bool spouseFound = false;
      var spouse;

      var usersCollection = (await db.collection('users').getDocuments());

      // return if no such users are found
      if (usersCollection == null ||
          usersCollection.documents == null ||
          usersCollection.documents.length <= 0) {
        print('No users found while generating spouse relations');
        return null;
      }

      var usersList = usersCollection.documents
          .map((doc) => {"id": doc.documentID, ...doc.data})
          .toList();

      print('Users List length ${usersList.length}');

      for (var mem in usersList) {
        if (userData['gender'] == 'Female') {
          // check for husband
          if ((mem['firstName'].toString().indexOf(userData['middleName']) !=
              -1)) {
            spouse = {
              "relation": "Husband",
              "path": "users/${mem['id']}",
              ...mem
            };
            spouseFound = true;
          }
        } else {
          // check for wife
          if ((mem['middleName'].toString().indexOf(userData['firstName']) !=
                  -1) &&
              mem['isMarried']) {
            spouse = {"relation": "Wife", "path": "users/${mem['id']}", ...mem};
          }
        }
        if (spouseFound) break;
      }

      // check in added members
      if (!spouseFound) {
        for (var mem in usersList) {
          QuerySnapshot addedMembersRef;
          if (userData['gender'] == 'Male') {
            addedMembersRef = (await db
                .collection('users/${mem['id']}/addedMembers')
                .where('gender', isEqualTo: 'Female')
                .where('lastName', isEqualTo: userData['lastName'])
                .where('middleName', isEqualTo: userData['firstName'])
                .getDocuments());
          } else {
            print('Called');
            print('${mem['id']}');
            addedMembersRef = (await db
                .collection('users/${mem['id']}/addedMembers')
                .where('gender', isEqualTo: 'Male')
                .where('firstName', isEqualTo: userData['middleName'])
                .where('lastName', isEqualTo: userData['lastName'])
                .getDocuments());
          }

          print('Called');
          if (addedMembersRef != null &&
              addedMembersRef.documents != null &&
              addedMembersRef.documents.length > 0) {
            print('Called');
            print(addedMembersRef.documents[0].data.toString());
            spouse = {
              "relation": (userData['gender'] == 'Male') ? 'Wife' : 'Husband',
              "id": addedMembersRef.documents[0].documentID,
              "path":
                  "users/${mem['id']}/addedMembers/${addedMembersRef.documents[0].documentID}",
              ...addedMembersRef.documents[0].data,
            };
          }
        }
      }

      return spouse;
    } catch (err) {
      print(err.toString());
      print('Error generating spouse relations');
      return null;
    }
  }

  // generate brother sister relations

  Future<List<Map<String, dynamic>>> generateSiblingRelations(
      {@required Map<String, dynamic> userData}) async {
    try {
      List<Map<String, dynamic>> relationList = [];

      var usersCollection = (await db.collection('users').getDocuments());

      // return if no such users are found
      if (usersCollection == null ||
          usersCollection.documents == null ||
          usersCollection.documents.length <= 0) {
        print('No users found while generating siblings relations');
        return null;
      }

      var usersList = usersCollection.documents
          .map((doc) => {"id": doc.documentID, ...doc.data})
          .toList();

      for (var mem in usersList) {
        // check for brothers

        if (mem['gender'] == 'Male') {
          if ((userData['gender'] == 'Male' || !userData['isMarried']) &&
              (mem['middleName'].toString().indexOf(userData['middleName']) !=
                  -1) &&
              (mem['lastName'].toString().indexOf(userData['lastName']) !=
                  -1)) {
            var exists = relationList.any((el) => el['id'] == mem['id']);
            if (!exists) {
              relationList.add({
                "relation": "Brother",
                "path": "users/${mem['id']}",
                ...mem
              });
            }
          }

          if ((userData['gender'] == 'Female' && userData['isMarried']) &&
              (mem['middleName'].toString().indexOf(userData['fatherName']) !=
                  -1) &&
              (mem['lastName'].toString().indexOf(userData['oldSurname']) !=
                  -1)) {
            var exists = relationList.any((el) => el['id'] == mem['id']);
            if (!exists) {
              relationList.add({
                "relation": "Brother",
                "path": "users/${mem['id']}",
                ...mem
              });
            }
          }
        }
        // check for sisters
        if (mem['gender'] == 'Female') {
          if (mem['isMarried']) {
            if (userData['isMarried']) {
              if (userData['gender'] == 'Male') {
                if ((mem['fatherName']
                            .toString()
                            .indexOf(userData['middleName']) !=
                        -1) &&
                    (mem['oldSurname']
                            .toString()
                            .indexOf(userData['lastName']) !=
                        -1)) {
                  var exists = relationList.any((el) => el['id'] == mem['id']);
                  if (!exists) {
                    relationList.add({
                      "relation": "Sister",
                      "path": "users/${mem['id']}",
                      ...mem
                    });
                  }
                }
              } else {
                if ((mem['fatherName']
                            .toString()
                            .indexOf(userData['fatherName']) !=
                        -1) &&
                    (mem['oldSurname']
                            .toString()
                            .indexOf(userData['oldSurname']) !=
                        -1)) {
                  var exists = relationList.any((el) => el['id'] == mem['id']);
                  if (!exists) {
                    relationList.add({
                      "relation": "Sister",
                      "path": "users/${mem['id']}",
                      ...mem
                    });
                  }
                }
              }
            } else {
              if ((mem['fatherName']
                          .toString()
                          .indexOf(userData['middleName']) !=
                      -1) &&
                  (mem['oldSurname'].toString().indexOf(userData['lastName']) !=
                      -1)) {
                var exists = relationList.any((el) => el['id'] == mem['id']);
                if (!exists) {
                  relationList.add({
                    "relation": "Sister",
                    "path": "users/${mem['id']}",
                    ...mem
                  });
                }
              }
            }
          } else {
            if (userData['isMarried']) {
              if (userData['gender'] == 'Male') {
                if ((mem['middleName']
                            .toString()
                            .indexOf(userData['middleName']) !=
                        -1) &&
                    (mem['lastName'].toString().indexOf(userData['lastName']) !=
                        -1)) {
                  var exists = relationList.any((el) => el['id'] == mem['id']);
                  if (!exists) {
                    relationList.add({
                      "relation": "Sister",
                      "path": "users/${mem['id']}",
                      ...mem
                    });
                  }
                }
              } else {
                if ((mem['middleName']
                            .toString()
                            .indexOf(userData['fatherName']) !=
                        -1) &&
                    (mem['lastName']
                            .toString()
                            .indexOf(userData['oldSurname']) !=
                        -1)) {
                  var exists = relationList.any((el) => el['id'] == mem['id']);
                  if (!exists) {
                    relationList.add({
                      "relation": "Sister",
                      "path": "users/${mem['id']}",
                      ...mem
                    });
                  }
                }
              }
            } else {
              if ((mem['middleName']
                          .toString()
                          .indexOf(userData['middleName']) !=
                      -1) &&
                  (mem['lastName'].toString().indexOf(userData['lastName']) !=
                      -1)) {
                var exists = relationList.any((el) => el['id'] == mem['id']);
                if (!exists) {
                  relationList.add({
                    "relation": "Sister",
                    "path": "users/${mem['id']}",
                    ...mem
                  });
                }
              }
            }
          }
        }
      }

      for (var mem in usersList) {
        QuerySnapshot brotherSnapshotRef;
        QuerySnapshot sisterSnapshotRef;

        if (userData['gender'] == 'Male') {
          brotherSnapshotRef = (await db
              .collection('users/${mem['id']}/addedMembers')
              .where('middleName', isEqualTo: userData['middleName'])
              .where('lastName', isEqualTo: userData['lastName'])
              .where('gender', isEqualTo: 'Male')
              .getDocuments());

          sisterSnapshotRef = (await db
              .collection('users/${mem['id']}/addedMembers')
              .where('gender', isEqualTo: 'Female')
              .getDocuments());

          if (brotherSnapshotRef != null &&
              brotherSnapshotRef.documents != null &&
              brotherSnapshotRef.documents.length > 0) {
            var brotherCollectionList = brotherSnapshotRef.documents
                .map((doc) => {"id": doc.documentID, ...doc.data})
                .toList();

            for (var el in brotherCollectionList) {
              var exists = relationList.any((item) =>
                  (item['firstName'] == el['firstName'] &&
                      item['lastName'] == el['lastName'] &&
                      item['relation'] == 'Brother'));

              if (!exists) {
                relationList.add({
                  "relation": "Brother",
                  "path": "users/${mem['id']}/addedMembers/${el['id']}",
                  ...el
                });
              }
            }
          }

          // check for sisters

          if (sisterSnapshotRef != null &&
              sisterSnapshotRef.documents != null &&
              sisterSnapshotRef.documents.length > 0) {
            var sisterCollectionList = sisterSnapshotRef.documents
                .map((doc) => {"id": doc.documentID, ...doc.data})
                .toList();

            for (var el in sisterCollectionList) {
              if (el['isMarried']) {
                if (el['fatherName']
                            .toString()
                            .indexOf(userData['middleName']) !=
                        -1 &&
                    el['oldSurname'].toString().indexOf(userData['lastName']) !=
                        -1) {
                  var exists = relationList.any((item) =>
                      (item['firstName'] == el['firstName'] &&
                          item['lastName'] == el['lastName'] &&
                          item['relation'] == 'Sister'));

                  if (!exists) {
                    relationList.add({
                      "relation": "Sister",
                      "path": "users/${mem['id']}/addedMembers/${el['id']}",
                      ...el
                    });
                  }
                }
              } else {
                if (el['middleName']
                            .toString()
                            .indexOf(userData['middleName']) !=
                        -1 &&
                    el['lastName'].toString().indexOf(userData['lastName']) !=
                        -1) {
                  var exists = relationList.any((item) =>
                      (item['firstName'] == el['firstName'] &&
                          item['lastName'] == el['lastName'] &&
                          item['relation'] == 'Sister'));

                  if (!exists) {
                    relationList.add({
                      "relation": "Sister",
                      "path": "users/${mem['id']}/addedMembers/${el['id']}",
                      ...el
                    });
                  }
                }
              }
            }
          }
        } else {
          // if user is female
          brotherSnapshotRef = (await db
              .collection('users/${mem['id']}/addedMembers')
              .where('gender', isEqualTo: 'Male')
              .getDocuments());

          sisterSnapshotRef = (await db
              .collection('users/${mem['id']}/addedMembers')
              .where('gender', isEqualTo: 'Female')
              .getDocuments());

          // check for brothers

          if (brotherSnapshotRef != null &&
              brotherSnapshotRef.documents != null &&
              brotherSnapshotRef.documents.length > 0) {
            var brotherCollectionList = brotherSnapshotRef.documents
                .map((doc) => {"id": doc.documentID, ...doc.data})
                .toList();

            for (var el in brotherCollectionList) {
              if (userData['isMarried']) {
                if (el['middleName']
                            .toString()
                            .indexOf(userData['fatherName']) !=
                        -1 &&
                    el['lastName'].toString().indexOf(userData['oldSurname']) !=
                        -1) {
                  var exists = relationList.any((item) =>
                      (item['firstName'] == el['firstName'] &&
                          item['lastName'] == el['lastName'] &&
                          item['relation'] == 'Brother'));

                  if (!exists) {
                    relationList.add({
                      "relation": "Brother",
                      "path": "users/${mem['id']}/addedMembers/${el['id']}",
                      ...el
                    });
                  }
                }
              } else {
                if (el['middleName']
                            .toString()
                            .indexOf(userData['middleName']) !=
                        -1 &&
                    el['lastName'].toString().indexOf(userData['lastName']) !=
                        -1) {
                  var exists = relationList.any((item) =>
                      (item['firstName'] == el['firstName'] &&
                          item['lastName'] == el['lastName'] &&
                          item['relation'] == 'Brother'));

                  if (!exists) {
                    relationList.add({
                      "relation": "Brother",
                      "path": "users/${mem['id']}/addedMembers/${el['id']}",
                      ...el
                    });
                  }
                }
              }
            }
          }

          // check for sisters
          if (sisterSnapshotRef != null &&
              sisterSnapshotRef.documents != null &&
              sisterSnapshotRef.documents.length > 0) {
            var sisterCollectionList = sisterSnapshotRef.documents
                .map((doc) => {"id": doc.documentID, ...doc.data})
                .toList();

            for (var el in sisterCollectionList) {
              if (userData['isMarried']) {
                if (el['isMarried']) {
                  if (el['fatherName']
                              .toString()
                              .indexOf(userData['fatherName']) !=
                          -1 &&
                      el['oldSurname']
                              .toString()
                              .indexOf(userData['oldSurname']) !=
                          -1) {
                    var exists = relationList.any((item) =>
                        (item['firstName'] == el['firstName'] &&
                            item['lastName'] == el['lastName'] &&
                            item['relation'] == 'Sister'));

                    if (!exists) {
                      relationList.add({
                        "relation": "Sister",
                        "path": "users/${mem['id']}/addedMembers/${el['id']}",
                        ...el
                      });
                    }
                  }
                } else {
                  if (el['middleName']
                              .toString()
                              .indexOf(userData['fatherName']) !=
                          -1 &&
                      el['lastName']
                              .toString()
                              .indexOf(userData['oldSurname']) !=
                          -1) {
                    var exists = relationList.any((item) =>
                        (item['firstName'] == el['firstName'] &&
                            item['lastName'] == el['lastName'] &&
                            item['relation'] == 'Sister'));

                    if (!exists) {
                      relationList.add({
                        "relation": "Sister",
                        "path": "users/${mem['id']}/addedMembers/${el['id']}",
                        ...el
                      });
                    }
                  }
                }
              } else {
                if (el['isMarried']) {
                  if (el['fatherName']
                              .toString()
                              .indexOf(userData['middleName']) !=
                          -1 &&
                      el['oldSurname']
                              .toString()
                              .indexOf(userData['lastName']) !=
                          -1) {
                    var exists = relationList.any((item) =>
                        (item['firstName'] == el['firstName'] &&
                            item['lastName'] == el['lastName'] &&
                            item['relation'] == 'Sister'));

                    if (!exists) {
                      relationList.add({
                        "relation": "Sister",
                        "path": "users/${mem['id']}/addedMembers/${el['id']}",
                        ...el
                      });
                    }
                  }
                } else {
                  if (el['middleName']
                              .toString()
                              .indexOf(userData['middleName']) !=
                          -1 &&
                      el['LastName'].toString().indexOf(userData['lastName']) !=
                          -1) {
                    var exists = relationList.any((item) =>
                        (item['firstName'] == el['firstName'] &&
                            item['lastName'] == el['lastName'] &&
                            item['relation'] == 'Sister'));

                    if (!exists) {
                      relationList.add({
                        "relation": "Sister",
                        "path": "users/${mem['id']}/addedMembers/${el['id']}",
                        ...el
                      });
                    }
                  }
                }
              }
            }
          }
        }
      }
      if (relationList != null && relationList.length > 0) {
        relationList.removeWhere((item) =>
            (item['firstName'] == userData['firstName'] &&
                item['lastName'] == userData['lastName']));
      }
      return relationList;
    } catch (err) {
      print('Error elerating sibling relations');
      print(err.toString());
      return null;
    }
  }

  // generate son and daugher
  Future<List<Map<String, dynamic>>> generateSonDaughterRelations(
      {@required Map<String, dynamic> userData}) async {
    try {
      List<Map<String, dynamic>> relationList = [];

      var usersCollection = (await db.collection('users').getDocuments());

      // return if no such users are found
      if (usersCollection == null ||
          usersCollection.documents == null ||
          usersCollection.documents.length <= 0) {
        print('No users found while generating siblings relations');
        return null;
      }

      var usersList = usersCollection.documents
          .map((doc) => {"id": doc.documentID, ...doc.data})
          .toList();

      for (var mem in usersList) {
        // check for sons

        if (mem['gender'] == 'Male') {
          if ((userData['gender'] == 'Male') &&
              (mem['middleName'].toString().indexOf(userData['firstName']) !=
                  -1) &&
              (mem['lastName'].toString().indexOf(userData['lastName']) !=
                  -1)) {
            var exists = relationList.any((el) => el['id'] == mem['id']);
            if (!exists) {
              relationList.add(
                  {"relation": "Son", "path": "users/${mem['id']}", ...mem});
            }
          }

          if ((userData['gender'] == 'Female') &&
              (mem['middleName'].toString().indexOf(userData['middleName']) !=
                  -1) &&
              (mem['lastName'].toString().indexOf(userData['lastName']) !=
                  -1)) {
            var exists = relationList.any((el) => el['id'] == mem['id']);
            if (!exists) {
              relationList.add(
                  {"relation": "Son", "path": "users/${mem['id']}", ...mem});
            }
          }
        }

        // check for daughters

        if (mem['gender'] == 'Female') {
          if (mem['isMarried']) {
            if (userData['gender'] == 'Male') {
              if ((mem['fatherName']
                          .toString()
                          .indexOf(userData['firstName']) !=
                      -1) &&
                  (mem['oldSurname'].toString().indexOf(userData['lastName']) !=
                      -1)) {
                var exists = relationList.any((el) => el['id'] == mem['id']);
                if (!exists) {
                  relationList.add({
                    "relation": "Daughter",
                    "path": "users/${mem['id']}",
                    ...mem
                  });
                }
              }
            } else {
              if ((mem['fatherName']
                          .toString()
                          .indexOf(userData['middleName']) !=
                      -1) &&
                  (mem['oldSurname'].toString().indexOf(userData['lastName']) !=
                      -1)) {
                var exists = relationList.any((el) => el['id'] == mem['id']);
                if (!exists) {
                  relationList.add({
                    "relation": "Daughter",
                    "path": "users/${mem['id']}",
                    ...mem
                  });
                }
              }
            }
          } else {
            if (userData['gender'] == 'Male') {
              if ((mem['middleName']
                          .toString()
                          .indexOf(userData['firstName']) !=
                      -1) &&
                  (mem['lastName'].toString().indexOf(userData['lastName']) !=
                      -1)) {
                var exists = relationList.any((el) => el['id'] == mem['id']);
                if (!exists) {
                  relationList.add({
                    "relation": "Daughter",
                    "path": "users/${mem['id']}",
                    ...mem
                  });
                }
              }
            } else {
              if ((mem['middleName']
                          .toString()
                          .indexOf(userData['middleName']) !=
                      -1) &&
                  (mem['lastName'].toString().indexOf(userData['lastName']) !=
                      -1)) {
                var exists = relationList.any((el) => el['id'] == mem['id']);
                if (!exists) {
                  relationList.add({
                    "relation": "Daughter",
                    "path": "users/${mem['id']}",
                    ...mem
                  });
                }
              }
            }
          }
        }
      }

      for (var mem in usersList) {
        QuerySnapshot sonSnapshotRef;
        QuerySnapshot daughterSnapshotRef;

        if (userData['gender'] == 'Male') {
          sonSnapshotRef = (await db
              .collection('users/${mem['id']}/addedMembers')
              .where('middleName', isEqualTo: userData['firstName'])
              .where('lastName', isEqualTo: userData['lastName'])
              .where('gender', isEqualTo: 'Male')
              .getDocuments());

          daughterSnapshotRef = (await db
              .collection('users/${mem['id']}/addedMembers')
              .where('gender', isEqualTo: 'Female')
              .getDocuments());

          if (sonSnapshotRef != null &&
              sonSnapshotRef.documents != null &&
              sonSnapshotRef.documents.length > 0) {
            var sonCollectionList = sonSnapshotRef.documents
                .map((doc) => {"id": doc.documentID, ...doc.data})
                .toList();

            for (var el in sonCollectionList) {
              var exists = relationList.any((item) =>
                  (item['firstName'] == el['firstName'] &&
                      item['lastName'] == el['lastName'] &&
                      item['relation'] == 'Brother'));

              if (!exists) {
                relationList.add({
                  "relation": "Son",
                  "path": "users/${mem['id']}/addedMembers/${el['id']}",
                  ...el
                });
              }
            }
          }

          // check for Daughter

          if (daughterSnapshotRef != null &&
              daughterSnapshotRef.documents != null &&
              daughterSnapshotRef.documents.length > 0) {
            var daughterCollectionList = daughterSnapshotRef.documents
                .map((doc) => {"id": doc.documentID, ...doc.data})
                .toList();

            for (var el in daughterCollectionList) {
              if (el['isMarried']) {
                if (el['fatherName']
                            .toString()
                            .indexOf(userData['firstName']) !=
                        -1 &&
                    el['oldSurname'].toString().indexOf(userData['lastName']) !=
                        -1) {
                  var exists = relationList.any((item) =>
                      (item['firstName'] == el['firstName'] &&
                          item['lastName'] == el['lastName'] &&
                          item['relation'] == 'Daughter'));

                  if (!exists) {
                    relationList.add({
                      "relation": "Daughter",
                      "path": "users/${mem['id']}/addedMembers/${el['id']}",
                      ...el
                    });
                  }
                }
              } else {
                if (el['middleName']
                            .toString()
                            .indexOf(userData['firstName']) !=
                        -1 &&
                    el['lastName'].toString().indexOf(userData['lastName']) !=
                        -1) {
                  var exists = relationList.any((item) =>
                      (item['firstName'] == el['firstName'] &&
                          item['lastName'] == el['lastName'] &&
                          item['relation'] == 'Daughter'));

                  if (!exists) {
                    relationList.add({
                      "relation": "Daughter",
                      "path": "users/${mem['id']}/addedMembers/${el['id']}",
                      ...el
                    });
                  }
                }
              }
            }
          }
        } else {
          // if user is female
          sonSnapshotRef = (await db
              .collection('users/${mem['id']}/addedMembers')
              .where('gender', isEqualTo: 'Male')
              .where('middleName', isEqualTo: userData['middleName'])
              .where('lastName', isEqualTo: userData['lastName'])
              .getDocuments());

          daughterSnapshotRef = (await db
              .collection('users/${mem['id']}/addedMembers')
              .where('gender', isEqualTo: 'Female')
              .getDocuments());

          // check for brothers

          if (sonSnapshotRef != null &&
              sonSnapshotRef.documents != null &&
              sonSnapshotRef.documents.length > 0) {
            var sonCollectionList = sonSnapshotRef.documents
                .map((doc) => {"id": doc.documentID, ...doc.data})
                .toList();

            for (var el in sonCollectionList) {
              if (el['middleName'].toString().indexOf(userData['middleName']) !=
                      -1 &&
                  el['lastName'].toString().indexOf(userData['lastName']) !=
                      -1) {
                var exists = relationList.any((item) =>
                    (item['firstName'] == el['firstName'] &&
                        item['lastName'] == el['lastName'] &&
                        item['relation'] == 'Son'));

                if (!exists) {
                  relationList.add({
                    "relation": "Son",
                    "path": "users/${mem['id']}/addedMembers/${el['id']}",
                    ...el
                  });
                }
              }
            }

            // check for daughters
            if (daughterSnapshotRef != null &&
                daughterSnapshotRef.documents != null &&
                daughterSnapshotRef.documents.length > 0) {
              var daughterCollectionList = daughterSnapshotRef.documents
                  .map((doc) => {"id": doc.documentID, ...doc.data})
                  .toList();

              for (var el in daughterCollectionList) {
                if (el['isMarried']) {
                  if (el['fatherName']
                              .toString()
                              .indexOf(userData['middleName']) !=
                          -1 &&
                      el['oldSurname']
                              .toString()
                              .indexOf(userData['lastName']) !=
                          -1) {
                    var exists = relationList.any((item) =>
                        (item['firstName'] == el['firstName'] &&
                            item['lastName'] == el['lastName'] &&
                            item['relation'] == 'Daughter'));

                    if (!exists) {
                      relationList.add({
                        "relation": "Daughter",
                        "path": "users/${mem['id']}/addedMembers/${el['id']}",
                        ...el
                      });
                    }
                  }
                } else {
                  if (el['middleName']
                              .toString()
                              .indexOf(userData['middleName']) !=
                          -1 &&
                      el['lastName'].toString().indexOf(userData['lastName']) !=
                          -1) {
                    var exists = relationList.any((item) =>
                        (item['firstName'] == el['firstName'] &&
                            item['lastName'] == el['lastName'] &&
                            item['relation'] == 'Daughter'));

                    if (!exists) {
                      relationList.add({
                        "relation": "Daughter",
                        "path": "users/${mem['id']}/addedMembers/${el['id']}",
                        ...el
                      });
                    }
                  }
                }
              }
            }
          }
        }
      }
      return relationList;
    } catch (err) {
      print('Error elerating sibling relations');
      print(err.toString());
      return null;
    }
  }
}
