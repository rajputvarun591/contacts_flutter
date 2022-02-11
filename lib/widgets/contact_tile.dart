import 'package:contacts_flutter/models/contact.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as launcher;

import 'circular_image.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isSelectionOpen;
  final bool isSelected;
  final void Function(Contact) onTap;
  final void Function(Contact) onLongPress;
  const ContactTile({Key? key, required this.contact, required this.isSelectionOpen, required this.isSelected, required this.onTap, required this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        constraints: BoxConstraints.tight(Size(45.0, 45.00)),
        decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        child: CircularImage(
          image: contact.image,
          firstName: contact.firstName,
          lastname: contact.lastName,
        ),
      ),
      title: Text(contact.firstName + " " + contact.lastName,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFFFFFFF) : Color(0xFF3C3C3C),
              fontSize: 16.00,
              fontWeight: FontWeight.w600)),
      subtitle: Text(contact.contactNumber,
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFCCCCCC) : Color(0xFF6C6C6C),
              fontSize: 14.00,
              fontWeight: FontWeight.w400)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Visibility(
              visible: !isSelectionOpen,
              child: InkWell(
                child: Container(
                    padding: const EdgeInsets.all(6.00),
                    decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle),
                    child: Icon(Icons.call, color: Color(0xFFFFFFFF), size: 18.00)),
                onTap: () async {
                  await launcher.launch("tel://${contact.contactNumber}");
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Visibility(
              visible: !isSelectionOpen,
              child: InkWell(
                child: Container(
                    padding: const EdgeInsets.all(6.00),
                    decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle),
                    child: Icon(Icons.mail, color: Color(0xFFFFFFFF), size: 18.00)),
                onTap: () async {
                  await launcher.launch("mailto://${contact.email}");
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Visibility(
              visible: !isSelectionOpen,
              child: InkWell(
                child: Container(
                    padding: const EdgeInsets.all(6.00),
                    decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle),
                    child: Icon(Icons.message_rounded, color: Color(0xFFFFFFFF), size: 18.00)),
                onTap: () async {
                  await launcher.launch("smsto://${contact.contactNumber}");
                },
              ),
            ),
          ),
          Visibility(
            visible: isSelectionOpen,
            child: InkWell(
              child: Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: Colors.blue,
                size: 30.00,
              ),
              onTap: () => onTap(contact),
            ),
          )
        ],
      ),
      enableFeedback: true,
      selected: isSelected,
      selectedTileColor: Theme.of(context).brightness == Brightness.dark ? Color(0xFF7C7C7C) : Color(0xFFE3EFFF),
      onTap: () => onTap(contact),
      onLongPress: () => onLongPress(contact),
    );
  }
}
