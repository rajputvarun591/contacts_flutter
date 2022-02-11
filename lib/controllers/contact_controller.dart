import 'package:contacts_flutter/database/hive_database.dart';
import 'package:contacts_flutter/models/contact.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  RxList<Contact> contacts = RxList<Contact>();
  var selectedContacts = <Contact>[].obs;

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

  void deleteContacts() {
    HiveDatabase().deleteContacts(selectedContacts).then((value) {
      contacts.value = HiveDatabase().getAllContacts();
      update();
    });
  }

  void insertInDeleteList(Contact contact) {
    selectedContacts.add(contact);
    update();
  }

  void clearSelected() {
    selectedContacts.clear();
    update();
  }

  void removeFromSelected(Contact contact) {
    selectedContacts.remove(contact);
    update();
  }
}