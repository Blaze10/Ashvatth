import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickedFn);

  final void Function(File pickedImage) imagePickedFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 80,
      // maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickedFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.height * 0.26,
          height: MediaQuery.of(context).size.height * 0.26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xfff0cc8d),
            image: _pickedImage != null ? DecorationImage(
              
              image: FileImage(_pickedImage),
              fit: BoxFit.fill,
              
            ) : null
          ),
        ),
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
