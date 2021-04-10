import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// import 'package:url_launcher/url_launcher.dart';  //URL起動

import 'package:webview_flutter/webview_flutter.dart'; //iframe

import 'dart:io'; //iframe Android


class EventPlan extends StatefulWidget {
  EventPlan({Key key, this.title}):super(key: key);

  final String title;

  @override

  _EventPlanState createState() => _EventPlanState();
}

class _EventPlanState extends State<EventPlan> {

  final _inputTitleController = TextEditingController();
  final _inputUrlController = TextEditingController();
  // WebViewController _controller;

  String _url; //確認用URL

  RegExp matches;

  bool result;

  // final flutterWebviewPlugin = new FlutterWebviewPlugin();


  void initState() {
    _url = '';
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }


  //モーダル表示
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
                controller: _inputUrlController, //URLやメモの入力欄
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
                  result = new RegExp(r'https?://[a-zA-Z0-9\-%_/=&?.]+').hasMatch(_inputUrlController.text); //入力値がURLになっているか確認する
                  print(_url);
                  if(result == true){
                    _url = _inputUrlController.text;
                     print(_url);
                  }
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

// URL先のリンクとタイトルのリスト
List<Widget> _eventList(int size, int sliverChildCount) {
    final widgetList = new List<Widget>();
    for (int index = 0; index < size; index++)
      widgetList
        ..add(SliverAppBar(
           title: Text(_inputTitleController.text),
           pinned: true,
         ))
        ..add(SliverFixedExtentList(
          itemExtent: 200.0,
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) { //contextが中身、indexがひとまとまりの数
                return 
                ( _url != '') ?
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: WebView(
                      initialUrl: _url,
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
                  )
                : 
                  Container(
                  child: Text(_inputUrlController.text),
                  );  
              }, childCount: sliverChildCount),
        ));
   return widgetList;
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('イベント')
      ),
      body: 
      CustomScrollView(
          slivers: _eventList(1,1),
      ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showMyDialog,
        child: Icon(Icons.add),
      )
    );
  }
}
