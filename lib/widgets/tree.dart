import 'package:Ashvatth/screens/user_profile.dart';
import 'package:Ashvatth/services/relation_services.dart';
import 'package:Ashvatth/services/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tree extends StatefulWidget {
  final bool selfTree;
  final String userId;
  final bool isNonUserTree;
  final dynamic nonUserData;

  Tree(
      {this.selfTree = true,
      this.userId,
      this.isNonUserTree = false,
      this.nonUserData});

  @override
  _TreeState createState() => _TreeState();
}

class _TreeState extends State<Tree> {
  Map<String, dynamic> currentUserData;
  String userId;
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();

    if (widget.selfTree) {
      Future.delayed(Duration.zero, () {
        _getCurrentUserId();
      });
    } else if (widget.userId != null) {
      Future.delayed(Duration.zero, () {
        _getUserData(widget.userId);
      });
      setState(() {
        userId = widget.userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              if (_showLoader) LinearProgressIndicator(),
              // parent list
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16),
                child: SizedBox(
                  height: 160,
                  child: Center(
                    child: FutureBuilder(
                        future: (!widget.isNonUserTree &&
                                widget.nonUserData == null)
                            ? UserService()
                                .getUserParentRelations(userId: this.userId)
                            : RelationsService().generateMotherFatherRelation(
                                userData: widget.nonUserData),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error.toString());
                            return Text('');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          var list = snapshot.data;
                          print(list.toString());
                          return (list != null && list.length > 0)
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, i) {
                                    return _treeListItem(
                                        "$userId", list[i], false);
                                  },
                                  itemCount: list.length,
                                )
                              : (currentUserData != null)
                                  ? FutureBuilder(
                                      future: RelationsService()
                                          .generateMotherFatherRelation(
                                              userData: currentUserData),
                                      builder: (context, snap) {
                                        if (snapshot.hasError) {
                                          print(snap.error.toString());
                                          return Text('');
                                        }
                                        if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        var newList = snap.data;
                                        return newList != null &&
                                                newList.length > 0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (ctx, i) {
                                                  return _treeListItem(
                                                      "$userId",
                                                      newList[i],
                                                      false);
                                                },
                                                itemCount: newList.length,
                                              )
                                            : Text(
                                                'No Father / Mother Relations Found');
                                      },
                                    )
                                  : Text('No Father / Mother Relations Found');
                        }),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: // // brother sister
                    SizedBox(
                  height: 160,
                  child: FutureBuilder(
                      future:
                          (!widget.isNonUserTree && widget.nonUserData == null)
                              ? UserService()
                                  .getUserBrotherAndSisters(userId: this.userId)
                              : RelationsService().generateSiblingRelations(
                                  userData: widget.nonUserData),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error.toString());
                          return Text(' ');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var list = snapshot.data;
                        return (list != null && list.length > 0)
                            ? ListView.builder(
                                itemCount: list.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    left: list.length > 1 ? 0 : 0, top: 8),
                                itemBuilder: (ctx, i) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: (list.length > 2)
                                            ? 0
                                            : (i == 0) ? 80.0 : 0),
                                    child: _treeListItem(
                                        this.userId, list[i], false),
                                  );
                                },
                              )
                            : (currentUserData != null)
                                ? FutureBuilder(
                                    future: RelationsService()
                                        .generateSiblingRelations(
                                            userData: currentUserData),
                                    builder: (context, snap) {
                                      if (snapshot.hasError) {
                                        print(snap.error.toString());
                                        return Text('');
                                      }
                                      if (snap.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      var newList = snap.data;
                                      return newList != null &&
                                              newList.length > 0
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (ctx, i) {
                                                return _treeListItem("$userId",
                                                    newList[i], false);
                                              },
                                              itemCount: newList.length,
                                            )
                                          : Text(
                                              'No Brother / Sister Relations Found');
                                    },
                                  )
                                : Text('No Brother / Sister Relations Found');
                      }),
                ),
              ),
              SizedBox(height: 10),
              // wife, himself and brother sister list
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // wife
                    Flexible(
                        child: FutureBuilder(
                            future: (!widget.isNonUserTree &&
                                    widget.nonUserData == null &&
                                    currentUserData != null)
                                ? currentUserData['gender'] == 'Male'
                                    ? UserService()
                                        .getWifeRelation(userId: this.userId)
                                    : UserService()
                                        .getHusbandRelation(userId: this.userId)
                                : RelationsService().generateSpouseRelations(
                                    userData: widget.nonUserData),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error.toString());
                                return Text('No Wife relations found');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              var wifeData = snapshot.data;
                              print(wifeData);
                              return (wifeData != null)
                                  ? _treeListItem("$userId", wifeData, false)
                                  : (currentUserData != null)
                                      ? FutureBuilder(
                                          future: RelationsService()
                                              .generateSpouseRelations(
                                                  userData: currentUserData),
                                          builder: (context, snap) {
                                            if (snapshot.hasError) {
                                              print(snap.error.toString());
                                              return Text('');
                                            }
                                            if (snap.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }
                                            var wifeData = snap.data;
                                            return wifeData != null
                                                ? _treeListItem(
                                                    "$userId", wifeData, false)
                                                : Text(' ');
                                          },
                                        )
                                      : Text(' ');
                            })),
                    // himself
                    if (widget.selfTree || widget.isNonUserTree)
                      (currentUserData != null || widget.nonUserData != null)
                          ? Flexible(
                              child: _treeListItem(userId,
                                  currentUserData ?? widget.nonUserData, true))
                          : Text(''),
                    if (!widget.selfTree)
                      Flexible(
                        child: FutureBuilder(
                            future: UserService().getUserById(userId: userId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error.toString());
                                return Text(' ');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              var userData = snapshot.data;
                              return (userData != null)
                                  ? _treeListItem(userId, userData, true)
                                  : Text(' ');
                            }),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // // children
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 16),
                child: SizedBox(
                  height: 160,
                  child: Center(
                    child: FutureBuilder(
                        future: (!widget.isNonUserTree &&
                                widget.nonUserData == null)
                            ? UserService()
                                .getSonAndDaughter(userId: this.userId)
                            : RelationsService().generateSonDaughterRelations(
                                userData: widget.nonUserData),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error.toString());
                            return Text(' ');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          var list = snapshot.data;
                          return (list != null && list.length > 0)
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, i) {
                                    return _treeListItem(
                                        this.userId, list[i], false);
                                  },
                                  itemCount: list.length,
                                )
                              : (currentUserData != null)
                                  ? FutureBuilder(
                                      future: RelationsService()
                                          .generateSonDaughterRelations(
                                              userData: currentUserData),
                                      builder: (context, snap) {
                                        if (snapshot.hasError) {
                                          print(snap.error.toString());
                                          return Text('');
                                        }
                                        if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        var newList = snap.data;
                                        return newList != null &&
                                                newList.length > 0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (ctx, i) {
                                                  return _treeListItem(
                                                      "$userId",
                                                      newList[i],
                                                      false);
                                                },
                                                itemCount: newList.length,
                                              )
                                            : Text(' ');
                                      },
                                    )
                                  : Text(' ');
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // hideshow Loader
  _hideShowLoader(bool value) {
    setState(() {
      _showLoader = value;
    });
  }

  // get current userid
  _getCurrentUserId() async {
    try {
      _hideShowLoader(true);
      var userId = (await FirebaseAuth.instance.currentUser()).uid;

      var userRef = (await Firestore.instance.document('users/$userId').get());

      setState(() {
        this.userId = userId;
        this.currentUserData = {"id": userId, ...userRef.data};
      });

      _hideShowLoader(false);
    } catch (err) {
      print(err.toString());
      _hideShowLoader(false);
    }
  }

  // get user data
  _getUserData(String userId) async {
    try {
      _hideShowLoader(true);
      var userRef = (await Firestore.instance.document('users/$userId').get());

      setState(() {
        this.userId = userId;
        this.currentUserData = {"id": userId, ...userRef.data};
      });

      _hideShowLoader(false);
    } catch (err) {
      print(err.toString());
      _hideShowLoader(false);
    }
  }

  // list item
  Widget _treeListItem(String userId, dynamic userData, bool isSelf) {
    String relation = userData['relation'] ?? 'You';
    if (relation.indexOf('Brother') != -1) {
      relation = 'Brother';
    }
    if (relation.indexOf('Sister') != -1) {
      relation = 'Sister';
    }
    if (relation.indexOf('Son') != -1) {
      relation = 'Son';
    }
    if (relation.indexOf('Daughter') != -1) {
      relation = 'Daughter';
    }
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            !isSelf ? relation : 'You',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: userData['id'] == userId
                ? null
                : (userData['relation'] != null && userId != null)
                    ? () {
                        print('asdasdas');
                        if (userData['path'] == null) {
                          print('asdasd');
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (ctx) => UserProfile(
                                relationPath:
                                    'users/$userId/addedMembers/${userData['relation']}',
                              ),
                            ),
                          );
                        } else {
                          print('${userData['path']}');
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (ctx) => UserProfile(
                                relationPath: userData['path'],
                              ),
                            ),
                          );
                        }
                      }
                    : () {
                        if (userData['path'] == null) {
                          // Navigator.of(context).push(
                          //   CupertinoPageRoute(
                          //     builder: (ctx) => UserProfile(),
                          //   ),
                          // );
                        } else {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (ctx) => UserProfile(
                                relationPath: userData['path'],
                              ),
                            ),
                          );
                        }
                      },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: !isSelf
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.red,
                          blurRadius: 16.0,
                        )
                      ],
                shape: BoxShape.circle,
                border: Border.all(
                  color: !isSelf ? Theme.of(context).primaryColor : Colors.red,
                  width: !isSelf ? 1.3 : 3,
                ),
              ),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        CachedNetworkImageProvider(userData['profileImageUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Text(
            (userData != null && userData['firstName'] != null)
                ? userData['firstName']
                : '',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
