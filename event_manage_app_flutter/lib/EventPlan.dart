import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:webview_flutter/webview_flutter.dart'; //iframe

import 'dart:io'; //iframe Android


class EventPlan extends StatefulWidget {
  EventPlan({Key key, this.title}):super(key: key);

  final String title;

  @override

  _EventPlanState createState() => _EventPlanState();
}

class _EventPlanState extends State<EventPlan> {

  final _inputTitleController = TextEditingController(); //リストタイトルの入力値を受け取る
  final _inputUrlController = TextEditingController(); //リストのURLまたはメモの入力値を受け取る

  String _url; //リストのURLまたはメモの入力値が、URLだった場合に、入れる

  // final eventList = new List<Widget>();  //１つ１つのイベント情報（タイトル+URLまたはメモ）が入った配列
  List<String> eventTitleList;  //イベント情報のうち、タイトルが入った配列
  List<String> eventValueList;  //イベント情報のうち、URLまたはメモが入った配列

  @override
  void initState() {
   super.initState();
    _url = '';
    eventTitleList = [];
    eventValueList = [];
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();  
  }

  //モーダル表示（タイトルと、URLまたはメモの情報を取得する）
  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('入力欄'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: _inputTitleController, //タイトルの入力欄
                decoration: InputDecoration(
                  hintText: "イベント名",
                ),
              ),
              TextField(
                controller: _inputUrlController, //URLまたはメモの入力欄
                decoration: InputDecoration(
                  hintText: "URLまたはメモ",
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[ 
          TextButton(
            child: Text('OK'),
            onPressed: () {
              setState(() {
               if (!mounted) {  //解決したけど理由がわからない
                  return;
                }
                  // bool result = new RegExp(r'https?://[a-zA-Z0-9\-%_/=&?.]+').hasMatch(_inputUrlController.text); //入力値がURLか確認する
                  // if(result == true){  //URLだった場合
                  _url = _inputUrlController.text; 
                  // }
                  eventTitleList.add(_inputTitleController.text);  //タイトルを追加
                  eventValueList.add(_url);  //URLまたはメモを追加
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('キャンセル'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// リストの表示
Widget _viewEventList() { //titleはタイトル、textはURL（中身あり、または空白文字）
  return
    CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverFixedExtentList(
            itemExtent: 400.0,
            delegate:  //実際のグリッドに入るコンテンツを生成するウィジットが入る
            SliverChildBuilderDelegate(
              (BuildContext context, int index)  //childCount--->index
              {
              print(index);
              print(eventValueList);
              return 
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(eventTitleList[index]),
                      RaisedButton(
                        child: const Text('削除'),
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          setState((){
                            int _eventValueId = index; //evetValueListのindexを取得する
                            eventValueList.removeAt(_eventValueId); //リストから削除する
                            eventTitleList.removeAt(_eventValueId); //リストから削除する
                          });
                        },
                      ),
                        (RegExp(r'https?://[a-zA-Z0-9\-%_/=&?.]+').hasMatch(eventValueList[index])) ? //urlの中身がURL表記の場合
                          Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            height: MediaQuery.of(context).size.height * 1.0,
                            child: WebView(
                              initialUrl: eventValueList[index],
                              javascriptMode: JavascriptMode.unrestricted,
                            ),
                          )
                        : 
                          Container(
                          child: Text(eventValueList[index]),
                          ), 
                    ]
                  )
                )
              );
            },
              childCount: eventValueList.length,
            ),
          )
        ),
      ]
    );
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('イベント')
      ),
      body:
        _viewEventList(),
        floatingActionButton: FloatingActionButton(  //モーダル表示ボタン
        backgroundColor: Colors.blue,
        onPressed: _showMyDialog,  //モーダルを呼び出す、モーダルがリストを受け取る
        child: Icon(Icons.add),
      )
    );
  }
}
