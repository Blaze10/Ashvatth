import 'package:Ashvatth/screens/user_profile.dart';
import 'package:Ashvatth/services/user_service.dart';
import 'package:Ashvatth/widgets/bottomsearch.dart';
import 'package:Ashvatth/widgets/tree.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserHomeScreen extends StatelessWidget {
  final userDataFuture = UserService().getCurrentUserData();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Center(
            child: Stack(
              // overflow: Overflow.visible,
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
                                height:
                                    MediaQuery.of(context).size.height * 0.11,
                                width:
                                    MediaQuery.of(context).size.height * 0.11,
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
                    }),
                Positioned(
                  top: 16,
                  right: (MediaQuery.of(context).size.height * 0.11) - 50,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.height * 0.07,
                    child: FloatingActionButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return Container(
                                child: BottomSearch(
                                  ctx: context,
                                ),
                                height: MediaQuery.of(context).size.height * .8,
                              );
                            });
                      },
                      child: Icon(Icons.add, color: Colors.white),
                      backgroundColor: Color(0xffab4612),
                    ),
                  ),
                ),
                Positioned(
                  top: (MediaQuery.of(context).size.height * 0.11) / 2,
                  right: (MediaQuery.of(context).size.height * 0.11),
                  child: Container(
                    width: 50,
                    height: 2,
                    color: Color(0xff8d6e52),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  mini: true,
                  heroTag: 'left',
                  child: Icon(
                    Icons.account_circle,
                    color: Theme.of(context).accentColor,
                    size: 32,
                  ),
                  backgroundColor: Color(0xfff0cc8d),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (ctx) => UserProfile()),
                    );
                  },
                ),
                FloatingActionButton(
                  heroTag: 'mid',
                  child: Icon(
                    Icons.public,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  backgroundColor: Color(0xfff0cc8d),
                  onPressed: () {},
                ),
                FloatingActionButton(
                  heroTag: 'right',
                  mini: true,
                  child: Icon(
                    FontAwesomeIcons.tree,
                    color: Theme.of(context).accentColor,
                    size: 30,
                  ),
                  backgroundColor: Color(0xfff0cc8d),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(builder: (ctx) => Tree()),
                    );
                    // showModalBottomSheet(
                    //     context: context,
                    //     isScrollControlled: true,
                    //     builder: (context) {
                    //       return Container(
                    //         child: BottomSearch(),
                    //         height: MediaQuery.of(context).size.height * .8,
                    //       );
                    //     });
                  },
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
