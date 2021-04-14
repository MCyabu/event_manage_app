import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'EventPlan.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'dart:convert'; //JSON変換用

class Calender extends StatefulWidget {  

  Calender({Key key, this.title}):super(key: key);
  final String title; //mainから渡されるタイトル

  @override

  _CalenderState createState() => _CalenderState();

}

class _CalenderState extends State<Calender> {

  //各日付と、日付に紐づけたイベントリスト。選択した日付をもとに、それぞれのイベントリストを抽出する。
  //データ保存、データ読み込み、表示に使用する。
  Map<DateTime,List<EventList>> allDataList; 

  @override
  void initState() {
   super.initState();

   allDataList = {};
  }

  //データ保存
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); //prefs保存するデータを入れる
    for( DateTime key in allDataList.keys){
        String eventListJson = jsonEncode(allDataList[key]);   //Jsonにエンコード
        await prefs.setString(key.toString(), eventListJson);
    }
  }

  //データ読み込み
  void _readData() async {
    for( DateTime key in allDataList.keys){ //allDataListに入っているValue（List<dynamic>）分、処理を繰り返す
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> readEventListJson = jsonDecode(prefs.getString(key.toString())); //Jsonからデコード //[{'eventTitle': 'aaa','eventValue':'bbb'}]
      for(int i = 0; i < readEventListJson.length; i++){
        //値を代入して、EventListクラスのインスタンスを作る
        EventList readEventList = new EventList(readEventListJson[i]['eventTitle'],readEventListJson[i]['eventValue']);
        // EventList sample[eventTitle] = readEventListJson[i]['eventValue'] ;
        allDataList[key].add(readEventList);
        // print('確認');
        // print(allDataList[key]);
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          //データ保存
          IconButton(
            icon: Icon(Icons.upload_rounded),
            onPressed: () => setState(() {
              _saveData(); 
            }),
          ),
          //データ読み込み
          IconButton(
            icon: Icon(Icons.download_rounded),
            onPressed: () => setState(() {
              _readData(); 
            }),
          ),
        ]
      ),
      body: Container(
        child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events)async{
            if(allDataList[date] == null){  //allDataListの中身がnullの場合、初期化する
              allDataList[date] = [];
            }
              List<EventList> result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventPlan(dataList: allDataList[date]), //dataListを、EventPlanに渡す
                ),
              );
            allDataList[date] = result; //遷移先から戻ってきたとき、渡される値を入れる
          },
        )
      )
    );
  }
}
