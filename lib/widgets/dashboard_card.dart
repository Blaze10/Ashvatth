import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String numberText;
  final String titleText;
  final Color color;

  DashboardCard({
    @required this.icon,
    @required this.numberText,
    @required this.titleText,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 12,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            width: 130,
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '$numberText',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$titleText',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            )),
          ),
        ),
        Positioned(
          left: 10,
          top: 8,
          child: Icon(
            icon,
            color: Colors.black12,
            size: 32,
          ),
        ),
      ],
    );
  }
}
