import 'package:hive/hive.dart';

import 'address.dart';
part 'contact.g.dart';

@HiveType(typeId: 101, adapterName: "ContactAdapter")
class Contact {
  @HiveField(0)
  String id;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  String contactNumber;
  @HiveField(4)
  Address address;


  Contact(this.id, this.firstName, this.lastName, this.contactNumber, this.address);

  @override
  String toString() {
    return 'Contact{id: $id, firstName: $firstName, lastName: $lastName, contactNumber: $contactNumber, address: $address}';
  }
}
