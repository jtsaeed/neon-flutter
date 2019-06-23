import 'package:flutter/material.dart';
import 'time.dart';
import 'palette.dart';
import 'icon_generator.dart';
import './widgets/dialogs.dart';
import 'cache_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'bottom_navbar.dart';

void main() => runApp(MyApp());

Image addIcon = new Image.asset("resources/androidAdd@3x.png");
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'GoogleSans',
        primaryColor: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: TableView(),

      ),
    );
  }
}



///*This is like the TableViewDelegate - Creates a widget state, which is stateful / mutable
class TableView extends StatefulWidget {
  @override
  _TableViewState createState() =>
      _TableViewState(); // Creating the tableView widget/state
}

///* This is like the TableViewDataSource / This handles the widgets data and what is doing
class _TableViewState extends State<TableView> {
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings(
        '@mipmap/ic_launcher'); // Cant seem to use the hourblocks logo :/

    var iOS = new IOSInitializationSettings();

    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

//  flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

//  Future onSelectNotification(String payload) async {
//    debugPrint('notification payload: ' + payload);
//
//    showDialog(context: context, builder: (_) => new AlertDialog(
//      title: new Text('Notification'),
//      content: new Text('$payload'),
//    )); //AlertDialog
//  }

  @override
  Widget build(BuildContext context) {
    // Runs every time AFTER a cell is clicked on and setState is called
    return _myListView();
  }

  ///*This is like the TableView
  Widget _myListView() {
    loadCells(setState); // Load cell data from cache

    return ListView.builder(
        // Makes the cells
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
        physics: const BouncingScrollPhysics(),
        itemCount: getArrayLength(),
        // from 0 to the amount of cells there should be (current hour until tomorrow 11pm)

        itemBuilder: (context, index) {
//               print('Index is: $index');
//               print(getHours(index));

          if (index == 0) {
            // First element is today section
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
                  getDate(0).toUpperCase() + " // BETA 2",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
            );
          } // if end

          else if (allTimeLabels[index + getCurrentHour()] ==
              'TomorrowSection') {
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
                  getDate(1).toUpperCase() + " // BETA 2", // Increments the day
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

empty() {
  return;
}



class MyStatefulWidget extends StatefulWidget {

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {

  int _selectedIndex = 0;
//  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _children = [];



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(_selectedIndex);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('To Do List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            title: Text('Schedule'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}

