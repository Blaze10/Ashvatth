import 'package:flutter/material.dart';

class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Center(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Column(
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
                        height: MediaQuery.of(context).size.height * 0.11,
                        width: MediaQuery.of(context).size.height * 0.11,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Text('Raaj',
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            .copyWith(fontWeight: FontWeight.w700))
                  ],
                ),
                Positioned(
                  top: 16,
                  left: (MediaQuery.of(context).size.height * 0.11) + 16 + 50,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.height * 0.07,
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: Icon(Icons.add, color: Colors.white),
                      backgroundColor: Color(0xffab4612),
                    ),
                  ),
                ),
                Positioned(
                  top: (MediaQuery.of(context).size.height * 0.11) / 2,
                  left: (MediaQuery.of(context).size.height * 0.11) + 16,
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
                  onPressed: () {},
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
                    Icons.crop_free,
                    color: Theme.of(context).accentColor,
                    size: 32,
                  ),
                  backgroundColor: Color(0xfff0cc8d),
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
