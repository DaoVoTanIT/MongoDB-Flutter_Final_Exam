import 'dart:ui';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:mongodb/dbHelper/mongodb.dart';
import 'package:mongodb/data/mongodbModel.dart';

class MongoDBInsert extends StatefulWidget {
  const MongoDBInsert({Key? key}) : super(key: key);

  @override
  _MongoDBInsertState createState() => _MongoDBInsertState();
}

class _MongoDBInsertState extends State<MongoDBInsert> {
  var titleController = TextEditingController();
  var contentController = TextEditingController();
  var addressController = TextEditingController();
  var _checkInserUpdate = "Insert";
  @override
  Widget build(BuildContext context) {
    MongoDbModel data =
        ModalRoute.of(context)?.settings.arguments as MongoDbModel;
    if (data != null) {
      titleController.text = data.title;
      contentController.text = data.content;
      //addressController.text = data.address;
      _checkInserUpdate = "Update";
    }
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            ClipRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: 80,
                    color: Theme.of(context).canvasColor.withOpacity(0.3),
                    child: SafeArea(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () {
                              _clearAll();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Text(DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now()))
            //   ],
            // ),
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Note Title"),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.multiline,
                textAlign: TextAlign.justify,
                maxLines: null,
                controller: contentController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "Your Note"),
              ),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_checkInserUpdate == "Update") {
              _updateData(data.id, titleController.text, contentController.text,
                  addressController.text);
            } else {
              _insertData(titleController.text.toUpperCase(),
                  contentController.text, addressController.text);
            }
          },
          icon: Icon(Icons.save_alt),
          label: Text(_checkInserUpdate)),
    );
  }

  Future<void> _updateData(
      var id, String title, String content, String address) async {
    final updateData = MongoDbModel(
      id: id,
      title: title,
      content: content,
      //address: address,
    );
    await MongoDatabase.update(updateData)
        .whenComplete(() => Navigator.pop(context));
  }

  Future<void> _insertData(String title, String content, String address) async {
    var _id = M.ObjectId();
    // String isoDate = now.toIso8601String();
    final data = MongoDbModel(
      id: _id,
      title: title,
      content: content,
      // address: address,
    );
    await MongoDatabase.insert(data);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Inserte ID" + _id.$oid)));
  }

  void _clearAll() {
    titleController.text = "";
    contentController.text = "";
    addressController.text = "";
  }

  void _fakeData() {
    setState(() {
      titleController.text = faker.person.firstName();
      contentController.text = faker.person.lastName();
      addressController.text =
          faker.address.streetName() + "\n" + faker.address.streetAddress();
    });
  }
}
