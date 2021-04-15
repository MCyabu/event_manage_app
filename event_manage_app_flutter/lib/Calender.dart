import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'EventPlan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; //JSON変換用

class Calender extends StatefulWidget {
  Calender({Key key, this.title}) : super(key: key);
  final String title; //mainから渡されるタイトル

  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  //各日付と、日付に紐づけたイベントリスト。選択した日付をもとに、それぞれのイベントリストを抽出する。

  Map<DateTime, List<EventList>> allDataList; //データ保存、データ読み込み、表示に使用する。

  @override
  void initState() {
    super.initState();
    allDataList = {};
    //起動時、データを読み込む
    _readData();
  }

  //データ保存
  void _saveData() async {
    //prefsには保存するデータを入れる
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // allDateListのkeyをもとに、valueを入れる
    for (DateTime key in allDataList.keys) {
      // String saveEventListJson = jsonEncode(allDataList[key]); //Jsonにエンコード
      await prefs.setString(
          key.toString(), jsonEncode(allDataList[key])); //key,valueのセットにして、保存する
    }
  }

  //データ読み込み
  void _readData() async {
    // prefsには、読み込むデータを入れる
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.getKeysで、全てのkeyを取得する
    // keyを1つ取得し、valueを取得する

    for (String key in prefs.getKeys()) {
      //valueに何も入っていない場合、処理を実行しない
      //Jsonからデコード //[{eventTitle: aaa,eventValue:bbb}]
      //jsonDecode(prefs.getString(key));から取り出す時、続けて書くと読みづらいと思って、変数に入れた
      List<dynamic> readEventListJson = jsonDecode(prefs.getString(key));
      //allEventListに入れる、List<EventList>を作る
      List<EventList> eventList = [];
      for (int count = 0; count < readEventListJson.length; count++) {
        // List<EventList>にいれるEventListインスタンスを作成する
        EventList loadEventList = new EventList(
            readEventListJson[count]["eventTitle"],
            readEventListJson[count]["eventValue"]);
        eventList.add(loadEventList);
      }
      // keyを指定し、eventListを代入して、allEventListを作る
      allDataList[DateTime.parse(key)] = eventList;
      print(allDataList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // mainから渡されたtitle
        appBar: AppBar(title: Text(widget.title)),
        body: Container(child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events) async {
            if (allDataList[date] == null) {
              //allDataListの中身がnullの場合、初期化する
              allDataList[date] = [];
            }
            // 遷移先から戻ってきたとき、List<EventList>を受け取ってresultに入れる
            List<EventList> result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPlan(
                    dataList: allDataList[date]), //dataListを、EventPlanに渡す
              ),
            );
            //遷移先から戻ってきたとき、渡される値を入れる
            allDataList[date] = result;
            //遷移先から戻ってきたとき、データを保存する
            _saveData();
          },
        )));
  }
}
