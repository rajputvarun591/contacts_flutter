import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final void Function() onTap;
  final String firstName;
  final String lastName;
  final Uint8List? image;
  const UserImage({Key? key, required this.onTap, required this.firstName, required this.lastName, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    BorderRadius br = BorderRadius.circular((min(size.width, size.height) / 4) / 2);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: min(size.width, size.height) / 4,
        width: min(size.width, size.height) / 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: br,
        ),
        child: ClipRRect(
          borderRadius: br,
          child: image == null
              ? Icon(Icons.person, color: Colors.white70, size: 35.00,)
              : Image.memory(image!, fit: BoxFit.cover,),
        ),
      ),
    );
  }

  String getLetter(String name) {
    if(name.characters.isEmpty) {
      return "";
    } else {
      return name.characters.first.toUpperCase();
    }
  }
}
