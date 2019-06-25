import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'package:neon/load_calendar_eventss.dart';
import 'main.dart';

/*
Loads the calendar data from calender app into scrollview list
*/
List<Calendar> calendars;
List<Event> calendarEvents;
List<Event> todayCalendarEvents;
var selectedCalender = 0;
//
var calendarsSectionLength = 0; // Stores the length when fetching the calender data

/// init a calender page widget
class CalendarsPage extends StatefulWidget {
  @override
  CalendarsPageState createState() => CalendarsPageState();
}

///Init the data within the widget state
class CalendarsPageState extends State<CalendarsPage> {
  DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

  @override
  initState() {
    print('11');
    retrieveCalendars();
    print('22');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Calendars'),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new ListView.builder(
              itemCount: calendars?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return new GestureDetector(
                    onTap: () async {
                      selectedCalender = index;
                      await Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) {
                        return new TableView();
                      }));
                    },
                    child: new Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              flex: 1,
                              child: new Text(
                                calendars[index].name,
                                style: new TextStyle(fontSize: 25.0),
                              ),
                            ),
                            new Icon(calendars[index].isReadOnly
                                ? Icons.lock
                                : Icons.lock_open)
                          ],
                        )));
              },
            ),
          )
        ],
      ),
    );
  }

  Future retrieveCalendars() async {
    print('111');
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      calendars = calendarsResult?.data;
//      setState(() {
//        calendars = calendarsResult?.data;
//      });

      print('222');

      if (calendars.isNotEmpty) {
        retrieveCalendarEvents();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  ///
  Future retrieveCalendarEvents() async {
    print('33');
    for (int c = 0; c < calendars.length; c++) {
      final startDate = new DateTime.now().add(new Duration(days: 0));
      final endDate = new DateTime.now().add(new Duration(days: 1));
      var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendars[c].id,
          new RetrieveEventsParams(startDate: startDate, endDate: endDate));
      calendarEvents = calendarEventsResult?.data;
//      setState(() {
//        calendarEvents = calendarEventsResult?.data;
//        //      _isLoading = false;
//      });
      print('4444');
    }
  }
}
