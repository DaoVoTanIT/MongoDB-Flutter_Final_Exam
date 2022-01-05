import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:mongodb/dbHelper/mongodb.dart';
import 'package:mongodb/mongodbModel.dart';

class MongoDBInsert extends StatefulWidget {
  const MongoDBInsert({Key? key}) : super(key: key);

  @override
  _MongoDBInsertState createState() => _MongoDBInsertState();
}

class _MongoDBInsertState extends State<MongoDBInsert> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var addressController = TextEditingController();
  var phoneController = TextEditingController();
  var _checkInserUpdate = "Insert";
  @override
  Widget build(BuildContext context) {
    MongoDbModel data =
        ModalRoute.of(context)?.settings.arguments as MongoDbModel;
    if (data != null) {
      fnameController.text = data.firstName;
      lnameController.text = data.lastName;
      phoneController.text = data.phone;
      addressController.text = data.address;
      _checkInserUpdate = "Update";
    }
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              //"INFORMATION USER",
              _checkInserUpdate,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: fnameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "First name"),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: lnameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Last name"),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Phone number"),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Address"),
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    _fakeData();
                  },
                  child: Text('Generate Data'),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    if (_checkInserUpdate == "Update") {
                      _updateData(
                          data.id,
                          fnameController.text,
                          lnameController.text,
                          phoneController.text,
                          addressController.text);
                    } else {
                      _insertData(fnameController.text, lnameController.text,
                          phoneController.text, addressController.text);
                    }
                  },
                  child: Text(_checkInserUpdate),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  Future<void> _updateData(
      var id, String fName, String lName, String phone, String address) async {
    final updateData = MongoDbModel(
        id: id,
        firstName: fName,
        lastName: lName,
        phone: phone,
        address: address);
    await MongoDatabase.update(updateData)
        .whenComplete(() => Navigator.pop(context));
  }

  Future<void> _insertData(
      String fname, String lName, String phone, String address) async {
    var _id = M.ObjectId();
    final data = MongoDbModel(
        id: _id,
        firstName: fname,
        lastName: lName,
        phone: phone,
        address: address);
    await MongoDatabase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserte ID" + _id.$oid)));
    _clearAll();
  }

  void _clearAll() {
    fnameController.text = "";
    lnameController.text = "";
    addressController.text = "";
  }

  void _fakeData() {
    setState(() {
      fnameController.text = faker.person.firstName();
      lnameController.text = faker.person.lastName();
      phoneController.text = faker.phoneNumber.us();
      addressController.text =
          faker.address.streetName() + "\n" + faker.address.streetAddress();
    });
  }
}
