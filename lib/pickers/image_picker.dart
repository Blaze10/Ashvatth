import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker({this.imagePickedFn, this.displayImage});
  final Widget displayImage;
  final void Function(File pickedImage) imagePickedFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(0),
            title: Text(
              'Source',
              style: Theme.of(context).textTheme.headline1,
            ),
            actions: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                icon: Icon(
                  Icons.perm_media,
                  color: Theme.of(context).accentColor,
                ),
                label: Text(
                  'Gallery',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                icon: Icon(
                  Icons.camera,
                  color: Theme.of(context).accentColor,
                ),
                label: Text(
                  'Camera',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }).then((value) async {
      final picker = ImagePicker();
      final pickedImage = await picker.getImage(
        source: value ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
        // maxWidth: 150,
      );
      final pickedImageFile = File(pickedImage.path);
      setState(() {
        _pickedImage = pickedImageFile;
      });
      widget.imagePickedFn(_pickedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.displayImage == null)
          Container(
            width: MediaQuery.of(context).size.height * 0.26,
            height: MediaQuery.of(context).size.height * 0.26,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xfff0cc8d),
                image: _pickedImage != null
                    ? DecorationImage(
                        image: FileImage(_pickedImage),
                        fit: BoxFit.fill,
                      )
                    : null),
          ),
        if (widget.displayImage != null) widget.displayImage,
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
            child: Icon(
              Icons.camera_alt,
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Theme.of(context).accentColor,
            onPressed: _pickImage,
            mini: true,
          ),
        )
      ],
    );
  }
}
