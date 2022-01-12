import 'package:mongo_dart/mongo_dart.dart';

class MongoDbModel {
  MongoDbModel({
    required this.id,
    required this.title,
    required this.content,
    // required this.address,
  });

  ObjectId id;
  String title;
  String content;
  //String address;
  factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        id: json["_id"],
        title: json['title'],
        content: json['content'],
        // address: json['address'],
      );
  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        // "address": address,
      };
}
