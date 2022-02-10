import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageBottomSheet extends StatelessWidget {
  final String title;
  final String cameraTitle;
  final String galleryTitle;

  const ImageBottomSheet({Key? key, required this.title, required this.cameraTitle, required this.galleryTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
        onClosing: () => _onClose(context),
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.00),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(10.00),
            margin: const EdgeInsets.all(10.00),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey, fontSize: 18.00),
                ),
                Divider(),
                InkWell(
                  onTap: () => onCameraPressed(context),
                  child: Container(
                      height: kTextTabBarHeight,
                      alignment: Alignment.center,
                      child: Text(
                        cameraTitle,
                        style: TextStyle(color: Colors.blue, fontSize: 16.00),
                      )),
                ),
                Divider(
                  height: 1.00,
                ),
                InkWell(
                  onTap: () => onCameraPressed(context),
                  child: Container(
                      alignment: Alignment.center,
                      height: kTextTabBarHeight,
                      child: Text(
                        galleryTitle,
                        style: TextStyle(color: Colors.blue, fontSize: 16.00),
                      )),
                )
              ],
            ),
          );
        },
        backgroundColor: Colors.transparent,
      );
    } else {
      return CupertinoActionSheet(
        title: Text(title),
        actions: [
          CupertinoActionSheetAction(onPressed: () => onCameraPressed(context), child: Text(cameraTitle)),
          CupertinoActionSheetAction(onPressed: () => onGalleryPressed(context), child: Text(galleryTitle)),
        ],
      );
    }
  }

  void onCameraPressed(BuildContext context) {
    Navigator.of(context).pop(ImageSource.camera);
  }

  void onGalleryPressed(BuildContext context) {
    Navigator.of(context).pop(ImageSource.gallery);
  }

  void _onClose(BuildContext context) {
    Navigator.of(context).pop(null);
  }
}
