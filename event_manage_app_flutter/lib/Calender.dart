import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'EventPlan.dart';
class Calender extends StatefulWidget {  //カレンダーはmainからきている

  Calender({Key key, this.title}):super(key: key);
  final String title; //mainから渡されるタイトル

  @override

  _CalenderState createState() => _CalenderState();

}

class _CalenderState extends State<Calender> {


  Map<DateTime,List<EventList>> allDataList; //各日付と、日付に紐づけたイベントリスト。選択した日付をもとに、それぞれのイベントリストを抽出する。

  @override
  void initState() {
   super.initState();

   allDataList = {};
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Container(
        child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events)async{
            if(allDataList[date] == null){  //日付に紐づけたallDataListの中身がnullの場合、初期化する
              allDataList[date] = [];
            }
              List<EventList> result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventPlan(dataList: allDataList[date]), //選択した日付にひもづいたdataListを、EventPlanに渡す
                ),
              );
            allDataList[date] = result; //遷移先から戻ってきたとき、渡される値を入れる
          },
        )
      )
    );
  }
}
