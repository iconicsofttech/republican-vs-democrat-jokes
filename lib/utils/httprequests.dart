import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class httprequests{


  void fetchData() async{

    var catId = "3";
    var jokeId = "585";

    String dbPath = await getDbPath();
    var db = await openDatabase(dbPath);

    List list = await db
        .rawQuery('select _id from CategorySMS ORDER by _id desc LIMIT 1;');
    jokeId = list[0]["_id"].toString();

    List list2 = await db
        .rawQuery('select _id from Categories ORDER by _id desc LIMIT 1;');

    catId = list2[0]["_id"].toString();

    var url = 'https://iconicsoft.net/nonvegdata?cat_id='+catId+'&joke_id='+jokeId+'&base=YXBpS2VZRnJvbUZsdXR0ZXJAMTIz';
    var resp =  await http.get(Uri.parse(url));
    var data = jsonDecode(resp.body);

    if (data["sms"].length > 0) {

      Map<String, dynamic> smsData = {};
      for (var v in data["sms"]) {
        smsData["_id"] = v["_id"];
        smsData["Cat_Id"] = v["Cat_Id"];
        smsData["SMS"] = v["SMS"];
        db.insert("CategorySMS", smsData);
      }
    }

    if (data["categories"].length > 0) {

      Map<String, dynamic> catData = {};
      for (var j in data["sms"]) {
        catData["_id"] = j["_id"];
        catData["Cat_Id"] = j["Cat_Id"];
        catData["Categories"] = j["Categories"];
        db.insert("Categories", catData);
      }

    }

  }

  Future<String> getDbPath() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "sms.db");
    return dbPath;
  }

}