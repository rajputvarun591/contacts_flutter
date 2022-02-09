import 'dart:developer';
import 'dart:io';

import 'package:contacts_flutter/controllers/contact_controller.dart';
import 'package:contacts_flutter/models/address.dart';
import 'package:contacts_flutter/models/contact.dart';
import 'package:contacts_flutter/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart' as launcher;

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSelectionOpen = false;
  bool isOpened = false;

  List<Contact> _selectedContacts = [];

  ContactController controller = Get.put(ContactController());

  late String id;
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _contactNumber = TextEditingController();
  TextEditingController _address = TextEditingController();

  bool get isSaveEnable =>
      _firstName.text.isNotEmpty && _lastName.text.isNotEmpty && _contactNumber.text.isNotEmpty && _address.text.isNotEmpty;

  bool isEditing = false;

  late AnimationController animationController;
  late Animation<double> transformationAddButton;
  late Animation<double> transformationSheet;
  late Animation<double> iconRotation;
  late Animation<Color?> animateColor;
  late Animation<Icon> animateIcon;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.blue));
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    )..addListener(() {
        setState(() {});
      });
    transformationAddButton = Tween<double>(begin: 0.00, end: 320.00).animate(animationController);
    transformationSheet = Tween<double>(begin: -330.00, end: 0.00).animate(animationController);
    iconRotation = Tween<double>(begin: 0.00, end: math.pi / 4).animate(animationController);
    animateColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
    _address.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _contactNumber.dispose();
    _address.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            _isSelectionOpen ? "${_selectedContacts.length} Selected" : "Contacts",
          ),
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
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Expanded(
                    child: GetBuilder<ContactController>(
                      init: controller,
                      builder: (controller) {
                        List<Contact> list = controller.contacts;
                        if (list.isEmpty)
                          return Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.contacts, color: Colors.orange, size: 45.00),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "No Contacts Found!",
                                  style: ts15PTMontserratSemiBold,
                                ),
                              ),
                            ],
                          ));
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 10.00),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Container(
                                constraints: BoxConstraints.tight(Size(45.0, 45.00)),
                                decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                                padding: const EdgeInsets.all(5.00),
                                alignment: Alignment.center,
                                child: Text(
                                    list[index].firstName.toString().characters.first.toUpperCase() +
                                        "" +
                                        list[index].lastName.toString().characters.first.toUpperCase(),
                                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15.00, fontWeight: FontWeight.w600)),
                              ),
                              title: Text(list[index].firstName + " " + list[index].lastName,
                                  style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFFFFFFF) : Color(0xFF3C3C3C),
                                      fontSize: 16.00,
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(list[index].contactNumber,
                                  style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFCCCCCC) : Color(0xFF6C6C6C),
                                      fontSize: 14.00,
                                      fontWeight: FontWeight.w400)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: !_isSelectionOpen,
                                    child: InkWell(
                                      child: Container(
                                          padding: const EdgeInsets.all(8.00),
                                          decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle),
                                          child: Icon(Icons.call, color: Color(0xFFFFFFFF), size: 13.00)),
                                      onTap: () async {
                                        print(await launcher.canLaunch("tel://${list[index].contactNumber}"));
                                        print("tel://${list[index].contactNumber}");
                                        await launcher.launch("tel://${list[index].contactNumber}");
                                      },
                                    ),
                                  ),
                                  AnimatedCrossFade(
                                    firstChild: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: InkWell(
                                        child: Container(
                                            padding: const EdgeInsets.all(5.00),
                                            decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle),
                                            child: Icon(Icons.keyboard_arrow_right_sharp, color: Color(0xFFFFFFFF), size: 18.00)),
                                        onTap: () {
                                          _animate();
                                          isEditing = true;
                                          id = list[index].id;
                                          _firstName.text = list[index].firstName;
                                          _lastName.text = list[index].lastName;
                                          _contactNumber.text = list[index].contactNumber;
                                          _address.text = list[index].address.name;
                                        },
                                      ),
                                    ),
                                    secondChild: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: InkWell(
                                        child: Container(
                                            padding: const EdgeInsets.all(5.00),
                                            decoration: BoxDecoration(color: Colors.green.shade400, shape: BoxShape.circle),
                                            child: Icon(Icons.check, color: Color(0xFFFFFFFF), size: 18.00)),
                                      ),
                                    ),
                                    crossFadeState:
                                        _selectedContacts.contains(list[index]) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                                    duration: Duration(milliseconds: 500),
                                    firstCurve: Curves.linear,
                                  ),
                                ],
                              ),
                              enableFeedback: true,
                              selected: _selectedContacts.contains(list[index]),
                              selectedTileColor: Theme.of(context).brightness == Brightness.dark ? Color(0xFF7C7C7C) : Color(0xFFE3EFFF),
                              onTap: () => _onTap(list[index]),
                              onLongPress: () => _onLongPress(list[index]),
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
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0.00),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Transform(
                      transform: Matrix4.translationValues(0.0, -transformationSheet.value, 0.0),
                      child: Container(
                        height: 350.00,
                        margin: const EdgeInsets.only(bottom: 10.00, left: 10.00, right: 10.00),
                        padding: const EdgeInsets.all(10.00),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF7C7C7C) : Colors.blue.shade100,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.00),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _firstName,
                              //validator: (value) => value != null && value.isNotEmpty ? null : "Enter First Name",
                              decoration: InputDecoration(labelText: "First Name", alignLabelWithHint: true),
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                            ),
                            TextField(
                              controller: _lastName,
                              //validator: (value) => value != null && value.isNotEmpty ? null : "Enter Last Name",
                              decoration: InputDecoration(labelText: "Last Name", alignLabelWithHint: true),
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                            ),
                            TextField(
                              controller: _contactNumber,
                              //validator: (value) => value != null && value.isNotEmpty ? null : "Enter Contact Number",
                              decoration: InputDecoration(labelText: "Contact Number", alignLabelWithHint: true),
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                            ),
                            TextField(
                              controller: _address,
                              //validator: (value) => value != null && value.isNotEmpty ? null : "Enter Address",
                              decoration: InputDecoration(labelText: "Address", alignLabelWithHint: true),
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 10.00),
                            Container(
                              constraints: BoxConstraints(minWidth: double.infinity),
                              child: ElevatedButton(
                                  onPressed: isSaveEnable
                                      ? () {
                                          Address address = Address();
                                          address.name = _address.text;
                                          Contact contact = Contact(
                                            DateTime.now().toIso8601String(),
                                            _firstName.text,
                                            _lastName.text,
                                            _contactNumber.text,
                                            address,
                                          );
                                          isEditing ? controller.updateContact(contact, id) : controller.addContact(contact);
                                          _animate();
                                        }
                                      : null,
                                  child: Text("Save")),
                            ),
                            SizedBox(height: 10.00),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Transform(
                      transform: Matrix4.translationValues(0.0, -transformationAddButton.value, 0.0),
                      child: Container(
                        margin: const EdgeInsets.only(right: 40.00, bottom: 10.00),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: animateColor.value,
                        ),
                        child: Transform.rotate(
                          angle: iconRotation.value,
                          child: IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: _animate,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  void _animate() async {
    isOpened ? animationController.reverse() : animationController.forward();
    isOpened = !isOpened;
    FocusScope.of(context).focusedChild?.unfocus();
    _firstName.clear();
    _lastName.clear();
    _contactNumber.clear();
    _address.clear();
    isEditing = false;
  }

  void _onLongPress(Contact contact) {
    _selectedContacts.clear();
    setState(() {
      _isSelectionOpen = true;
      _selectedContacts.add(contact);
    });
  }

  Future<bool> _onWillPop() async {
    if (_isSelectionOpen) {
      setState(() {
        _isSelectionOpen = false;
        _selectedContacts.clear();
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
      controller.deleteContacts(_selectedContacts);
      setState(() {
        _isSelectionOpen = false;
      });
    }
  }

  void _onTap(Contact contact) {
    if (_isSelectionOpen) {
      if (_selectedContacts.contains(contact)) {
        setState(() {
          _selectedContacts.remove(contact);
        });
        if (_selectedContacts.length == 0) {
          setState(() {
            _isSelectionOpen = false;
          });
        }
      } else {
        setState(() {
          _selectedContacts.add(contact);
        });
      }
    }
  }
}
