import 'package:Ashvatth/screens/user_info.dart';
import 'package:Ashvatth/screens/user_profile.dart';
import 'package:Ashvatth/services/user_service.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                        builder: (ctx) => UserInfoFormPage(
                              relationship: _selectedRelation,
                            )),
                  );
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
                                items: <String>[
                                  "Grandfather",
                                  "Grandmother",
                                  "Father",
                                  "Mother",
                                  "Brother",
                                  "Sister",
                                  "Son",
                                  "Daughter",
                                ].map((String value) {
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
}
