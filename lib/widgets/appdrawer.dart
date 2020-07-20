import 'package:Ashvatth/screens/user_info.dart';
import 'package:Ashvatth/screens/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bottomsearch.dart';

class AppDrawerWidger extends StatelessWidget {
  // final String profileImageUrl;
  // final String userName;

  // AppDrawerWidger({@required this.profileImageUrl, @required this.userName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: const EdgeInsets.all(8),
            child: Text(''),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // color: Theme.of(context).primaryColor,
              image: DecorationImage(
                image: AssetImage('assets/logo.png'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Theme.of(context).accentColor,
              size: 34,
            ),
            title: Text('User Profile',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: 21,
                    )),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
              size: 16,
            ),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (ctx) => UserProfile()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_circle,
              color: Theme.of(context).accentColor,
              size: 34,
            ),
            title: Text('Add Member',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontSize: 21,
                    )),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).primaryColor,
              size: 16,
            ),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) {
                    return Container(
                      child: BottomSearch(
                        ctx: ctx,
                      ),
                      height: MediaQuery.of(context).size.height * .8,
                    );
                  }).then((res) {
                if (res != null && res.runtimeType == String) {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (ctx) => UserInfoFormPage(relationship: res),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
