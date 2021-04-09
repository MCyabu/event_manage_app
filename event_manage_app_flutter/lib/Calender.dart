import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'EventPlan.dart';

class Calender extends StatefulWidget {
  Calender({Key key, this.title}):super(key: key);

  final String title;

  @override

  _CalenderState createState() => _CalenderState();

}

class _CalenderState extends State<Calender> {
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: Container(
        child: CalendarCarousel<Event>(
          onDayPressed: (DateTime date, List<Event> events){
            Navigator.push(context,MaterialPageRoute(builder: (context) => EventPlan()));
          },
        )
      )
    );
  }
}
