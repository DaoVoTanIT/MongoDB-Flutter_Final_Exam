import 'package:flutter/material.dart';
import 'package:mongodb/dbHelper/mongodb.dart';
import 'package:mongodb/insert.dart';
import 'package:mongodb/mongodbModel.dart';

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  _DisplayDataState createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MongoDB Example'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MongoDBInsert()));
              },
              icon: Icon(
                Icons.add,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MongoDBInsert()));
              },
              icon: Icon(
                Icons.edit,
                size: 30,
              ))
        ],
      ),
      body: SafeArea(
          child: FutureBuilder(
              future: MongoDatabase.getData(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasData) {
                    var totalData = snapshot.data.length;
                    print("Total Data" + totalData.toString());
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return displayCard(
                              MongoDbModel.fromJson(snapshot.data[index]));
                        });
                  } else {
                    return Center(
                      child: Text("No Data"),
                    );
                  }
                }
              })),
    );
  }

  Widget displayCard(MongoDbModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text("${data.id}"),
                Row(
                  children: [
                    Text(
                      "Name: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(data.firstName + " " + data.lastName,
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Phone: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.phone,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Address: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.address,
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MongoDBInsert(),
                              settings: RouteSettings(arguments: data)))
                      .then((value) => {setState(() {})});
                },
                icon: Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MongoDBInsert(),
                              settings: RouteSettings(arguments: data)))
                      .then((value) => {setState(() {})});
                },
                icon: Icon(Icons.highlight_remove, color: Colors.red))
          ],
        ),
      ),
    );
  }
}
