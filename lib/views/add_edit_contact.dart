import 'package:contacts_flutter/constants/constants.dart';
import 'package:contacts_flutter/widgets/image_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:contacts_flutter/controllers/contact_controller.dart';
import 'package:contacts_flutter/models/address.dart';
import 'package:contacts_flutter/models/contact.dart';
import 'package:contacts_flutter/widgets/user_image.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEditContact extends StatefulWidget {
  static MaterialPage page({Contact? contact}) {
    return MaterialPage(name: rpAddEditContact, key: ValueKey(rpAddEditContact), child: AddEditContact(contact: contact));
  }

  final Contact? contact;
  const AddEditContact({Key? key, required this.contact}) : super(key: key);

  @override
  State<AddEditContact> createState() => _AddEditContactState();
}

class _AddEditContactState extends State<AddEditContact> {
  ContactController controller = Get.find();

  Uint8List? _image;

  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _contactNumber;
  late TextEditingController _address;
  late TextEditingController _email;

  bool get isSaveEnable =>
      _firstName.text.isNotEmpty &&
          _lastName.text.isNotEmpty &&
          _contactNumber.text.isNotEmpty &&
          _address.text.isNotEmpty && _email.text.isNotEmpty;

  final TextStyle labelStyle = TextStyle(color: Colors.green);
  final Color cursorColor = Colors.green;
  final Color filledColor = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();

    _firstName = TextEditingController(text: widget.contact?.firstName);
    _lastName = TextEditingController(text: widget.contact?.lastName);
    _contactNumber = TextEditingController(text: widget.contact?.contactNumber);
    _address = TextEditingController(text: widget.contact?.address.name);
    _email = TextEditingController(text: widget.contact?.email);

    _image = widget.contact?.image;

    _address.addListener(_listener);
    _firstName.addListener(_listener);
    _lastName.addListener(_listener);
    _email.addListener(_listener);
    _contactNumber.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _contactNumber.dispose();
    _address.dispose();
    _email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? "Add Contact" : "Edit Contact"),
        backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.00, horizontal: 10.00),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF7C7C7C) : Colors.white70,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.00),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: kTextTabBarHeight),
              UserImage(
                onTap: onImageTap,
                firstName: _firstName.text,
                lastName: _lastName.text,
                image: _image,
              ),
              SizedBox(height: 15.00),
              TextField(
                controller: _firstName,
                decoration: InputDecoration(
                  labelText: "First Name",
                  alignLabelWithHint: false,
                  labelStyle: labelStyle,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: cursorColor, width: 2.00)),
                  filled: true,
                  fillColor: filledColor,
                ),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15.00),
              TextField(
                controller: _lastName,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  alignLabelWithHint: false,
                  labelStyle: labelStyle,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: cursorColor, width: 2.00)),
                  filled: true,
                  fillColor: filledColor,
                ),
                cursorColor: cursorColor,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15.00),
              TextField(
                controller: _contactNumber,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  alignLabelWithHint: false,
                  labelStyle: labelStyle,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: cursorColor, width: 2.00)),
                  filled: true,
                  fillColor: filledColor,
                ),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15.00),
              TextField(
                controller: _address,
                decoration: InputDecoration(
                  labelText: "Address",
                  alignLabelWithHint: false,
                  labelStyle: labelStyle,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: cursorColor, width: 2.00)),
                  filled: true,
                  fillColor: filledColor,
                ),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 15.00),
              TextField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: "Email",
                  alignLabelWithHint: false,
                  labelStyle: labelStyle,
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: cursorColor, width: 2.00)),
                  filled: true,
                  fillColor: filledColor,
                ),
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10.00),
              SafeArea(
                child: Container(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: ElevatedButton(
                    onPressed: isSaveEnable
                        ? () {
                            Address address = Address();
                            address.name = _address.text;
                            Contact contact = Contact(
                              widget.contact == null ? DateTime.now().toIso8601String() : widget.contact!.createdAt,
                              _firstName.text,
                              _lastName.text,
                              _contactNumber.text,
                              address,
                              _image,
                              _email.text,
                            );
                            controller.addContact(contact);
                            Get.back();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10.00),
                      primary: cursorColor,
                    ),
                    child: Text(widget.contact == null ? "Create" : "Update", style: TextStyle(fontSize: 20.00),),
                  ),
                ),
              ),
              SizedBox(height: kTextTabBarHeight),
            ],
          ),
        ),
      ),
    );
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
      bool isPermission = await Permission.camera.isGranted;
      if (!isPermission) {
        final status = await Permission.camera.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          return;
        }
      }
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
