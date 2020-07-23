import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class FamilyMembersScreen extends StatefulWidget {
  @override
  _FamilyMembersScreenState createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> filteredList = [];
  bool showLoader = false;
  bool soryByName = false;
  String selectedString;
  List<String> alphabetsList = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ];
  final UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    _getUsersList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
            color: Theme.of(context).accentColor,
            child: SizedBox(
              height: 55,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: alphabetsList.length,
                  padding: const EdgeInsets.only(left: 28),
                  itemBuilder: (ctx, i) {
                    return GestureDetector(
                      onTap: () {
                        _soryByLetter(alphabetsList[i]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: selectedString == alphabetsList[i]
                                ? Theme.of(context).primaryColor
                                : Colors.white54,
                            border: Border.all(
                              color: selectedString == alphabetsList[i]
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Text(
                            alphabetsList[i].toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selectedString == alphabetsList[i]
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
        appBar: AppBar(
          title: Text('Family Members'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (showLoader) LinearProgressIndicator(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Sort By First Name',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Switch(
                    value: soryByName,
                    onChanged: _onSortChanged,
                    activeColor: Theme.of(context).accentColor,
                  ),
                  Text(
                    'Last Name',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              if (!showLoader && userList != null)
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: filteredList.length,
                  itemBuilder: (ctx, i) {
                    return Card(
                      key: ValueKey(filteredList[i]['id']),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(5),
                        onTap: () {},
                        leading: CircleAvatar(
                          minRadius: 24,
                          maxRadius: 24,
                          backgroundColor: Theme.of(context).accentColor,
                          backgroundImage: CachedNetworkImageProvider(
                              filteredList[i]['profileImageUrl']),
                        ),
                        title: Text(!soryByName
                            ? '${filteredList[i]['firstName']} ${filteredList[i]['middleName']} ${filteredList[i]['lastName']}'
                            : '${filteredList[i]['lastName']} ${filteredList[i]['middleName']} ${filteredList[i]['firstName']}'),
                        subtitle: (filteredList[i]['isMarried'] &&
                                filteredList[i]['gender'] == 'Female')
                            ? Text(
                                '${filteredList[i]['firstName']} ${filteredList[i]['fatherName']} ${filteredList[i]['motherName']} ${filteredList[i]['oldSurname']}',
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              )
                            : Text(''),
                      ),
                    );
                  },
                ),
            ],
          ),
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

  // on sort changed
  _onSortChanged(bool val) {
    setState(() {
      soryByName = val;
      selectedString = '';
    });

    if (!val) {
      filteredList = userList;
      filteredList.sort((a, b) {
        return a['firstName']
            .toString()
            .toLowerCase()
            .compareTo(b['firstName'].toString().toLowerCase());
      });
    } else {
      filteredList = userList;
      filteredList.sort((a, b) {
        return a['lastName']
            .toString()
            .toLowerCase()
            .compareTo(b['lastName'].toString().toLowerCase());
      });
    }
  }

  // get userlist
  _getUsersList() {
    _hideShowLoader(true);
    Future.delayed(Duration.zero, () async {
      try {
        var list = await userService.getAllMembers();
        setState(() {
          userList = list;
          filteredList = userList;

          filteredList.sort((a, b) {
            return a['firstName']
                .toString()
                .toLowerCase()
                .compareTo(b['firstName'].toString().toLowerCase());
          });
        });
        _hideShowLoader(false);
      } catch (err) {
        print(err.toString());
        print('Error getting all members');
        _hideShowLoader(false);
        setState(() {
          userList = [];
        });
      }
    });
  }

  _soryByLetter(String letter) {
    filteredList = userList;
    setState(() {
      selectedString = letter;
      if (!soryByName) {
        filteredList = filteredList.where((element) {
          return element['firstName']
                  .toString()
                  .substring(0, 1)
                  .toLowerCase() ==
              letter.toLowerCase();
        }).toList();
      } else {
        filteredList = filteredList
            .where((element) =>
                element['lastName'].toString().substring(0, 1).toLowerCase() ==
                letter.toLowerCase())
            .toList();
      }
    });
  }
}
