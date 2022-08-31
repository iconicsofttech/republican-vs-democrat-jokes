import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class httprequests{


  void fetchData() async{

    var catId = "1";
    var jokeId = "1";

    String dbPath = await getDbPath();
    var db = await openDatabase(dbPath);

    List list = await db
        .rawQuery('select id from jokes ORDER by id desc LIMIT 1;');
    jokeId = list[0]["id"].toString();

    List list2 = await db
        .rawQuery('select id from categories ORDER by id desc LIMIT 1;');

    catId = list2[0]["id"].toString();

    var url = 'https://iconicsoft.net/politicaljokesdata?cat_id='+catId+'&joke_id='+jokeId+'&base=YXBpS2VZRnJvbUZsdXR0ZXJAMTIz';
    var resp =  await http.get(Uri.parse(url));
    var data = jsonDecode(resp.body);

    if (data["jokes"].length > 0) {

      Map<String, dynamic> smsData = {};
      for (var v in data["jokes"]) {
        smsData["id"] = v["id"];
        smsData["cat_id"] = v["cat_id"];
        smsData["joke"] = v["joke"];
        db.insert("jokes", smsData);
      }
    }

    if (data["categories"].length > 0) {

      Map<String, dynamic> catData = {};
      for (var j in data["categories"]) {
        catData["id"] = j["id"];
        catData["name"] = j["name"];
        db.insert("categories", catData);
      }

    }

  }

  Future<String> getDbPath() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "sms.db");
    return dbPath;
  }

}