import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart'; // Just for theme example
import '../load_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cache_data.dart';
import 'dart:convert';
import '../time.dart';
import '../palette.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

Map<String, dynamic> calendarMap = new Map.fromIterable(calendarsNames,
    key: (calendarName) => calendarName,
    value: (calendarSelected) => 'true');
var mapString = '';

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
        // [Calendar]
        PreferenceTitle('Calendars'),
        new ConstrainedBox(
          constraints: new BoxConstraints(maxHeight: calendars.length * 48.0),
          child: new ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: calendars?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector(
                child: new Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
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
                            if (calendarMap[calendarsNames[index]] == 'false') {
                              removeUpdateCells(setState);
                            }
                            else {
                              addUpdateCells(setState);
                            }
  
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


        /// [Night Hours]
        PreferenceTitle('Other'),
        SwitchPreference(
          'Night Time Hours',
          'exp_showos',
          desc: 'Show Hour Blocks between 12am and 6am',
        ),

        /// [Buttons]
        new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new RaisedButton(
            child: const Text('Follow me on Twitter for updates'),
//          color: Theme.of(context).accentColor,
            color: primaryColor,
            textColor: Colors.white,
            elevation: 2.0,
            splashColor: primaryColor,
            onPressed: () {
              _launchURL();
            },
          ),
        ),

      ]),
    );
  }


  _launchURL() async {
    const url = 'https://twitter.com/j_t_saeed';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
Future removeUpdateCells(setState) async {

  final prefs = await SharedPreferences.getInstance();

   List<Event>tempEventsToDelete;

  for (int i = 0; i < calendars.length; i++) {
    if (calendarMap[calendarsNames[i]] == 'false') {
      print('removing cells from: ');
      print(calendarsNames[i]);

      var startDate = new DateTime.now();
      var endDate = new DateTime.now().add(new Duration(days: 2));

      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

        final calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
            calendars[i].id, new RetrieveEventsParams(startDate: startDate, endDate: endDate));
         tempEventsToDelete = calendarEventsResult?.data;
    }
  }
  for (int x = 0; x < tempEventsToDelete.length; x++) {
    for (int h = getCurrentHour(); h < timeKeys.length; h++) {
      if (tempEventsToDelete[x].start.hour == timeKeys[h]) {
        var startHour = timeKeys[h];
        setState(() {
          cells[h - getCurrentHour()] = 'Empty';
          prefs.remove(timeKeys[h].toString());
        });

        while (startHour < tempEventsToDelete[x].end.hour - 1) { // Dont use the ending hour for a cell, so subtract 1
          startHour++;
          cells[h - getCurrentHour()] = 'Empty';
          prefs.remove(timeKeys[startHour].toString());
        }
      }
    }
  }

}


Future addUpdateCells(setState) async {
  
  List<Event>tempEventsToAdd;
  
  for (int i = 0; i < calendars.length; i++) {
    if (calendarMap[calendarsNames[i]] == 'true') {
      print(calendarsNames[i]);
      
      var startDate = new DateTime.now();
      var endDate = new DateTime.now().add(new Duration(days: 2));
      
      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();
      
      final calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendars[i].id, new RetrieveEventsParams(startDate: startDate, endDate: endDate));
      tempEventsToAdd = calendarEventsResult?.data;
    }
  }
  for (int x = 0; x < tempEventsToAdd.length; x++) {
    for (int h = getCurrentHour(); h < timeKeys.length; h++) {
      if (tempEventsToAdd[x].start.hour == timeKeys[h]) {
        setState(() {
          cells[h - getCurrentHour()] = tempEventsToAdd[x].title;
          save(timeKeys[h] - getCurrentHour(), tempEventsToAdd[x].title);
        });
      }
    }
  }
  
}