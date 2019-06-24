import 'package:flutter/material.dart';
import './widgets/Settings.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 2;
  final widgetOptions = [
    Text('To Do List'),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text('To Do List')),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), title: Text('Schedule')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings')),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
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
