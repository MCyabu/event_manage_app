import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EventPlan extends StatefulWidget {
  EventPlan({Key key, this.title}):super(key: key);

  final String title;

  @override

  _EventPlanState createState() => _EventPlanState();
}

class _EventPlanState extends State<EventPlan> {

  final _inputTextController = TextEditingController();
  // final String _inputText = '';

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
                _inputTextController.text; //入力値を受け取る
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
        child: Text(_inputTextController.text) //入力値を表示する
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




