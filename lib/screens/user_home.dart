import 'package:Ashvatth/screens/user_info.dart';
import 'package:Ashvatth/screens/user_profile.dart';
import 'package:Ashvatth/services/user_service.dart';
import 'package:Ashvatth/widgets/appdrawer.dart';
import 'package:Ashvatth/widgets/bottomsearch.dart';
import 'package:Ashvatth/widgets/input_form_field.dart';
import 'package:Ashvatth/widgets/tree.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:string_validator/string_validator.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final userDataFuture = UserService().getCurrentUserData();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var showLoader = false;
  List<String> imageList = [
    'https://firebasestorage.googleapis.com/v0/b/surgimall-admin-dev.appspot.com/o/Ads-Master%2F0RkR1EUC2JbPwmRe3mSt_1590911385683?alt=media&token=99428782-024f-4d23-b1f6-b21f05d408f8',
    'https://firebasestorage.googleapis.com/v0/b/surgimall-admin-dev.appspot.com/o/Ads-Master%2FF5lXsGOOl1V6oUS0PQoM_1590911252278?alt=media&token=19f1106d-5cbf-4609-b773-51cfa364f46b',
    'https://firebasestorage.googleapis.com/v0/b/surgimall-admin-dev.appspot.com/o/Ads-Master%2FrmcAkZi57ooElbFoj6Bi_1590730556320?alt=media&token=92dfe602-eb20-4527-ad44-326022905601'
  ];

  @override
  void initState() {
    super.initState();
    _setUserName();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: AppDrawerWidger(),
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              size: 28,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications,
                size: 28,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.chat,
                size: 28,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {},
            ),
          ],
        ),
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<dynamic>(
                  future: userDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Some error occured, Please try again');
                    }
                    return SizedBox(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xff8d6e52),
                                )),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.13,
                              width: MediaQuery.of(context).size.height * 0.13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      snapshot.data['profileImageUrl']),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Text(snapshot.data['firstName'],
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(fontWeight: FontWeight.w700))
                        ],
                      ),
                    );
                  },
                ),
                _showSwiper(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom:
                                BorderSide(color: Colors.grey.withOpacity(.3)),
                          )),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _menuItem(
                                  showRight: true,
                                  labelName: 'Family\nTree',
                                  showIcon: FontAwesomeIcons.tree,
                                  onTapFunction: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                          builder: (ctx) => Tree()),
                                    );
                                  }),
                              _menuItem(
                                labelName: 'Family\nMembers',
                                showRight: true,
                                showIcon: Icons.people,
                              ),
                              _menuItem(
                                labelName: 'Medical\nHistory',
                                showIcon: Icons.local_hospital,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                            bottom:
                                BorderSide(color: Colors.grey.withOpacity(.3)),
                          )),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _menuItem(
                                showRight: true,
                                labelName: 'Business\nCommunity',
                                showIcon: Icons.business,
                              ),
                              _menuItem(
                                showRight: true,
                                labelName: 'Social\nCommunity',
                                showIcon: FontAwesomeIcons.facebook,
                              ),
                              _menuItem(labelName: ''),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Positioned(

            // ),
            // Positioned(
            //   bottom: MediaQuery.of(context).size.height * 0.05,
            //   left: 16,
            //   right: 16,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       FloatingActionButton(
            //         mini: true,
            //         heroTag: 'left',
            //         child: Icon(
            //           Icons.account_circle,
            //           color: Theme.of(context).accentColor,
            //           size: 32,
            //         ),
            //         backgroundColor: Color(0xfff0cc8d),
            //         onPressed: () {
            //           Navigator.of(context).push(
            //             CupertinoPageRoute(builder: (ctx) => UserProfile()),
            //           );
            //         },
            //       ),
            //       FloatingActionButton(
            //         heroTag: 'mid',
            //         child: Icon(
            //           Icons.add,
            //           size: 50,
            //           color: Theme.of(context).primaryColor,
            //         ),
            //         backgroundColor: Color(0xfff0cc8d),
            //         onPressed: () {
            //           showModalBottomSheet(
            //               context: context,
            //               isScrollControlled: true,
            //               builder: (ctx) {
            //                 return Container(
            //                   child: BottomSearch(
            //                     ctx: ctx,
            //                   ),
            //                   height: MediaQuery.of(context).size.height * .8,
            //                 );
            //               }).then((res) {
            //             if (res != null && res.runtimeType == String) {
            //               Navigator.of(context).push(
            //                 CupertinoPageRoute(
            //                   builder: (ctx) =>
            //                       UserInfoFormPage(relationship: res),
            //                 ),
            //               );
            //             }
            //           });
            //         },
            //       ),
            //       FloatingActionButton(
            //         heroTag: 'right',
            //         mini: true,
            //         child: Icon(
            //           FontAwesomeIcons.tree,
            //           color: Theme.of(context).accentColor,
            //           size: 30,
            //         ),
            //         backgroundColor: Color(0xfff0cc8d),
            //         onPressed: () {
            //           Navigator.of(context).push(
            //             CupertinoPageRoute(builder: (ctx) => Tree()),
            //           );
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // hide show loader
  _hideShowLoader(bool val) {
    setState(() {
      showLoader = val;
    });
  }

  _setUserName() {
    Future.delayed(Duration.zero, () async {
      try {
        var userId = (await FirebaseAuth.instance.currentUser()).uid;
        var userData =
            (await Firestore.instance.document('users/$userId').get()).data;
        if (userData['username'] == null) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                return AlertDialog(
                  title: Text(
                    'Choose a username',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  content: Form(
                    key: _formKey,
                    child: InputFormField(
                      controller: _usernameController,
                      labelText: 'Username',
                      isRequired: true,
                      validatorFunction: (String value) {
                        if (value.trim().isEmpty) {
                          return 'Required';
                        }

                        if (value.trim().length < 4) {
                          return 'Must contain minumum 4 characters';
                        }

                        if (!isAlphanumeric(value.trim())) {
                          return 'Only letter and numbers allowed';
                        }

                        return null;
                      },
                    ),
                  ),
                  actions: <Widget>[
                    if (!showLoader)
                      Center(
                        child: FlatButton(
                          child: Text(
                            'Save',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          onPressed: showLoader
                              ? null
                              : () async {
                                  try {
                                    if (_formKey.currentState.validate()) {
                                      var username = _usernameController.text
                                          .trim()
                                          .toLowerCase();

                                      _hideShowLoader(true);

                                      var usernameRef = (await Firestore
                                          .instance
                                          .collection('usernames')
                                          .getDocuments());

                                      if (usernameRef != null &&
                                          usernameRef.documents.length > 0) {
                                        var list = usernameRef.documents
                                            .map((doc) => doc.data)
                                            .toList();

                                        var exists = list.any((item) =>
                                            item['username'] == username);

                                        if (exists) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Sorry, this username is already taken.'),
                                            backgroundColor:
                                                Theme.of(context).errorColor,
                                          ));
                                          _hideShowLoader(false);
                                          return;
                                        }
                                      }

                                      await Firestore.instance
                                          .document('users/$userId')
                                          .updateData({
                                        'username': username,
                                        'whenModified': Timestamp.now(),
                                      });

                                      await Firestore.instance
                                          .collection('usernames')
                                          .add({
                                        'username': username,
                                        'whenCreated': Timestamp.now(),
                                      });

                                      _hideShowLoader(false);
                                      Navigator.of(ctx).pop();
                                      _scaffoldKey.currentState
                                          .hideCurrentSnackBar();
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          'Username saved',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.green,
                                      ));
                                    }
                                  } catch (err) {
                                    print(err.toString());
                                    _hideShowLoader(false);
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'some error occured, try again later'),
                                      backgroundColor:
                                          Theme.of(context).errorColor,
                                    ));
                                  }
                                },
                        ),
                      ),
                    if (showLoader) Center(child: CircularProgressIndicator()),
                  ],
                );
              });
        } else {
          return;
        }
      } catch (err) {
        print(err.toString());
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Some error occured, try agin later'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }
    });
  }

  // swiper
  Widget _showSwiper() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.27,
      width: MediaQuery.of(context).size.width,
      child: Swiper(
        autoplayDisableOnInteraction: false,
        curve: Curves.easeInOut,
        plugins: [
          SwiperControl(
            color: Colors.white,
          ),
        ],
        fade: 0.6,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            imageUrl: imageList[index],
            fit: BoxFit.fill,
            placeholder: (context, url) {
              return Center(child: CircularProgressIndicator());
            },
            errorWidget: (context, url, error) {
              print(error.toString());
              return Center(
                child: Icon(Icons.error_outline,
                    color: Theme.of(context).errorColor),
              );
            },
          );
        },
        itemCount: imageList.length,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }

  Widget _menuItem({
    bool showLeft = false,
    bool showRight = false,
    @required String labelName,
    Function onTapFunction,
    IconData showIcon = Icons.ac_unit,
  }) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: () {
          onTapFunction();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              right: !showRight
                  ? BorderSide(color: Theme.of(context).scaffoldBackgroundColor)
                  : BorderSide(
                      color: Colors.grey.withOpacity(.3).withOpacity(.3)),
              left: !showLeft
                  ? BorderSide(color: Theme.of(context).scaffoldBackgroundColor)
                  : BorderSide(
                      color: Colors.grey.withOpacity(.3).withOpacity(.3)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                showIcon,
                size: 34,
                color: labelName != ''
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).scaffoldBackgroundColor,
              ),
              SizedBox(height: 8),
              Text(
                '$labelName',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
