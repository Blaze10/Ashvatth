import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String imageUrl;
  final String username, middleText, mainText, confirmBtnText;
  final bool showDelete;
  final Function onConfirm, onDelete;

  NotificationCard({
    @required this.imageUrl,
    @required this.username,
    @required this.middleText,
    @required this.mainText,
    this.confirmBtnText = 'Accept',
    this.showDelete = false,
    @required this.onConfirm,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(this.imageUrl),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$username',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.left,
                      ),
                      // SizedBox(height: 8),
                      Text(
                        '$middleText',
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '$mainText',
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: FlatButton(
                    color: Colors.green.withOpacity(0.4),
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      '$confirmBtnText',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    onPressed: onConfirm,
                  ),
                ),
                if (showDelete) SizedBox(width: 16),
                if (showDelete)
                  Flexible(
                    child: FlatButton(
                      color: Colors.red.withOpacity(0.4),
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Remove',
                        style: Theme.of(context).textTheme.headline1.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      onPressed: onDelete,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
