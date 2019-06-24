import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';

/*
Loads the calendar data from calender app into scrollview list
*/

var calendarsLength = 0; // Stores the length when fetching the calender data
DeviceCalendarPlugin _deviceCalendarPlugin;

class CalendarPage extends StatefulWidget {
  Function _calendarCallback;

  @override
  CalendarPageState createState() => new CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  DeviceCalendarPlugin _deviceCalendarPlugin;
  List<Calendar> _calendars;
  Calendar _selectedCalendar;

  CalendarPageState() {
    _deviceCalendarPlugin = new DeviceCalendarPlugin();
  }

  @override
  initState() {
    super.initState();
    _retrieveCalendars();
  }

  @override
  Widget build(BuildContext context) {
    //Scaffold shows a list of the users calendars that can be selected by the
    //user
    //After a calendar is selected, calendar info is sent back to main page
    //via calenderCallback function
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new ConstrainedBox(
            constraints:
            new BoxConstraints(maxHeight: calendarsLength * 60.toDouble()),
            child: new ListView.builder(
              itemCount: _calendars?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                // retrieveEvents(.id, _selectedCalendar.id.eventId);
//                _retrieveCalendarEvents(_calendars[index]);

                return new GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCalendar = _calendars[index];
                      this.widget._calendarCallback(_selectedCalendar.id,
                          _selectedCalendar.name, _deviceCalendarPlugin);
                    });
                  },
                  child: new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 1,
                          child: new Text(
                            _calendars[index].name,
                            style: new TextStyle(fontSize: 25.0),
                          ),
                        ),
                        new Icon(
                          Icons.lock_open,
                          color: Colors.amber[800],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _retrieveCalendars() async {
    //Retrieve user's calendars from mobile device
    //Request permissions first if they haven't been granted
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();

      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();

        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult?.data;
        calendarsLength = calendarsResult.data.length;
      });
    } catch (e) {
      print(e);
    }

    for (int i = 0; i < calendarsLength; i++) {
      print('---');
      print(_calendars[i].id);
      final startDate = new DateTime.now().add(new Duration(days: -30));
      final endDate = new DateTime.now().add(new Duration(days: 30));
      var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          _calendars[i].id,
          new RetrieveEventsParams(startDate: startDate, endDate: endDate));
      print(calendarEventsResult);
      print(calendarEventsResult.data);
      print(calendarEventsResult.isSuccess);
      print(calendarEventsResult.errorMessages);
    }
  }

  /// [Retrieves the events from the specified calendar]
  ///
  /// The `calendarId` paramter is the id of the calendar that plugin will return events for
  /// The `retrieveEventsParams` parameter combines multiple properties that
  /// specifies conditions of the events retrieval. For instance, defining [RetrieveEventsParams.startDate]
  /// and [RetrieveEventsParams.endDate] will return events only happening in that time range
  ///
  /// Returns a [Result] containing a list [Event], that fall
  /// into the specified parameters
  Future<Result<List<Event>>> retrieveEvents(
      String calendarId, RetrieveEventsParams retrieveEventsParams) async {
    final res = new Result<List<Event>>();

    print('----');
    print(res);

    if ((calendarId?.isEmpty ?? true)) {
      // print(res.errorMessages.ErrorCodes.invalidArguments);
      // print(res.errorMessages.ErrorCodes.invalidMissingCalendarId);

      // res.errorMessages.add("[${ErrorCodes.invalidArguments}] ${ErrorMessages.invalidMissingCalendarId}");
    }
  }
}
//
//Future _retrieveCalendarEvents(_calendar) async {
//  final startDate = new DateTime.now().add(new Duration(days: -30));
//  final endDate = new DateTime.now().add(new Duration(days: 30));
//  var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
//    _calendar.id,
//    new RetrieveEventsParams(startDate: startDate, endDate: endDate),
//  );
//
//  print('testtt');
//  print(calendarEventsResult);
//
//  // setState(() {
//  //   _calendar._calendarEvents = calendarEventsResult?.data;
//  //   _calendar._isLoading = false;
//  // });
//}
