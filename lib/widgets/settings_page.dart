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
import 'package:neon/ads.dart';
import 'package:firebase_admob/firebase_admob.dart';

Map<String, dynamic> calendarMap = new Map.fromIterable(calendarsNames,
    key: (calendarName) => calendarName, value: (calendarSelected) => 'true');
var mapString = '';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override

  final cal = calendars != null ? 'Calendars' : 'Settings';
  final height = calendars != null ? calendars.length * 48.0 : 0.0;
  BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
    _bannerAd = createBannerAd()..load()..show(
      anchorType: AnchorType.bottom,
      anchorOffset: 64.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: PreferencePage([
        PreferenceTitle(cal),
        new ConstrainedBox(
          constraints: new BoxConstraints(maxHeight: height),
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
                            calendarMap[calendarsNames[index]] =
                                calendarMap[calendarsNames[index]] == 'false'
                                    ? 'true'
                                    : 'false';
                            retrieveCalendarEvents(); // Updates calendar events
                            if (calendarMap[calendarsNames[index]] == 'false') {
                              removeUpdateCells(setState);
                              removeUpdateCellsTomorrow(setState);
                            } else {
                              addTodayUpdateCells(setState);
                              addTodayUpdateCellsTomorrow(setState);
                            }

                            mapString = json
                                .encode(calendarMap); // convert map to string
                            save('calendarPrefs',
                                mapString); // cache string list
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

//        /// [Night Hours]
//        PreferenceTitle('Other'),
//        SwitchPreference(
//          'Night Time Hours',
//          'exp_showos',
//          desc: 'Show Hour Blocks between 12am and 6am',
//        ),

        /// [Buttons]
        /*
        new Padding(
          padding: const EdgeInsets.all(16.0),
          child: new RaisedButton(
            child: const Text('Follow me on Twitter for updates'),
            color: primaryColor,
            textColor: Colors.white,
            elevation: 2.0,
            splashColor: primaryColor,
            onPressed: () {
              _launchURL('https://twitter.com/j_t_saeed');
            },
          ),
        ),
        new Text(
            'Check out the developers:\n',
            textAlign: TextAlign.center
        ),

        new Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: new RaisedButton(
            child: const Text('Jahan Ulhaque'),
            color: primaryColor,
            textColor: Colors.white,
            splashColor: primaryColor,
            onPressed: () {
              _launchURL('https://jahanuol.github.io/');
            },
          ),
        ),
        new Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: new RaisedButton(
            child: const Text('James Saaed'),
            color: primaryColor,
            textColor: Colors.white,
            splashColor: primaryColor,
            onPressed: () {
              _launchURL('http://www.jtsaeed.com/');
            },
          ),
        ),
        new Text(
            '\n\nMore features to come!',
            textAlign: TextAlign.center,


        ),
        */
      ]),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

BannerAd createBannerAd() {
  return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner
  );
}

Future removeUpdateCells(setState) async {
  final prefs = await SharedPreferences.getInstance();
//  List<Event> tempEventsToDelete;
  List<List<Event>> tempEventsToDelete = [[]];

  for (int i = 0; i < calendars.length; i++) {
    if (calendarMap[calendarsNames[i]] == 'false') {
      print('remove deets from: ${calendarsNames[i]}');

      var s = new DateTime.now();
      var timeDiff = 24 - s.hour;
      var startDate = new DateTime.now();
      var endDate = new DateTime.now().add(new Duration(hours: timeDiff));

      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

      final calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendars[i].id,
          new RetrieveEventsParams(startDate: startDate, endDate: endDate));
      tempEventsToDelete.add(calendarEventsResult?.data);
    }
  }
//  print('Temp event to delete: ${tempEventsToDelete}');
  

  for (int x = 0; x < tempEventsToDelete.length; x++) {
    for (int e = 0; e < tempEventsToDelete[x].length; e++) {
  
      if (tempEventsToDelete[x][e].title == todayTitle) {
        setState(() {
          todayTitle = "";
          print('allDay today');
        });
      }
      
      for (int h = getCurrentHour(); h < timeKeys.length; h++) {
        if (timeKeys[h] == tempEventsToDelete[x][e].start.hour) {
          print('Time: ${timeKeys[h]}');
          print('Removing: ${tempEventsToDelete[x][e].title}');
          var tempKey = tempEventsToDelete[x][e].start.hour;
          
          setState(() {
            cells[h - getCurrentHour()] = 'Empty';
            prefs.remove(timeKeys[h].toString());
          });

          while (tempKey < tempEventsToDelete[x][e].end.hour - 1) {
            tempKey++;
            cells[tempKey - getCurrentHour()] = 'Empty';
            prefs.remove(timeKeys[tempKey].toString());
          }
        }
      }
    }
  }
  print(cells);
}

Future removeUpdateCellsTomorrow(setState) async {
  final prefs = await SharedPreferences.getInstance();
//  List<Event> tempEventsToDelete;
  List<List<Event>> tempEventsToDelete = [[]];

  for (int i = 0; i < calendars.length; i++) {
    if (calendarMap[calendarsNames[i]] == 'false') {
      print('remove deets from: ${calendarsNames[i]}');

      var s = new DateTime.now();
      var timeDiff = 24 - s.hour;
      var startDate = new DateTime.now().add(new Duration(hours: timeDiff));
      var endDate = new DateTime.now().add(new Duration(hours: 24));

      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

      final calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendars[i].id,
          new RetrieveEventsParams(startDate: startDate, endDate: endDate));
      tempEventsToDelete.add(calendarEventsResult?.data);
    }
  }
  print('Temp event to delete: ${tempEventsToDelete}');

  for (int x = 0; x < tempEventsToDelete.length; x++) {
    for (int e = 0; e < tempEventsToDelete[x].length; e++) {
      print(tempEventsToDelete[x][e].title);

      if (tempEventsToDelete[x][e].title == tomorrowTitle) {
        setState(() {
          tomorrowTitle = "";
          print('allDay tomorrow');
        });
      }

      for (int h = 0; h < timeKeys.length; h++) {
        if (timeKeys[h] == tempEventsToDelete[x][e].start.hour) {
          print('Time: ${timeKeys[h]}');
          print('Removing: ${tempEventsToDelete[x][e].title}');

          var tempKey = tempEventsToDelete[x][e].start.hour;

          setState(() {
            cells[h - getCurrentHour() + 25] = 'Empty';
            prefs.remove(timeKeys[h + 25].toString());
          });

          while (tempKey < tempEventsToDelete[x][e].end.hour - 1) {
            tempKey++;
            cells[tempKey - getCurrentHour() + 25] = 'Empty';
            prefs.remove(timeKeys[tempKey + 25].toString());
          }
        }
      }
    }
  }

  print(cells);
}

Future addTodayUpdateCells(setState) async {
  List<List<Event>> tempEventsToAdd = [[]];

  for (int i = 0; i < calendars.length; i++) {
    if (calendarMap[calendarsNames[i]] == 'true') {
//      print('adding deets from: today ${calendarsNames[i]}');

      var s = new DateTime.now();
      var timeDiff = 24 - s.hour;
      var startDate = new DateTime.now();
      var endDate = new DateTime.now().add(new Duration(hours: timeDiff));

      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

      final calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendars[i].id,
          new RetrieveEventsParams(startDate: startDate, endDate: endDate));
      tempEventsToAdd.add(calendarEventsResult?.data);
    }
  }
  for (int x = 0; x < tempEventsToAdd.length; x++) {
    for (int e = 0; e < tempEventsToAdd[x].length; e++) {
      for (int h = getCurrentHour(); h < timeKeys.length; h++) {
        if (tempEventsToAdd[x][e] != null)
        if (tempEventsToAdd[x][e].title != tomorrowTitle &&
            tempEventsToAdd[x][e].title != todayTitle) {
          if (tempEventsToAdd[x][e].start.hour == timeKeys[h]) {
            setState(() {
              var tempKey = tempEventsToAdd[x][e].start.hour;

              cells[timeKeys[h - getCurrentHour()]] =
                  tempEventsToAdd[x][e].title;
              save(timeKeys[h], tempEventsToAdd[x][e].title);

              while (tempKey < tempEventsToAdd[x][e].end.hour - 1) {
                tempKey++;
                cells[tempKey - getCurrentHour()] = tempEventsToAdd[x][e].title;
                save(timeKeys[tempKey], tempEventsToAdd[x][e].title);
              }
            });
          }
        }
      }
    }
  }
  print(cells);
}

Future addTodayUpdateCellsTomorrow(setState) async {
  List<List<Event>> tempEventsToAdd = [[]];

  for (int i = 0; i < calendars.length; i++) {
    if (calendarMap[calendarsNames[i]] == 'true') {
//      print('adding deets from: tomorrow ${calendarsNames[i]}');

      var s = new DateTime.now();
      var timeDiff = 24 - s.hour;
      var startDate = new DateTime.now().add(new Duration(hours: timeDiff));
      var endDate = new DateTime.now().add(new Duration(days: 1));

      DeviceCalendarPlugin _deviceCalendarPlugin = new DeviceCalendarPlugin();

      final calendarEventsResult = await _deviceCalendarPlugin.retrieveEvents(
          calendars[i].id,
          new RetrieveEventsParams(startDate: startDate, endDate: endDate));
      tempEventsToAdd.add(calendarEventsResult?.data);
    }
  }
  for (int x = 0; x < tempEventsToAdd.length; x++) {
    for (int e = 0; e < tempEventsToAdd[x].length; e++) {
      for (int h = 0; h < timeKeys.length; h++) {
        if (tempEventsToAdd[x][e].start.hour == timeKeys[h]) {

          if (tempEventsToAdd[x][e] != null)

          if (tempEventsToAdd[x][e].title != tomorrowTitle &&
              tempEventsToAdd[x][e].title != todayTitle) {
            setState(() {
              var tempKey = tempEventsToAdd[x][e].start.hour;

              cells[timeKeys[h - getCurrentHour() + 25]] =
                  tempEventsToAdd[x][e].title;
              save(timeKeys[h + 25], tempEventsToAdd[x][e].title);

              while (tempKey < tempEventsToAdd[x][e].end.hour - 1) {
                tempKey++;
                cells[tempKey - getCurrentHour() + 25] =
                    tempEventsToAdd[x][e].title;
                save(timeKeys[tempKey + 25], tempEventsToAdd[x][e].title);
              }
            });
          }
        }
      }
    }
  }
  print(cells);
}
