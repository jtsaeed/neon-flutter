import 'package:flutter/material.dart';
import 'settings_page.dart';
import '../load_calendar.dart';
import '../main.dart';
import '../palette.dart';
import 'package:neon/widgets/to_do_list.dart';

int selectedIndex = 1;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final widgetOptions = [

    new TodoList(),
    new TableView(),
    new MyHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('To Do List')),
          BottomNavigationBarItem(icon: Icon(Icons.event_note), title: Text('Schedule')),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('Settings')),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: primaryColor,
        onTap: onItemTapped,
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
