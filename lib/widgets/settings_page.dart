import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart'; // Just for theme example
import '../load_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cache_data.dart';
import '../main.dart';
import 'dart:convert';
import '../time.dart';
import '../load_calendar.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/services.dart';

//Map<String, String> calendarMap = new Map.fromIterable(calendarsNames,
//    key: (calendarName) => calendarName,
//    value: (calendarSelected) => 'false');
//var mapString = '';



Map<String, dynamic> calendarMap = new Map.fromIterable(calendarsNames,
    key: (calendarName) => calendarName,
    value: (calendarSelected) => 'true');
var mapString = '';


loadSelectedCalendars() async {
  final prefs = await SharedPreferences.getInstance();


}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        /// [Personalization]

      body: PreferencePage([
        PreferenceTitle('Personalization'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: true,
          onSelect: () {
            DynamicTheme.of(context).setBrightness(Brightness.light);
          },
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
          onSelect: () {
            DynamicTheme.of(context).setBrightness(Brightness.dark);
          },
        ),

        /// [NightMode]
        PreferenceTitle('Night mode'),
        SwitchPreference(
          'Change night hours',
          'exp_showos',
          desc: 'hide cells 12am - 6am',
        ),

        /// [Feedback]
        PreferenceTitle('Got an issue?'),
        TextFieldPreference(
          'Feedback',
          'user_display_name',
        ),

        /// [Buttons]
        const SizedBox(height: 15),
        new RaisedButton(
          child: const Text('Submit'),
//          color: Theme.of(context).accentColor,
          color: Colors.amber[800],
          textColor: Colors.white,
          elevation: 4.0,
          splashColor: Colors.amber[800],
          onPressed: () {
            //TODO
          },
        ),
        new RaisedButton(
          child: const Text('Connect with Twitter'),
//          color: Theme.of(context).accentColor,
          color: Colors.amber[800],
          textColor: Colors.white,
          elevation: 4.0,
          splashColor: Colors.amber[800],
          onPressed: () {
            //TODO
          },
        ),
        PreferenceTitle('Calendar'),
        new ConstrainedBox(
          constraints: new BoxConstraints(maxHeight: calendars.length * 50.0),
          child: new ListView.builder(
            itemCount: calendars?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector(
                child: new Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Row(
                    children: <Widget>[
                      Text(calendars[index].name),
                      Checkbox(
                        value: calendarMap[calendars[index].name] == 'true',
                        onChanged: (bool value) {
                          setState(() {
                            calendarMap[calendarsNames[index]] = calendarMap[calendarsNames[index]] == 'false'
                                ? 'true'
                                : 'false';
                            retrieveCalendarEvents(); // Updates calendar events
                            updateCells(setState);

                            mapString = json.encode(calendarMap); // convert map to string
                            save('calendarPrefs', mapString); // cache string list
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
Future updateCells(setState) async {

  final prefs = await SharedPreferences.getInstance();

   List<Event>tempEventsToDelete;

  for (int i = 0; i < calendars.length; i++) {
    if (calendarMap[calendarsNames[i]] == 'false') {
      var startDate = new DateTime.now();
      var endDate = new DateTime.now().add(new Duration(days: 1));

      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

        final calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
            calendars[i].id, new RetrieveEventsParams(startDate: startDate, endDate: endDate));
         tempEventsToDelete = await calendarEventsResult?.data;
    }
  }

  for (int x = 0; x < tempEventsToDelete.length; x++) {
    for (int h = getCurrentHour(); h < getArrayLength(); h++) {
      if (tempEventsToDelete[x].start.hour == timeKeys[h]) {
        setState(() {
          cells[timeKeys[h - getCurrentHour()]] = 'Empty';
          prefs.remove(timeKeys[h - getCurrentHour()].toString());
        });
      }
    }
  }


}