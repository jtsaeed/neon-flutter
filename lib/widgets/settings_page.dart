import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart'; // Just for theme example
import '../load_calendar.dart';

final list = List.filled(calendars.length, false);

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
                        value: list[index],
                        onChanged: (bool value) {
                          setState(() {
                            list[index] = value;
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
