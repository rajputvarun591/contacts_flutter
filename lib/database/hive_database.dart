import 'dart:developer';

import 'package:contacts_flutter/models/address.dart';
import 'package:contacts_flutter/models/contact.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

class HiveDatabase {

  HiveDatabase.instance();

  static final HiveDatabase _internal = HiveDatabase.instance();

  factory HiveDatabase() => _internal;

  static const String CONTACTS_BOX = "CONTACTS_BOX";
  static initHiveDatabase() async {
    final directory = await path.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(ContactAdapter());
    Hive.registerAdapter(AddressAdapter());
  }

  List<Contact> getAllContacts() {
    List<Contact> contacts = [];
    final contactBox = Hive.box(CONTACTS_BOX);
    for (int i = 0; i < contactBox.length; i++) {
      contacts.add(contactBox.getAt(i) as Contact);
    }
    log(contactBox.toMap().toString());
    return contacts;
  }

  Future<void> saveContact(Contact contact) async {
    final contactBox = Hive.box(CONTACTS_BOX);
    return await contactBox.put(contact.id, contact);
  }

  Future<void> deleteContacts(List<Contact> contacts) async{
    final contactBox = Hive.box(CONTACTS_BOX);
    List<String> keys = contacts.map((e) => e.id).toList();
    return await contactBox.deleteAll(keys);
  }

  Future<void> updateContact(Contact contact, String id) async {
    final contactBox = Hive.box(CONTACTS_BOX);
    return await contactBox.put(id, contact);
  }
}
