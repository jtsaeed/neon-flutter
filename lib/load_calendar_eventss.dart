//import 'dart:async';
//import 'package:device_calendar/device_calendar.dart';
//import 'package:flutter/material.dart';
//import 'event_item.dart';
//import 'load_calender.dart';
//
////List<Event> calendarEvents;
//var selectedCalender = 0;
//var finishedCalendar = false;
//
//class CalendarEventsPage extends StatefulWidget {
////  final Calendar _calendar;
////  CalendarEventsPage(this._calendar);
//
//  @override
//  CalendarEventsPageState createState() => CalendarEventsPageState();
//
//}
//
//class CalendarEventsPageState extends State<CalendarEventsPage> {
////  final Calendar _calendar;
//  BuildContext _scaffoldContext;
//  bool _isLoading = true;
//  DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
//
//
//  @override
//  initState() {
//    super.initState();
//    print('33');
//    retrieveCalendarEvents();
//    print('44');
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final hasAnyEvents = calendarEvents?.isNotEmpty ?? false;
//    Widget body = hasAnyEvents
//        ? new Stack( /// IF we have DO have event
//      children: <Widget>[
//        new Column(
//          children: <Widget>[
//            new Expanded(
//              flex: 1,
//              child: new ListView.builder(
//                itemCount: calendarEvents?.length ?? 0,
//                itemBuilder: (BuildContext context, int index) {
//                  return new EventItem(
//                       calendarEvents[index],
//                      _deviceCalendarPlugin,
//                      _onLoading,
//                      _onDeletedFinished,
//                      _onTapped);
//                },
//              ),
//            )
//          ],
//        ),
//        new Offstage(
//            offstage: !_isLoading,
//            child: new Container(
//                decoration: new BoxDecoration(color: Colors.red),
//                child:
//                new Center(child: new CircularProgressIndicator())))
//      ],
//    )
//
//    /// ELSE NO EVENT
//        : new Center(child: new Text('No events found'));
//    return new Scaffold(
//      appBar: new AppBar(title: new Text('temp events')),
//      body: new Builder(builder: (BuildContext context) {
//        _scaffoldContext = context;
//        return body;
//      }),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: () async {
//          final refreshEvents = await Navigator.push(context,
//              new MaterialPageRoute(builder: (BuildContext context) {
//                return new CalendarEventsPage();
//              }));
//          if (refreshEvents) {
//            retrieveCalendarEvents();
//          }
//        },
//        child: new Icon(Icons.add),
//      ),
//    );
//  }
//
//  ///
//  void _onLoading() {
//    setState(() {
//      _isLoading = true;
//    });
//  }
//
//  ///
//  Future _onDeletedFinished(bool deleteSucceeded) async {
//    if (deleteSucceeded) {
//      await retrieveCalendarEvents();
//    } else {
//      Scaffold.of(_scaffoldContext).showSnackBar(new SnackBar(
//        content: new Text('Oops, we ran into an issue deleting the event'),
//        backgroundColor: Colors.red,
//        duration: new Duration(seconds: 5),
//      ));
//      setState(() {
//        _isLoading = false;
//      });
//    }
//  }
//
//  ///
//  Future _onTapped(Event event) async {
//    final refreshEvents = await Navigator.push(context,
//        new MaterialPageRoute(builder: (BuildContext context) {
//          return new CalendarEventsPage();
//        }));
//    if (refreshEvents != null && refreshEvents) {
//      retrieveCalendarEvents();
//    }
//  }
//
//  ///
//  Future retrieveCalendarEvents() async {
//    print('333');
//    CalendarEventsPageState();
//    final startDate = new DateTime.now().add(new Duration(days: -30));
//    final endDate = new DateTime.now().add(new Duration(days: 30));
//    var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
//        calendars[selectedCalender].id,
//        new RetrieveEventsParams(startDate: startDate, endDate: endDate));
//    calendarEvents = calendarEventsResult?.data;
//      setState(() {
//        calendarEvents = calendarEventsResult?.data;
//        _isLoading = false;
//      });
//    print('4444');
//
//  finishedCalendar = true;
//  }
//}
