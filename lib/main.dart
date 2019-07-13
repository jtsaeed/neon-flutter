import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:preferences/preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';

import './widgets/dialogs.dart';
import 'package:neon/widgets/to_do_list.dart';
import 'package:neon/widgets/bottom_navbar.dart';

import 'palette.dart';
import 'icon_generator.dart';
import 'time.dart';
import 'cache_data.dart';
import 'load_calendar.dart';

Image addIcon = new Image.asset("resources/androidAdd@3x.png");
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

main() async {
  await loadCalendarPrefs(); // Load calendar prefs, (which calendars they want to load in)
  await retrieveCalendars(); // Then retrieve the calendars they want based on the prefs
  await retrieveCalendarEvents(); // Now we load the events for each of the calendars they want
  await toDoListMain(); // initialize the to do list and load prefs data
  await PrefService.init(prefix: 'pref_'); // Load settings page 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'GoogleSans',
        primaryColor: primaryColor,
        accentColor: primaryColor,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: HomePage(),
      ),
    );
  }
}

///*This is like the TableViewDelegate - Creates a widget state, which is stateful / mutable
class TableView extends StatefulWidget {
  @override
  _TableViewState createState() => _TableViewState(); // Creating the tableView widget/state
}

///* This is like the TableViewDataSource / This handles the widgets data and what is doing
class _TableViewState extends State<TableView> {
  void initState() {
    // Called before the Listview is created
    super.initState();
    
    /// Setup notifications
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings);
    
    /// load Calendar data and cell data
    loadCalendar(setState);
    loadCalendarTomorrow(setState);
    loadCells(setState); // Load cell data from shared preference
  }
  
  @override
  Widget build(BuildContext context) {
    // Runs every time AFTER a cell is clicked on and setState is called
    // SetState updates the ListView, thus we call this to rebuild the ListView
    return _myListView();
  }
  
  ///*This is like the TableView / ListView
  Widget _myListView() {
    return ListView.builder(// Makes the cells
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
        physics: const BouncingScrollPhysics(),
        itemCount: getArrayLength(), // from 0 to the amount of cells there should be (current hour until tomorrow 11pm)
        itemBuilder: (context, index) {
          if (index == 0) {// First element is today section
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
              child: ListTile(
                subtitle: Text(
                  "Today",
                  style: TextStyle(
                      fontSize: 34,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.left,
                ),
                title: Text(
                  getDate(0).toUpperCase() + " ${todayTitle ?? ''} // BETA 3",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
            );
          } // if end
          
          else if (allTimeLabels[index + getCurrentHour()] == 'TomorrowSection') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
              child: ListTile(
                subtitle: Text(
                  "Tomorrow",
                  style: TextStyle(
                      fontSize: 34,
                      color: Colors.black,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.left,
                ),
                title: Text(
                  getDate(1).toUpperCase() +
                      " ${tomorrowTitle ?? ''} // BETA 3",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
            );
          } // else if end
          
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: _buildBlock(context, index),
          );
        } // Item build // end
    ); // ListView.builder // end
  } // Widget _myListView() // end
  
  /// Build each cell/block
  Widget _buildBlock(context, index) {
    return Container(
      // Create outer body for the cell/block
      // UI Design
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.075),
              blurRadius: 8,
            )
          ]),
      
      child: GestureDetector( // When tap on anywhere on cell
        onTap: () {
          cells[index] == 'Empty' ? _empty() : editDialog(context, index, setState);
        },
        // Design for inner body of the block/cell
        child: Card(
          color: Colors.white,
          elevation: 0, // Flattens cell so they are essentially on one layer, merged together
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        getHours(index),
                        style: TextStyle(
                            fontSize: 14,
                            color: grayColor,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                      AutoSizeText(
                        capitalisedTitle(cells[index]),
                        minFontSize: 17,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 24.0,
                            color: cells[index] == "Empty" ? grayColor : Colors.black,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ], // Sub children end
                  ), // Column end
                ), // Expanded end
                
                IconButton(
                  icon: cells[index] == 'Empty' ? addIcon : generateIcon(cells[index]),
                  iconSize: 48,
                  color: lightGrayColor,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    cells[index] == 'Empty'
                        ? addDialog(context, index, setState)
                        : editDialog(context, index, setState);
                  },
                ),
              ], // Parent children end
            ), // Row end
          ),
        ),
      ),
    );
  }

  String capitalisedTitle(String title) {
    var capitalisedTitle = "";
    var words = title.split(" ");

    for (String word in words) {
      capitalisedTitle += capitaliseWord(word);
      capitalisedTitle += " ";
    }

    capitalisedTitle = capitalisedTitle.substring(0, capitalisedTitle.length - 1);

    return capitalisedTitle;
  }

  String capitaliseWord(String s) => s[0].toUpperCase() + s.substring(1);

  _empty() => false;
  
}

