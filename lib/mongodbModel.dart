import 'package:mongo_dart/mongo_dart.dart';

class MongoDbModel {
  MongoDbModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
  });

  ObjectId id;
  String firstName;
  String lastName;
  String phone;
  String address;
  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
      id: json["id"],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      address: json['address']);
  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "address": address
      };
}
