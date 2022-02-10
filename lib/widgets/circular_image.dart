import 'dart:typed_data';

import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final Uint8List? image;
  final String? firstName;
  final String? lastname;
  const CircularImage({Key? key, required this.image, this.firstName, this.lastname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image != null && image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(22.50)),
        child: Image.memory(image!, fit: BoxFit.cover, errorBuilder: _errorBuilder),
      );
    } else {
      return getNameWidget(firstName, lastname);
    }
  }

  Widget _errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return getNameWidget(firstName, lastname);
  }

  Widget getNameWidget(String? firstName, String? lastname) {
    if (firstName != null && lastname != null) {
      final f = firstName.characters.first.toUpperCase();
      final l = lastname.characters.first.toUpperCase();
      return Center(child: Text(f + "" + l, style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15.00, fontWeight: FontWeight.w600)));
    } else {
      return Center(child: Text("" + " " + "", style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15.00, fontWeight: FontWeight.w600)));
    }
  }
}
