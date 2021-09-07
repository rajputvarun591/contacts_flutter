import 'package:hive/hive.dart';
part 'address.g.dart';
@HiveType(typeId: 102, adapterName: "AddressAdapter")
class Address{
  @HiveField(0)
  var name;

  Address();
}