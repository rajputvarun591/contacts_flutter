import 'package:contacts_flutter/database/hive_database.dart';
import 'package:contacts_flutter/models/contact.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  RxList<Contact> contacts = RxList<Contact>();

  @override
  InternalFinalCallback<void> get onStart{
    contacts.value = HiveDatabase().getAllContacts();
    return super.onStart;
  }

  void addContact(Contact contact) {
    HiveDatabase().saveContact(contact).then((value) {
      contacts.value = HiveDatabase().getAllContacts();
      update();
    });
  }

  // void updateContact(Contact contact, int index) {
  //   HiveDatabase().updateContact(contact, index).then((value) {
  //     contacts.value = HiveDatabase().getAllContacts();
  //     update();
  //   });
  // }

  void deleteContacts(List<Contact> contact) {
    HiveDatabase().deleteContacts(contact).then((value) {
      contacts.value = HiveDatabase().getAllContacts();
      update();
    });
  }
}