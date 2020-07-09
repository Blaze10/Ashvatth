import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            _backbutton(),
            _profileImage(),
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
                child: _treeTabContent(),
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
        ),
      ),
    );
  }

  // back button
  Widget _backbutton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 0, left: 16),
        child: IconButton(
          icon: Icon(Icons.keyboard_backspace, size: 28),
          onPressed: () => Navigator.of(context).pop(),
          color: Color(0xff8d6e52),
        ),
      ),
    );
  }

  // top image
  Widget _profileImage() {
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
                      image: AssetImage('assets/profile.png'),
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Raaj Jones',
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
                    'Birth date:',
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
                    'Age:',
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
                    'Notes:',
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
  Widget _treeTabContent() {
    return Center(
        child: Text(
      '🌱 \nComming soon!',
      style: Theme.of(context).textTheme.headline1,
      textAlign: TextAlign.center,
    ));
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
                    'Permanent Address:',
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
                    'Current Address:',
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
                    'Phone No:',
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
                    'Mobile No:',
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
                    'Email:',
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
                    'Qualification:',
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
                    'University:',
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
                    'School:',
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
                    'Company Name:',
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
                    'Service Line:',
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
                    'Contact:',
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
                    'About:',
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
}
