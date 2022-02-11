import 'dart:io';
import 'package:contacts_flutter/constants/constants.dart';
import 'package:contacts_flutter/controllers/contact_controller.dart';
import 'package:contacts_flutter/models/contact.dart';
import 'package:contacts_flutter/styles/text_styles.dart';
import 'package:contacts_flutter/views/add_edit_contact.dart';
import 'package:contacts_flutter/widgets/circular_image.dart';
import 'package:contacts_flutter/widgets/contact_tile.dart';
import 'package:contacts_flutter/widgets/leading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ContactsPage extends StatefulWidget {

  static MaterialPage page() {
    return MaterialPage(
      child: ContactsPage(),
      name: rpHomeView,
      key: ValueKey(rpHomeView),
    );
  }

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSelectionOpen = false;

  ContactController controller = Get.put(ContactController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.blue));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: !_isSelectionOpen ? Text ("Contacts") : Obx(() => Text("${controller.selectedContacts.length} Selected")),
          leading: LeadingWidget(isEnable: _isSelectionOpen, onPressed: () => _onWillPop()),
          leadingWidth: _isSelectionOpen ? kTextTabBarHeight : 0.0,
          actions: [
            Visibility(
              visible: _isSelectionOpen,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: _onDeletePressed,
              ),
            )
          ],
          elevation: 0.0,
        ),
        body: GetBuilder<ContactController>(
              init: controller,
              builder: (controller) {
                List<Contact> list = controller.contacts;
                if (list.isEmpty)
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.contacts, color: Colors.blue, size: 45.00),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "No Contacts Found!",
                            style: ts15PTMontserratSemiBold,
                          ),
                        ),
                      ],
                    ),
                  );
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10.00),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ContactTile(
                      contact: list[index],
                      onTap: _onTap,
                      onLongPress: _onLongPress,
                      isSelected: controller.selectedContacts.contains(list[index]),
                      isSelectionOpen: _isSelectionOpen,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 70.0),
                      child: Divider(height: 1.00),
                    );
                  },
                );
              },
            ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: _gotToNext,
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  void _onLongPress(Contact contact) {
    controller.clearSelected();
    setState(() {
      _isSelectionOpen = true;
      controller.insertInDeleteList(contact);
    });
  }

  Future<bool> _onWillPop() async {
    if (_isSelectionOpen) {
      setState(() {
        _isSelectionOpen = false;
        controller.clearSelected();
      });
      return false;
    } else {
      return true;
    }
  }

  void _onDeletePressed() async {
    final isSure = await showDialog(
        context: context,
        builder: (context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text("Are you sure you want to delete the selected contacts?"),
              content: Text("by delete the contacts they are vanished permanantly and can not be rollback.",
                  style: TextStyle(color: Color(0xFFFF0000))),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text("Delete", style: TextStyle(color: Color(0xFFFF0000))),
                  onPressed: () => Navigator.of(context).pop(true),
                )
              ],
            );
          } else {
            return AlertDialog(
              title: Text("Are you sure you want to delete the selected contacts?"),
              content: Text("by delete the contacts they are vanished permanantly and can not be rollback.",
                  style: TextStyle(color: Color(0xFFFF0000))),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text("Delete", style: TextStyle(color: Color(0xFFFF0000))),
                  onPressed: () => Navigator.of(context).pop(true),
                )
              ],
            );
          }
        });

    if (isSure) {
      controller.deleteContacts();
      setState(() {
        _isSelectionOpen = false;
      });
    }
  }

  void _onTap(Contact contact) {
    if (_isSelectionOpen) {
      if (controller.selectedContacts.contains(contact)) {
        setState(() {
          controller.removeFromSelected(contact);
        });
        if (controller.selectedContacts.length == 0) {
          setState(() {
            _isSelectionOpen = false;
          });
        }
      } else {
        setState(() {
          controller.insertInDeleteList(contact);
        });
      }
    } else {
      _gotToNext(contact);
    }
  }

  void _gotToNext([Contact? contact]) {
    Get.to(() => AddEditContact(contact: contact));
  }
}
