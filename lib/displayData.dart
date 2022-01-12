import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mongodb/dbHelper/mongodb.dart';
import 'package:mongodb/insert.dart';
import 'package:mongodb/data/mongodbModel.dart';
import 'package:mongodb/search_widget.dart';
import 'header_widget.dart';

class DisplayData extends StatefulWidget {
  const DisplayData({Key? key}) : super(key: key);

  @override
  _DisplayDataState createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  TextEditingController controller = TextEditingController();
  bool descTextShowFlag = false;
  final scrollController = ScrollController();
  late MongoDbModel model;
  List<MongoDbModel> _posts = <MongoDbModel>[];
  List<MongoDbModel> _listDisplay = <MongoDbModel>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MongoDBInsert()));
        },
        label: Text('Add note'.toUpperCase()),
        icon: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: MongoDatabase.getData(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Text('Loading'),
              );
            default:
              return !snapshot.hasData
                  ? Center(
                      child: Text("Empty"),
                    )
                  : SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          HeaderWidget(
                            image: "assets/memo.png",
                            textTop: "App note",
                            textBottom: "& Writing",
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return displayCard(MongoDbModel.fromJson(
                                    snapshot.data[index]));
                                // return index == 0
                                //     ? buildSearch()
                                //     : displayCard(MongoDbModel.fromJson(
                                //         snapshot.data[index]));
                              }),
                        ],
                      ),
                    );
          }
        },
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        hintText: 'Search',
        text: '100',
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            print(text);
            _listDisplay = _listDisplay.where((post) {
              var title = post.title.toLowerCase();
              print(title);
              return title.contains(text);
            }).toList();
          });
        },
      );
  Widget displayCard(MongoDbModel data) {
    return SizedBox(
      width: 30,
      height: 150,
      child: InkWell(
        onTap: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MongoDBInsert(),
                      settings: RouteSettings(arguments: data)))
              .then((value) => {setState(() {})});
        },
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text("${data.id}"),
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(data.content,
                        maxLines: descTextShowFlag ? 5 : 3,
                        overflow: TextOverflow.visible,
                        textWidthBasis: TextWidthBasis.parent,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    PopupMenuButton(itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                            child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text('Note App'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: const <Widget>[
                                            Text(
                                                'Do you want to delete this note?'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            child: const Text('Xoá'),
                                            onPressed: () async {
                                              print(data.id);
                                              await MongoDatabase.delete(data);
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            })
                                      ]);
                                });
                          },
                          child: Text('Delete'),
                        )),
                        PopupMenuItem(
                            child: TextButton(
                          onPressed: () async {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MongoDBInsert(),
                                        settings:
                                            RouteSettings(arguments: data)))
                                .then((value) => {setState(() {})});
                          },
                          child: Text('Edit'),
                        )),
                      ];
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
