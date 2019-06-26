import 'package:flutter/material.dart';
import 'time.dart';
import 'palette.dart';
import 'icon_generator.dart';
import './widgets/dialogs.dart';
import 'cache_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neon/widgets/bottom_navbar.dart';
import 'package:preferences/preferences.dart';
import 'load_calender.dart';

Image addIcon = new Image.asset("resources/androidAdd@3x.png");
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
var title;

main() async {
  await retrieveCalendars();
  await retrieveCalendarEvents();
  await PrefService.init(prefix: 'pref_');
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'GoogleSans',
        primaryColor: primaryColor,
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
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher'); // Cant seem to use the hourblocks logo :/
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings);
  }



  @override
  Widget build(BuildContext context) {// Runs every time AFTER a cell is clicked on and setState is called
    return _myListView();
  }

  ///*This is like the TableView
  Widget _myListView() {

    loadCells(setState); // Load cell data from cache
    return ListView.builder(// Makes the cells
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
        physics: const BouncingScrollPhysics(),
        itemCount: getArrayLength(), // from 0 to the amount of cells there should be (current hour until tomorrow 11pm)
        itemBuilder: (context, index) {
          if (index == 0) {// First element is today section
            title = calendarEvents.isEmpty ? '-' : calendarEvents[0].title;
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
              child: ListTile(
                subtitle: Text(
                  "Today",
                  style: TextStyle(
                      fontSize: 34, color: Colors.black, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.left,
                ),
                title: Text(
                  getDate(0).toUpperCase() + " // $title // BETA 2",
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
            );
          } // if end
          else if  (allTimeLabels[index + getCurrentHour()] == 'TomorrowSection') {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
              child: ListTile(
                subtitle: Text(
                  "Tomorrow",
                  style: TextStyle(
                      fontSize: 34, color: Colors.black, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.left,
                ),
                title: Text(
                  getDate(1).toUpperCase() + " // BETA 2", // Increments the day
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600),
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

  Widget _buildBlock(context, index) {
    return Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.075),
              blurRadius: 8,
            )
          ]),
      child: GestureDetector(
        onTap: () {
          cells[index] == 'Empty'
              ? empty()
              : editDialog(context, index, setState);
        },
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getHours(index),
                        style: TextStyle(
                            fontSize: 14,
                            color: grayColor,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        cells[index],
                        style: TextStyle(
                            fontSize: 24.0,
                            color: cells[index] == "Empty"
                                ? grayColor
                                : Colors.black,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: cells[index] == 'Empty'
                      ? addIcon
                      : generateIcon(cells[index]),
                  iconSize: 48,
                  color: lightGrayColor,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    cells[index] == 'Empty'
                        ? addDialog(context, index, setState)
                        : editDialog(context, index, setState);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

getSectionTitle(index) {
  if (index == 0) {
// First element is today section
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
      child: ListTile(
        subtitle: Text(
          "Today",
          style: TextStyle(
              fontSize: 34, color: Colors.black, fontWeight: FontWeight.w800),
          textAlign: TextAlign.left,
        ),
        title: Text(
          getDate(0).toUpperCase() + " // BETA 2",
          style: TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ),
      ),
    );
  } // if end

  else {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
      child: ListTile(
        subtitle: Text(
          "Tomorrow",
          style: TextStyle(
              fontSize: 34, color: Colors.black, fontWeight: FontWeight.w800),
          textAlign: TextAlign.left,
        ),
        title: Text(
          getDate(1).toUpperCase() + " // BETA 2", // Increments the day
          style: TextStyle(
              fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
        ),
      ),
    );
  } // else if end
}

empty() => false;
