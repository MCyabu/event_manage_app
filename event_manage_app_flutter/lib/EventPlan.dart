import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:url_launcher/url_launcher.dart';  //URL起動


class EventPlan extends StatefulWidget {
  EventPlan({Key key, this.title}):super(key: key);

  final String title;

  @override

  _EventPlanState createState() => _EventPlanState();
}

class _EventPlanState extends State<EventPlan> {

  final _inputTextController = TextEditingController();

  String _url; //確認用URL

  RegExp matches;

  bool result;

  void initState() {
    _url = '';
  }

  //ボタンを押したら、URL起動
  void _launchURL() async =>{
    await launch(_url) 
  };

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
                controller: _inputTextController,
                decoration: InputDecoration(
                  hintText: "イベント名",
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
                  result = new RegExp(r'https?://[a-zA-Z0-9\-%_/=&?.]+').hasMatch(_inputTextController.text); //入力値がURLになっているか確認する
                  if(result == true){
                    _url = _inputTextController.text; //URLの場合、_urlに入れる
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('イベント')
      ),
      body: Container(
        child: Column(
          children: [
            (_url == '') 
            ?
            Text(_inputTextController.text) //URLでない場合
            : 
            GestureDetector(
              onTap: _launchURL, //URLの場合
              child:Text(_url)
            )
          ],)
      ),
      // テキスト入力画面をモーダルで出すボタン
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showMyDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}




