import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongodb/dbHelper/constant.dart';
import 'package:mongodb/mongodbModel.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<void> update(MongoDbModel data) async {
    var res = await userCollection.findOne({"_id": data.id});
    res['firstName'] = data.firstName;
    res['lastName'] = data.lastName;
    res['phone'] = data.phone;
    res['address'] = data.address;
    var response = await userCollection.save(res);
    inspect(response);
  }

  static Future<String> insert(MongoDbModel data) async {
    try {
      var res = await userCollection.insertOne(data.toJson());
      if (res.isSuccess) {
        return "Data Inserted";
      } else {
        return "something wrong";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
