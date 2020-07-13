import 'package:Ashvatth/screens/user_info.dart';
import 'package:Ashvatth/screens/user_profile.dart';
import 'package:Ashvatth/services/user_service.dart';
import 'package:Ashvatth/widgets/notification_card.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSearch extends StatefulWidget {
  final BuildContext ctx;

  BottomSearch({this.ctx});

  @override
  _BottomSearchState createState() => _BottomSearchState();
}

class _BottomSearchState extends State<BottomSearch> {
  bool showLoader = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final userDataFuture = UserService().getCurrentUserData();
  String _selectedRelation;
  List<String> _userSuggesstionNameList = List<String>();
  List<String> availableRalations = [
    "Grandfather",
    "Grandmother",
    "Father",
    "Mother",
    "Brother",
    "Sister",
    "Wife",
    "Son",
    "Daughter",
  ];

  var addedMembersFuture = UserService().getAddedRelations();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      UserService().getUsernameList().then((list) {
        if (list == null || list.length <= 0) {
          return;
        }
        _userSuggesstionNameList = [];
        setState(() {
          list.forEach((element) {
            _userSuggesstionNameList.add(element['username']);
          });
        });
      }).catchError((err) {
        print(err.toString());
        setState(() {
          _userSuggesstionNameList = [];
        });
      });

      // remove relations which are already submitted
      UserService().checkRelation(availableRalations).then((value) {
        setState(() {
          availableRalations = value;
        });
      }).catchError((err) {
        print(err.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: _selectedRelation != null
              ? () {
                  // Navigator.of(widget.ctx).push(
                  //   CupertinoPageRoute(
                  //       builder: (ctx) => UserInfoFormPage(
                  //             relationship: _selectedRelation,
                  //           )),
                  // );
                  Navigator.of(context).pop(_selectedRelation);
                }
              : () {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Select a Relationship first'),
                    backgroundColor: Theme.of(context).errorColor,
                  ));
                },
          child: Icon(Icons.person),
        ),
        body: FutureBuilder<dynamic>(
            future: userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Some error occured, please try again later'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Container(
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xff8d6e52),
                              )),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.11,
                            width: MediaQuery.of(context).size.height * 0.11,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    snapshot.data['profileImageUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Select Relationship'),
                              DropdownButton<String>(
                                value: _selectedRelation,
                                hint: Text('Relationship'),
                                items: availableRalations.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRelation = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: AutoCompleteTextField<String>(
                          decoration: InputDecoration(
                              hintText: "Search relatives:",
                              suffixIcon: Icon(Icons.search)),
                          itemSubmitted: (item) {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (ctx) => UserProfile(
                                    username: item.trim().toLowerCase())));
                          },
                          key: key,
                          suggestions: _userSuggesstionNameList,
                          itemBuilder: (context, suggestion) => Padding(
                              child: ListTile(
                                title: Text(suggestion),
                              ),
                              padding: EdgeInsets.all(8.0)),
                          itemSorter: (a, b) {
                            return a.compareTo(b);
                          },
                          itemFilter: (suggestion, input) {
                            if (!_userSuggesstionNameList.any((item) =>
                                item.trim().toLowerCase() ==
                                input.trim().toLowerCase())) {
                              return false;
                            }

                            return suggestion
                                .toLowerCase()
                                .startsWith(input.toLowerCase());
                          },
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).accentColor,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: FutureBuilder(
                            future: addedMembersFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error.toString());
                                return Center(
                                  child: Text(
                                      'Some error occured, please try again later'),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              List<Map<String, dynamic>> list = snapshot.data;

                              return (list != null && list.length > 0)
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: list.length,
                                      itemBuilder: (ctx, i) {
                                        return NotificationCard(
                                          imageUrl: list[i]['profileImageUrl'],
                                          mainText: list[i]['relation'],
                                          middleText: 'Added by you',
                                          onConfirm: () {
                                            _onViewAddedMember(
                                              list[i]['relation'],
                                            );
                                          },
                                          username: list[i]['firstName'] +
                                              ' ' +
                                              list[i]['lastName'],
                                          confirmBtnText: 'View',
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        'No members added',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      ),
                                    );
                            }),
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  String selected;

  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<String>>();
  List<String> suggestions = [
    "Aarav",
    "Aarush",
    "Aayush",
    "Abram",
    "Advik",
    "Akarsh",
    "Anay",
    "Aniruddh",
    "Arhaan",
    "Armaan",
    "Arnav",
    "Azad",
    "Badal",
    "Bhavin",
    "Chirag",
    "Darshit",
    "Devansh",
    "Dhanuk",
    "Dhruv",
    "Divij",
    "Divit",
    "Divyansh",
  ];
  // set loader state
  showHideLoader(bool value) {
    setState(() {
      showLoader = value;
    });
  }

  // on view added member
  _onViewAddedMember(String relation) {
    Navigator.of(widget.ctx).push(CupertinoPageRoute(
        builder: (ctx) => UserInfoFormPage(
              relationship: relation,
              isEdit: true,
            )));
  }
}
