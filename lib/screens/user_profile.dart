import 'package:Ashvatth/services/user_service.dart';
import 'package:Ashvatth/widgets/tree.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/cupertino.dart';
import './user_info.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

class UserProfile extends StatefulWidget {
  final String username;
  final String relationPath;

  UserProfile({this.username, this.relationPath});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var _userService = UserService();
  var userDataFuture = UserService().getCurrentUserData();
  DateFormat df = DateFormat('dd/MM/yyyy');
  final List<String> profileTabList = [
    // 'Tree',
    'Info',
    'Contact',
    'Education',
    'Occupation',
    // 'Privacy',
    'Other'
  ];

  String _selectedTab = 'Info';

  @override
  void initState() {
    super.initState();
    if (widget.username != null) {
      userDataFuture = UserService().getUserByUsername(widget.username);
    }
    if (widget.relationPath != null) {
      setState(() {
        profileTabList.remove('Tree');
      });
      userDataFuture =
          UserService().getUserMemberDataByPath(widget.relationPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<dynamic>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Some error occured, try again later'),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              return Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _backbutton(
                      snapshot.data['firstName'],
                      snapshot.data['lastName'],
                    ),
                    _profileImage(
                      snapshot.data['profileImageUrl'],
                      snapshot.data['firstName'],
                      snapshot.data['lastName'],
                    ),
                    _tabList(),
                    SizedBox(height: 8),
                    Divider(
                      color: Color(0xff8d6e52),
                      thickness: 1,
                    ),
                    if (_selectedTab == 'Info')
                      Expanded(
                        child: _infoTabContent(snapshot.data),
                      ),
                    if (_selectedTab == 'Tree')
                      Expanded(
                        child: _treeTabContent(
                            userId: snapshot.data['id'],
                            isMarried: snapshot.data['isMarried']),
                      ),
                    if (_selectedTab == 'Contact')
                      Expanded(
                        child: _contactTabContent(snapshot.data),
                      ),
                    if (_selectedTab == 'Education')
                      Expanded(
                        child: _educationTabContent(snapshot.data),
                      ),
                    if (_selectedTab == 'Occupation')
                      Expanded(
                        child: _occupationTabContent(snapshot.data),
                      ),
                    if (_selectedTab == 'Other')
                      Expanded(
                        child: _otherTabContent(snapshot.data),
                      ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(
                    FontAwesomeIcons.tree,
                    color: (snapshot.data['matchUserId'] != null)
                        ? Theme.of(context).accentColor
                        : Colors.white,
                    size: 30,
                  ),
                  backgroundColor: (snapshot.data['matchUserId'] != null)
                      ? Color(0xfff0cc8d)
                      : Colors.grey,
                  onPressed: (snapshot.data['matchUserId'] != null)
                      ? () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (ctx) => Tree(
                                selfTree: false,
                                userId: snapshot.data['matchUserId'],
                              ),
                            ),
                          );
                        }
                      : () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (ctx) => Tree(
                                selfTree: false,
                                isNonUserTree: true,
                                nonUserData: snapshot.data,
                              ),
                            ),
                          );
                        },
                ),
              );
          }
        },
      ),
    );
  }

  // back button
  Widget _backbutton(String firstName, String lastName) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
        padding: EdgeInsets.only(top: 0, left: 16),
        child: IconButton(
          icon: Icon(Icons.keyboard_backspace, size: 28),
          onPressed: () => Navigator.of(context).pop(),
          color: Color(0xff8d6e52),
        ),
      ),
      // IconButton(
      //   icon: Icon(FontAwesomeIcons.qrcode, size: 28),
      //   onPressed: () {
      //     final key = encrypt.Key.fromLength(32);
      //     final iv = encrypt.IV.fromLength(8);
      //     final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));

      //     final encrypted = encrypter.encrypt('plainText', iv: iv);
      //     // final decrypted = encrypter.decrypt(encrypted, iv: iv);
      //     showDialog(
      //         context: context,
      //         builder: (context) {
      //           return Dialog(
      //             child: FittedBox(
      //               child: Container(
      //                 margin: EdgeInsets.all(8),
      //                 child: Column(
      //                   children: [
      //                     CustomPaint(
      //                       size: Size.square(280),
      //                       painter: QrPainter(
      //                         data: encrypted.base64,
      //                         version: QrVersions.auto,
      //                         // size: 320.0,
      //                         color: Colors.brown,
      //                         embeddedImageStyle: QrEmbeddedImageStyle(
      //                           size: Size.square(60),
      //                         ),
      //                       ),
      //                     ),
      //                     Text('$firstName $lastName',
      //                         style: Theme.of(context)
      //                             .textTheme
      //                             .headline1
      //                             .copyWith(fontSize: 21)),
      //                     Text(
      //                       'Scan this QR code to send relationship request',
      //                       style: Theme.of(context)
      //                           .textTheme
      //                           .bodyText1
      //                           .copyWith(fontSize: 18),
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           );
      //         });
      //   },
      //   color: Color(0xff8d6e52),
      // ),
      if (widget.username == null && widget.relationPath == null)
        IconButton(
          icon: Icon(
            Icons.edit,
            size: 28,
          ),
          color: Color(0xff8d6e52),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (ctx) =>
                    UserInfoFormPage(isEdit: true, selfEdit: true),
              ),
            );
          },
        )
    ]);
  }

  // top image
  Widget _profileImage(String imageUrl, String firstName, String lastName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 3),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl),
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$firstName $lastName',
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Widget _tabList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 30, bottom: 5),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return _tabListItem(i);
        },
        itemCount: profileTabList.length,
      ),
    );
  }

  // tab list item
  Widget _tabListItem(int i) {
    return Padding(
      padding: i == 0 ? EdgeInsets.all(0) : const EdgeInsets.only(left: 30),
      child: RaisedButton(
        child: Text(
          profileTabList[i],
          style: TextStyle(
              fontSize: 20,
              // fontFamily: 'Laila',
              fontWeight: FontWeight.w700),
        ),
        color: _selectedTab == profileTabList[i]
            ? Theme.of(context).primaryColor
            : Color(0xfff0cc8d),
        textColor: _selectedTab == profileTabList[i]
            ? Colors.white
            : Theme.of(context).primaryColor,
        onPressed: () {
          setState(() {
            _selectedTab = profileTabList[i];
          });
        },
      ),
    );
  }

  // INfo tab
  Widget _infoTabContent(dynamic userData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(color: Color(0xff8d6e52))),
          columnWidths: {
            0: FractionColumnWidth(0.4),
          },
          // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Birth date',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (userData['dateOfBirth'] != null &&
                            userData['dateOfBirth'] != '')
                        ? '${df.format(userData['dateOfBirth'].toDate()).toString()}'
                        : 'Not Available',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // Age
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Age',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${(userData['dateOfBirth'] != null && userData['dateOfBirth'] != '') ? calculateAge(userData['dateOfBirth'].toDate()) : 'Not Available'}',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // Death Date
            if (userData['isAlive'] != null &&
                !userData['isAlive'] &&
                userData['deathDate'] != null &&
                userData['deathData'] != '')
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Death Date',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (userData['deathDate'] != null &&
                              userData['deathDate'] != '')
                          ? '${df.format(userData['deathDate'].toDate()).toString()}'
                          : 'Not Available',
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

            // anniversary  date
            if ((widget.relationPath != null) ||
                (userData['isMarried'] != null && userData['isMarried']))
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Anniversary date',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (userData['aniversarryDate'] != null &&
                              userData['aniversarryDate'] != '')
                          ? '${df.format(userData['aniversarryDate'].toDate()).toString()}'
                          : 'Not Available',
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

            // Notes
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['notes'] != null && userData['notes'] != '') ? userData['notes'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // tree tab
  Widget _treeTabContent({@required String userId, bool isMarried = false}) {
    print('UserId: $userId');
    return Stack(
      children: <Widget>[
        Positioned(
          top: 48,
          left: (MediaQuery.of(context).size.width / 2) - 3,
          child: Container(
            height: isMarried ? 210 : 110,
            width: 2,
            color: Theme.of(context).accentColor,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Center(
              child: FutureBuilder<List<dynamic>>(
                future: _userService.getUserParentRelations(userId: userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Center(
                      child: Text('Some error occured, Please try again later'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<dynamic> list = snapshot.data;
                  return (list != null && list.length > 0)
                      ? _parentList(list: list, userId: userId)
                      : Container();
                },
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: FutureBuilder<List<dynamic>>(
                future: _userService.getUserBrotherAndSisters(userId: userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Center(
                      child: Text('Some error occured, Please try again later'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<dynamic> list = snapshot.data;
                  return (list != null && list.length > 0)
                      ? _parentList(list: list, isParent: false, userId: userId)
                      : Container();
                },
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: FutureBuilder<List<dynamic>>(
                future: UserService().getSonAndDaughter(userId: userId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Center(
                      child: Text('Some error occured, Please try again later'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<dynamic> list = snapshot.data;
                  print(list.toString());
                  return (list != null && list.length > 0)
                      ? _parentList(list: list, isParent: false, userId: userId)
                      : Container();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // contact tab
  Widget _contactTabContent(dynamic userData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(color: Color(0xff8d6e52))),
          columnWidths: {
            0: FractionColumnWidth(0.4),
          },
          // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Permanent Address
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Permanent Address',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['permanentAddress'] != null && userData['permanentAddress'] != '') ? userData['permanentAddress'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // Current Address
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Current Address',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['currentAddress'] != null && userData['currentAddress'] != '') ? userData['currentAddress'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // Phone
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Phone No',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['phone'] != null && userData['phone'] != '') ? userData['phone'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                      decoration:
                          (userData['phone'] != null && userData['phone'] != '')
                              ? TextDecoration.underline
                              : TextDecoration.none,
                      decorationColor: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // Mobile
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Mobile No',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['contact'] != null && userData['contact'] != '') ? userData['contact'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                      decoration: (userData['contact'] != null &&
                              userData['contact'] != '')
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // Email
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['personalEmail'] != null && userData['personalEmail'] != '') ? userData['personalEmail'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // education tab
  Widget _educationTabContent(dynamic userData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(color: Color(0xff8d6e52))),
          columnWidths: {
            0: FractionColumnWidth(0.45),
          },
          // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Qualification
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Qualification',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['qualification'] != null && userData['qualification'] != '') ? userData['qualification'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // University
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'University',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['university'] != null && userData['university'] != '') ? userData['university'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // School
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'School',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['school'] != null && userData['school'] != '') ? userData['school'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // Grant
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Grant',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['grant'] != null && userData['grant'] != '') ? userData['grant'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // occupation tab
  Widget _occupationTabContent(dynamic userData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(color: Color(0xff8d6e52))),
          columnWidths: {
            0: FractionColumnWidth(0.45),
          },
          // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Company Name
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Company Name',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['companyName'] != null && userData['companyName'] != '') ? userData['companyName'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // Service Line
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Service Line',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['serviceLine'] != null && userData['serviceLine'] != '') ? userData['serviceLine'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // Contact number
            // TableRow(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(
            //         'Contact',
            //         style: TextStyle(
            //           fontSize: 22,
            //           fontWeight: FontWeight.w600,
            //           color: Theme.of(context).primaryColor,
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(
            //         "${(userData['serviceLine'] != null && userData['serviceLine'] != '') ? userData['serviceLine'] : 'Not Available'}",
            //         style: TextStyle(
            //           fontSize: 22,
            //           color: Theme.of(context).primaryColor,
            //         ),
            //         textAlign: TextAlign.justify,
            //       ),
            //     ),
            //   ],
            // ),

            // Office Email
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Office Email',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['officeEmail'] != null && userData['officeEmail'] != '') ? userData['officeEmail'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // Other details
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Other Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['otherDetails'] != null && userData['otherDetails'] != '') ? userData['otherDetails'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Other tab
  Widget _otherTabContent(dynamic userData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(color: Color(0xff8d6e52))),
          columnWidths: {
            0: FractionColumnWidth(0.4),
          },
          // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Hobbies',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['hobbies'] != null && userData['hobbies'] != '') ? userData['hobbies'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // personal Interests
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Personal Interests:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['personalInterests'] != null && userData['personalInterests'] != '') ? userData['personalInterests'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // Awards
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Special Awards',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['specialAwards'] != null && userData['specialAwards'] != '') ? userData['specialAwards'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            // social interests
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Social Interests:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(userData['socialInterests'] != null && userData['socialInterests'] != '') ? userData['socialInterests'] : 'Not Available'}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/logo2.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  Widget _parentList(
      {List<dynamic> list, bool isParent = true, @required String userId}) {
    return SizedBox(
      height: 100,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 37,
            left: 84,
            right: 30,
            child: Container(height: 2, color: Theme.of(context).accentColor),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(left: 16),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (ctx, i) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: list[i]['id'] != userId
                        ? () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (ctx) => UserProfile(
                                      relationPath:
                                          'users/$userId/addedMembers/${list[i]['relation']}',
                                    )));
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: EdgeInsets.only(
                          right: (list.length <= 2 && !isParent) ? 16 : 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                list[i]['profileImageUrl'],
                              ),
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '${list[i]['firstName']} ${(list[i]['lastName'])}',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        list[i]['relation'] != null
                            ? '(${list[i]['relation']})'
                            : '',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: list.length,
          ),
        ],
      ),
    );
  }

  // calc age
  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
