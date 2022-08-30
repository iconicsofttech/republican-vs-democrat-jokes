import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:politicaljokes/utils/httprequests.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List catList;

  _HomeState() {
    importDB();
    catList = [
      {"id": 1, "name": "Category"}
    ];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Republican vs Democrat Jokes"),
      ),
      // drawer: Mydrawer(),
      body: new ListView.builder(
        itemCount: catList.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/showjoke', arguments: {
                  'id': catList[index]['id'],
                  'cat_name': catList[index]['name']
                });
              },
              leading: Icon(
                FontAwesomeIcons.laughWink,
                color: Colors.blue,
              ),
              title: Text(catList[index]['name']),
            ),
          );
        },
      ),
    );
  }

  void importDB() async {
    String dbPath = await getDbPath();
    bool is_db_exist = await databaseExists(dbPath);

    if (!is_db_exist) {
      ByteData data = await rootBundle.load("assets/sms.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
      setCatList();
    } else {
      setCatList();
    }
  }

  Future<String> getDbPath() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "sms.db");
    return dbPath;
  }

  Future<bool> databaseExists(String dbPath) async {
    return databaseFactory.databaseExists(dbPath);
  }

  void setCatList() async {
    catList = await getCatList();
    httprequests().fetchData();
    setState(() {});
  }

  Future<List> getCatList() async {
    String dbPath = await getDbPath();
    var db = await openDatabase(dbPath);
    List list = await db.rawQuery('SELECT * FROM categories');
    return list;
  }
}
