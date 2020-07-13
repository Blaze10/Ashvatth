import 'package:Ashvatth/services/user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dart:async';
import 'dart:ui' as ui;

class UserProfile extends StatefulWidget {
  final String username;

  UserProfile({this.username});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var _userService = UserService();
  var userDataFuture = UserService().getCurrentUserData();
  final List<String> profileTabList = [
    'Tree',
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<dynamic>(
            future: userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Some error occured, try again later'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
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
                      child: _infoTabContent(),
                    ),
                  if (_selectedTab == 'Tree')
                    Expanded(
                      child: _treeTabContent(
                          userId: snapshot.data['id'],
                          isMarried: snapshot.data['isMarried']),
                    ),
                  if (_selectedTab == 'Contact')
                    Expanded(
                      child: _contactTabContent(),
                    ),
                  if (_selectedTab == 'Education')
                    Expanded(
                      child: _educationTabContent(),
                    ),
                  if (_selectedTab == 'Occupation')
                    Expanded(
                      child: _occupationTabContent(),
                    ),
                  if (_selectedTab == 'Other')
                    Expanded(
                      child: _otherTabContent(),
                    ),
                ],
              );
            }),
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
      IconButton(
        icon: Icon(FontAwesomeIcons.qrcode, size: 28),
        onPressed: () {
          final key = encrypt.Key.fromLength(32);
          final iv = encrypt.IV.fromLength(8);
          final encrypter = encrypt.Encrypter(encrypt.Salsa20(key));

          final encrypted = encrypter.encrypt('plainText', iv: iv);
          // final decrypted = encrypter.decrypt(encrypted, iv: iv);
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: FittedBox(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          CustomPaint(
                            size: Size.square(280),
                            painter: QrPainter(
                              data: encrypted.base64,
                              version: QrVersions.auto,
                              // size: 320.0,
                              color: Colors.brown,
                              embeddedImageStyle: QrEmbeddedImageStyle(
                                size: Size.square(60),
                              ),
                            ),
                          ),
                          Text('$firstName $lastName',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .copyWith(fontSize: 21)),
                          Text(
                            'Scan this QR code to send relationship request',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        color: Color(0xff8d6e52),
      ),
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
  Widget _infoTabContent() {
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
                    '14-5-1996',
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
                    '24',
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
                    'I am a Radio Jocket & Celebrity Interviewer. Hip Hop Journalist. Dilli Ka Sabse Family Launda',
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
          left: (MediaQuery.of(context).size.width / 2),
          child: Container(
            height: isMarried ? 190 : 90,
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
                      ? _parentList(list: list)
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
                      ? _parentList(list: list, isParent: false)
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
                      ? _parentList(list: list, isParent: false)
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
  Widget _contactTabContent() {
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
                    '511, Powai Plaza, Hiranandani Business Park, Powai Mumbai-400076',
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
                    '511, Powai Plaza, Hiranandani Business Park, Powai Mumbai-400076',
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
                    '0222570271',
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
                    '7506307509',
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
                    'thisismyemail@email.com',
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
  Widget _educationTabContent() {
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
                    'B.Sc. (I.T)',
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
                    'University of Mumbai',
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
                    'Convent of Jesus & Mary',
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
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur auctor viverra maximus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
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
  Widget _occupationTabContent() {
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
                    'LillieMountain',
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
                    'Information Technology',
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
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Contact',
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
                    '7506307509',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

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
                    'thisismyemail@mail.com',
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
                    'LillieMountian is an agency founded by a trio of designer & developers in 2020. It is software and design agency that answers problems of businesses with their functional design and pragmatic software services.',
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
  Widget _otherTabContent() {
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
                    'MMORG games ,hip-hop, sleeping',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // Social Interests
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
                    'Teaching, Dev Communities',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),

            // About
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'About',
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
                    'Over the years I\'ve accumulated knowledge about bringing business to the internet with since my initial freelancing years of 2015. I can help you understand what\'s great for your business when you want to start an e-commerce web/app. ',
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

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('assets/logo2.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }

  Widget _parentList({List<dynamic> list, bool isParent = true}) {
    return SizedBox(
      height: 80,
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
              return Container(
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
              );
            },
            itemCount: list.length,
          ),
        ],
      ),
    );
  }
}
