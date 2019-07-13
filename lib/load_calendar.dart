import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';
import 'widgets/settings_page.dart';

var todayTitle;
var tomorrowTitle;

/*
Loads the calendar data from calender app into scrollview list
*/
List<String> calendarsNames = [];
///NSFW this naughty code
List<List<Event>> todayCalEvents = [[]];
List<List<Event>> tomorrowCalEvents = [[]];
List<Calendar> calendars;

var calendarsSectionLength = 0; // Stores the length when fetching the calender data

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
  if (calendars != null)
  if (calendars.length != 0) {
    for (int c = 0; c < calendars.length; c++) {
      var startDate = new DateTime.now();
      var timeDiff = 24 - startDate.hour;
      var endDate = new DateTime.now().add(new Duration(hours: timeDiff));

      if (calendarMap[calendarsNames[c]] == 'true') {
        final calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
            calendars[c].id,
            new RetrieveEventsParams(startDate: startDate, endDate: endDate));

        var todayCalendarEvents = calendarEventsResult?.data;
        todayCalEvents.add(calendarEventsResult.data);

        for (int e = 0; e < todayCalendarEvents.length; e++) {
          if (todayCalendarEvents[e].allDay == true) {
            print('allDay');
            print(todayCalendarEvents[e].title);
            todayTitle = todayCalendarEvents[e].title;
          }
        }

        startDate = new DateTime.now().add(new Duration(hours: timeDiff));
        endDate = new DateTime.now().add(new Duration(days: 1));

        final calendarEventsResultTomorrow =
            await _deviceCalendarPlugin.retrieveEvents(
                calendars[c].id,
                new RetrieveEventsParams(
                    startDate: startDate, endDate: endDate));
        var tomorrowCalendarEvents = calendarEventsResultTomorrow?.data;
        tomorrowCalEvents.add(calendarEventsResultTomorrow.data);

        for (int e = 0; e < tomorrowCalendarEvents.length; e++) {
          if (tomorrowCalendarEvents[e].allDay == true) {
            print('allDay');
            print(tomorrowCalendarEvents[e].title);
            tomorrowTitle = tomorrowCalendarEvents[e].title;
          }
        }
      } else if (calendarMap[calendarsNames[c]] == 'false') {
        print('not loading: ${calendarsNames[c]}');
      }
    }
  }
}
