import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:contacts_flutter/controllers/contact_controller.dart';
import 'package:contacts_flutter/models/address.dart';
import 'package:contacts_flutter/models/contact.dart';
import 'package:contacts_flutter/styles/text_styles.dart';
import 'package:contacts_flutter/widgets/circular_image.dart';
import 'package:contacts_flutter/widgets/image_bottom_sheet.dart';
import 'package:contacts_flutter/widgets/leading_widget.dart';
import 'package:contacts_flutter/widgets/user_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart' as launcher;

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isSelectionOpen = false;
  bool isOpened = false;

  List<Contact> _selectedContacts = [];

  ContactController controller = Get.put(ContactController());

  Uint8List? _image;

  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _contactNumber;
  late TextEditingController _address;
  late TextEditingController _email;

  bool get isSaveEnable =>
      _firstName.text.isNotEmpty && _lastName.text.isNotEmpty && _contactNumber.text.isNotEmpty && _address.text.isNotEmpty;

  late AnimationController animationController;
  late Animation<double> transformationAddButton;
  late Animation<double> transformationSheet;
  late Animation<double> iconRotation;
  late Animation<Color?> animateColor;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.blue));

    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _contactNumber = TextEditingController();
    _address = TextEditingController();
    _email = TextEditingController();

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    animationController.addListener(_listener);

    transformationAddButton = Tween<double>(begin: 0.00, end: 360.00).animate(animationController);
    transformationSheet = Tween<double>(begin: -370.00, end: 0.00).animate(animationController);
    iconRotation = Tween<double>(begin: 0.00, end: math.pi / 4).animate(animationController);
    animateColor = ColorTween(begin: Colors.blue, end: Colors.red).animate(animationController);

    _address.addListener(_listener);
    _firstName.addListener(_listener);
    _lastName.addListener(_listener);
    _email.addListener(_listener);
    _contactNumber.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _contactNumber.dispose();
    _address.dispose();
    _email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_isSelectionOpen ? "${_selectedContacts.length} Selected" : "Contacts"),
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
        body: Stack(
          children: [
            GetBuilder<ContactController>(
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
                    return ListTile(
                      leading: Container(
                        constraints: BoxConstraints.tight(Size(45.0, 45.00)),
                        decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                        child: CircularImage(
                          image: list[index].image,
                          firstName: list[index].firstName,
                          lastname: list[index].lastName,
                        ),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Visibility(
                              visible: !_isSelectionOpen,
                              child: InkWell(
                                child: Container(
                                    padding: const EdgeInsets.all(6.00),
                                    decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle),
                                    child: Icon(Icons.call, color: Color(0xFFFFFFFF), size: 18.00)),
                                onTap: () async {
                                  await launcher.launch("tel://${list[index].contactNumber}");
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Visibility(
                              visible: !_isSelectionOpen,
                              child: InkWell(
                                child: Container(
                                    padding: const EdgeInsets.all(6.00),
                                    decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle),
                                    child: Icon(Icons.mail, color: Color(0xFFFFFFFF), size: 18.00)),
                                onTap: () async {
                                  await launcher.launch("mailto://${list[index].email}");
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Visibility(
                              visible: !_isSelectionOpen,
                              child: InkWell(
                                child: Container(
                                    padding: const EdgeInsets.all(6.00),
                                    decoration: BoxDecoration(color: Colors.blue.shade400, shape: BoxShape.circle),
                                    child: Icon(Icons.message_rounded, color: Color(0xFFFFFFFF), size: 18.00)),
                                onTap: () async {
                                  await launcher.launch("smsto://${list[index].contactNumber}");
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isSelectionOpen,
                            child: InkWell(
                              child: Icon(
                                _selectedContacts.contains(list[index]) ? Icons.check_box : Icons.check_box_outline_blank,
                                color: Colors.blue,
                                size: 30.00,
                              ),
                              onTap: () => _onTap(list[index]),
                            ),
                          )
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0.00),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Transform(
                      transform: Matrix4.translationValues(0.0, -transformationSheet.value, 0.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10.00, left: 10.00, right: 10.00),
                        padding: const EdgeInsets.symmetric(vertical: 20.00, horizontal: 10.00),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF7C7C7C) : Colors.green.shade100,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.00),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: UserImage(
                                    onTap: onImageTap,
                                    firstName: _firstName.text,
                                    lastName: _lastName.text,
                                    image: _image,
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _firstName,
                                        //validator: (value) => value != null && value.isNotEmpty ? null : "Enter First Name",
                                        decoration: InputDecoration(
                                          labelText: "First Name",
                                          alignLabelWithHint: true,
                                          border: OutlineInputBorder(),
                                          isCollapsed: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.00, vertical: 10.00),
                                        ),
                                        textCapitalization: TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      SizedBox(height: 15.00),
                                      TextField(
                                        controller: _lastName,
                                        //validator: (value) => value != null && value.isNotEmpty ? null : "Enter Last Name",
                                        decoration: InputDecoration(
                                          labelText: "Last Name",
                                          alignLabelWithHint: true,
                                          border: OutlineInputBorder(),
                                          isCollapsed: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.00, vertical: 10.00),
                                        ),
                                        textCapitalization: TextCapitalization.sentences,
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.00),
                            TextField(
                              controller: _contactNumber,
                              //validator: (value) => value != null && value.isNotEmpty ? null : "Enter Contact Number",
                              decoration: InputDecoration(
                                labelText: "Contact Number",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                                isCollapsed: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10.00, vertical: 10.00),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 15.00),
                            TextField(
                              controller: _address,
                              //validator: (value) => value != null && value.isNotEmpty ? null : "Enter Address",
                              decoration: InputDecoration(
                                labelText: "Address",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                                isCollapsed: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10.00, vertical: 10.00),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 15.00),
                            TextField(
                              controller: _email,
                              //validator: (value) => value != null && value.isNotEmpty ? null : "Enter Address",
                              decoration: InputDecoration(
                                labelText: "Email",
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                                isCollapsed: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10.00, vertical: 10.00),
                              ),
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
                                            controller.contacts.length.toString(),
                                            _firstName.text,
                                            _lastName.text,
                                            _contactNumber.text,
                                            address,
                                            _image,
                                            _email.text,
                                          );
                                          controller.addContact(contact);
                                          _animate();
                                          FocusScope.of(context).focusedChild?.unfocus();
                                          _firstName.clear();
                                          _lastName.clear();
                                          _contactNumber.clear();
                                          _address.clear();
                                          _email.clear();
                                          _image = null;
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

  void _listener() {
    setState(() {});
  }

  void onImageTap() async {
    final imageSource = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return ImageBottomSheet(
            title: "Photo",
            cameraTitle: "Take Photo",
            galleryTitle: "Photo From gallery",
          );
        },
        backgroundColor: Colors.transparent);
    if (imageSource != null) {
      final XFile? image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        final File? cropped = await ImageCropper.cropImage(sourcePath: image.path);
        if (cropped != null) {
          _image = cropped.readAsBytesSync();
          setState(() {});
        }
      }
    }
  }
}
