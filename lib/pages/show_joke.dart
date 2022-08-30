import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:nonvegjokes/utils/globals.dart' as globals;

class Showjoke extends StatefulWidget {
  @override
  _ShowjokeState createState() => _ShowjokeState();
}

class _ShowjokeState extends State<Showjoke> {
  Map data = {};
  List jokes = ["Joke"];
  int current_joke = 0;
  InterstitialAd _interstitialAd;
  RewardedAd _rewardedAd;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _ShowjokeState() {
    setJokes();
  }

  @override
  void initState() {
    super.initState();
    loadinterad();
    loadVideoRewardedAD();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadinterad() {
    InterstitialAd.load(
        // adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        adUnitId: 'ca-app-pub-8153966545731488/3905529760',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  void loadVideoRewardedAD() {
    RewardedAd.load(
        // adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        adUnitId: 'ca-app-pub-8153966545731488/1264545246',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            this._rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    // jokes = httprequests().getjokes(int.parse(data['id']));
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(data['cat_name']),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                // margin: const EdgeInsets.all(35.0),
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '${current_joke + 1} of ${jokes.length}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Container(
                constraints: BoxConstraints.expand(),
                width: 600,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: SingleChildScrollView(
                  child: Text(
                    jokes[current_joke],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () => nextprev(1),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        margin: const EdgeInsets.fromLTRB(50, 20, 0, 0),
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 70,
                          color: Colors.blue,
                        )),
                  ),
                  InkWell(
                    onTap: () => nextprev(2),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        margin: const EdgeInsets.fromLTRB(0, 20, 50, 0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 70,
                          color: Colors.blue,
                        )),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: InkWell(
                        onTap: () {
                          Clipboard.setData(new ClipboardData(
                              text: jokes[current_joke] +
                                  " https://play.google.com/store/apps/details?id=com.ivalitsoft.nonvegjokes"));
                          _displaySnackBar(context);
                        },
                        child: Icon(
                          FontAwesomeIcons.copy,
                          size: 50,
                          color: Colors.blue,
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: InkWell(
                        onTap: () async => await shareText(),
                        child: Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.blue,
                          size: 50,
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: InkWell(
                        onTap: () async => await shareText(),
                        child: Icon(
                          FontAwesomeIcons.share,
                          color: Colors.blue,
                          size: 50,
                        ),
                      )),
                ],
              ),
            ),
            // Flexible(
            //   flex: 1,
            //   child: Container(
            //
            //   ),
            // )
          ],
        ));
  }

  void nextprev(int action) {
    // action 1 = prev, 2 = next
    if (action == 1) {
      if (current_joke != 0) {
        current_joke--;
        globals.adClickCount++;
        globals.videosAdClickCount++;
        showInter();
        showVideoAd();
        setState(() {});
      }
    } else {
      if (current_joke != (jokes.length - 1)) {
        current_joke++;
        globals.adClickCount++;
        globals.videosAdClickCount++;
        showInter();
        showVideoAd();
        setState(() {});
      }
    }
  }

  Future<void> shareText() async {
    try {
      Share.text(
          '',
          jokes[current_joke] +
              " https://play.google.com/store/apps/details?id=com.ivalitsoft.nonvegjokes",
          'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Joke Copied To Clipboard'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void setJokes() async {
    jokes = await getJokes();
    setState(() {});
  }

  Future<List> getJokes() async {
    String dbPath = await getDbPath();
    var db = await openDatabase(dbPath);
    List list = await db
        .rawQuery('SELECT SMS FROM CategorySMS where Cat_ID=${data["id"]}');

    List jokeList = [];
    list.forEach((element) {
      jokeList.add(element['SMS']);
    });

    return jokeList;
  }

  Future<String> getDbPath() async {
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "sms.db");
    return dbPath;
  }

  void showInter() {
    if (globals.adClickCount > 5) {
      //show inter ad
      if( _interstitialAd != null) {
        _interstitialAd.show();
        globals.adClickCount = 0;
      }
      loadinterad();
    }
  }

  void showVideoAd() {
    if (globals.videosAdClickCount > 20) {
      //show video ad
      if( _rewardedAd != null) {
        _rewardedAd.show();
        globals.videosAdClickCount = 0;
      }
      loadVideoRewardedAD();

    }
  }
}
