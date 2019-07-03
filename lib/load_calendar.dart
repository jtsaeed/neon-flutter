import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'widgets/settings_page.dart';

/*
Loads the calendar data from calender app into scrollview list
*/
List<String> calendarsNames = [];
List<List<Event>> todayCalEvents = [[]];

List<Calendar> calendars;
List<Event> todayCalendarEvents;
List<Event> tomorrowCalendarEvents;

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

    for (int c = 0; c < calendars.length; c++)
      calendarsNames.add(calendars[c].name);

    print(calendarsNames);
  } on PlatformException catch (e) {
    print(e);
  }
}

///
retrieveCalendarEvents() async {


  if (calendars.length != 0) {

    for (int c = 0; c < calendars.length; c++) {
      var startDate = new DateTime.now();
      var timeDiff = 24 - startDate.hour;
      var endDate = new DateTime.now().add(new Duration(hours: timeDiff));

      if (calendarMap[calendarsNames[c]] == 'true') {
        final calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
            calendars[c].id,
            new RetrieveEventsParams(startDate: startDate, endDate: endDate));

          todayCalendarEvents = calendarEventsResult?.data;
        todayCalEvents.add(calendarEventsResult.data);


        startDate = new DateTime.now().add(new Duration(hours: timeDiff));
        endDate = new DateTime.now().add(new Duration(days: 1));

        final calendarEventsResultTomorrow =
            await _deviceCalendarPlugin.retrieveEvents(
                calendars[c].id,
                new RetrieveEventsParams(
                    startDate: startDate, endDate: endDate));
        tomorrowCalendarEvents = (calendarEventsResultTomorrow?.data);


      }
      else if (calendarMap[calendarsNames[c]] == 'false') {

      }


    }



  }
}
