import 'dart:math';

import 'package:contacts_flutter/models/contact.dart';
import 'package:contacts_flutter/views/add_edit_contact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart' as launcher;

class ProfileView extends StatelessWidget {
  final Contact contact;
  const ProfileView({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTapDown,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: 100.00,
          horizontal: 30.00,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.00),
          color: Colors.black26,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: contact.createdAt.toString(),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.00), topRight: Radius.circular(10.00)),
                child: Image.memory(
                  contact.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15.00),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.00), bottomRight: Radius.circular(10.00)),
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.00),
                        child: Icon(Icons.call, color: Color(0xFFFFFFFF), size: 22.00),
                        onTap: () async {
                          await launcher.launch("tel://${contact.contactNumber}");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.00),
                        child: Icon(Icons.mail, color: Color(0xFFFFFFFF), size: 22.00),
                        onTap: () async {
                          await launcher.launch("mailto://${contact.email}");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.00),
                        child: Icon(Icons.message_rounded, color: Color(0xFFFFFFFF), size: 22.00),
                        onTap: () async {
                          await launcher.launch("smsto://${contact.contactNumber}");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.00),
                        child: Icon(Icons.info_outline_rounded, color: Color(0xFFFFFFFF), size: 22.00),
                        onTap: () async {
                          _onTapDown();
                          Get.to(() => AddEditContact(contact: contact));
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onTapDown() {
    Get.back();
  }


}
