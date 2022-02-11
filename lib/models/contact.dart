import 'dart:typed_data';

import 'package:hive/hive.dart';

import 'address.dart';
part 'contact.g.dart';

@HiveType(typeId: 101, adapterName: "ContactAdapter")
class Contact {
  @HiveField(0)
  String createdAt;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String contactNumber;
  @HiveField(4)
  Address address;
  @HiveField(5)
  String email;
  @HiveField(6)
  Uint8List? image;


  @override
  String toString() {
    return 'Contact{createdAt: $createdAt, firstName: $firstName, lastName: $lastName, contactNumber: $contactNumber, address: $address, email: $email, image: $image}';
  }

  Contact(this.createdAt, this.firstName, this.lastName, this.contactNumber, this.address, this.image, this.email);
}
