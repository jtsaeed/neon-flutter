import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
/*
Loads the calendar data from calender app into scrollview list
*/
List<Calendar> calendars;
List<Event> calendarEvents;
var calendarsSectionLength =
    0; // Stores the length when fetching the calender data

DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

retrieveCalendars() async {
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

    if (calendars.isNotEmpty) {
      retrieveCalendarEvents();
    }
  } on PlatformException catch (e) {
    print(e);
  }
}

///
retrieveCalendarEvents() async {
  for (int c = 0; c < calendars.length; c++) {
    final startDate = new DateTime.now().add(new Duration(days: 0));
    final endDate = new DateTime.now().add(new Duration(days: 1));
    var calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendars[c].id,
        new RetrieveEventsParams(startDate: startDate, endDate: endDate));
    calendarEvents = calendarEventsResult?.data;
  }
}
