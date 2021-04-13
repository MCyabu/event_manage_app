import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:webview_flutter/webview_flutter.dart'; //webView用ライブラリ。URL画像を表示する。

import 'dart:io'; //webViewをAndroidで使うために必要


class EventPlan extends StatefulWidget {  
  EventPlan({Key key,this.dataList}):super(key: key);

  final List<EventList> dataList; //遷移元から渡される値
  @override

  _EventPlanState createState() => _EventPlanState();
}

// EventListクラス
class EventList{
  String eventTitle;  //タイトル
  String eventValue;  //URLまたはメモ
  EventList(this.eventTitle, this.eventValue); //this.フィールド名で、値を代入できる。thisを省略すると、別の仮引数としてアクセスできてしまう
}

class _EventPlanState extends State<EventPlan> {

  final TextEditingController _inputTitleController = new TextEditingController(); //リストタイトル。表示でも使う
  final TextEditingController _inputUrlController = new TextEditingController(); //リストのURLまたはメモ。表示でも使う

  List<EventList> allEventList ; //EventListインスタンスを入れる配列。表示でも使う。

  @override
  void initState() {
   super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();  
    allEventList = widget.dataList; //Calenderから渡されたdataListをもとに、eventインスタンスを初期化する
  }

  //モーダル表示（タイトルと、URLまたはメモの情報を取得する）
  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, 
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
               if (!mounted) { 
                  return;
                }
                  String _url = _inputUrlController.text;  //URLまたはメモを入れる
                  EventList event = new EventList(_inputTitleController.text,_url);  //情報をもとに新しいインスタンスを作成する
                  allEventList.add(event);  //インスタンスをaddしていく
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
              return 
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(allEventList[index].eventTitle), 
                      RaisedButton(
                        child: const Text('削除'),
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          setState((){
                            int _eventListId = index; //evetValueListのindexを取得する
                            allEventList.removeAt(_eventListId); //リストからインスタンスを削除する
                          });
                        },
                      ),
                      (RegExp(r'https?://[a-zA-Z0-9\-%_/=&?.]+').hasMatch(allEventList[index].eventValue)) ? //urlの中身がURL表記の場合
                        Container(
                          width: MediaQuery.of(context).size.width * 1.0,
                          height: MediaQuery.of(context).size.height * 1.0,
                          child: WebView(
                            initialUrl: allEventList[index].eventValue,
                            javascriptMode: JavascriptMode.unrestricted,
                          ),
                        )
                      : 
                        Container(
                        child: Text(allEventList[index].eventValue),
                        ), 
                      ]
                    )
                  )
                );
              },
              childCount: allEventList.length,
            ),
          )
        ),
      ]
    );
}

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context,allEventList); 
        return Future.value(false);
       },
      child: Scaffold(
        appBar: AppBar(
          title: Text('イベント'),
        ),
      body: 
        _viewEventList(),
        floatingActionButton: FloatingActionButton(  //モーダル表示ボタン
        backgroundColor: Colors.blue,
        onPressed: _showMyDialog,  //モーダルを呼び出す、モーダルがリストを受け取る
        child: Icon(Icons.add),
        )
      )
    );
  }
}
