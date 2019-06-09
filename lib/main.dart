import 'package:flutter/material.dart';
import 'time.dart';
import 'array.dart';
import 'package:neon/widgets/dialogs.dart';
import 'cache_data.dart';


void main() => runApp(MyApp());

Color primaryColor = Color(0xffFEAB00);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hour Blocks",
      theme: ThemeData(
        fontFamily: 'GoogleSans',
        primaryColor: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: TableView(),
        // body: Center(
        // child: Blocks(),
        // ),
      ),
    );
  }
}

var isTomorrow = false;
//var currentHour = getCurrentHour() - 1 % 24;


///*This is like the TableViewDelegate - Creates a widget state, which is stateful / mutable
class TableView extends StatefulWidget {
  @override
  _TableViewState createState() => _TableViewState(); // Creating the tableView widget/state
}

///* This is like the TableViewDataSource / This handles the widgets data and what is doing
class _TableViewState extends State<TableView> {


   @override
    Widget build(BuildContext context) {
      // Runs every time AFTER a cell is clicked on and setState is called
      return _myListView();
    }
  ///
  Widget _myListView() {

//    read();
//    makeArray(setState);
//    List<String> cells = [];
//    _loadArray() async {
//      print("Loading from save");
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      setState(() {
//        cells = (prefs.getStringList('cells'));
//        x = cells.length;
//        print("loaded array length: $x");
//        print(cells);
//      });
//    }
//
//    if (x < getArrayLength()) {
//      print("in If $x");
//      _loadArray();
//      print("in If $x");
//      }


//    if (x < getArrayLength()) {
//      print("Making empty arrays");
//      print("Curent hour ${getCurrentHour()}");
//      for (int i = getCurrentHour(); i < 48; i++) {
//        cells.add('Empty');
//        x = i;
//      }
//      print("x --- $x");
//    }

    loadArray(setState);
    var currentHour = getCurrentHour() - 1 % 24;



    ///*This is like the TableView
    return ListView.builder(    // Makes the cells
    padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
        physics: const BouncingScrollPhysics(),
        itemCount: getArrayLength(),


        itemBuilder: (context, index) {
        print('Index is: $index');
        currentHour += 1;
        print('currentHour is: $currentHour');

        isTomorrow = currentHour == 24 ? true : false;
        if (currentHour >= 47) {
          print('current hour is > 47');
          currentHour = getCurrentHour() - 1 % 24;
        }

        if ( getArrayLength() <=  index ) {
          index = 0;

        }



    if (currentHour <  cells.length) {
      if (index == 0) {
        return ListTile(
          subtitle: Text(
            "Today",
            style: TextStyle(
                fontSize: 34,
                color: Colors.black,
                fontWeight: FontWeight.w800),
            textAlign: TextAlign.left,
          ),
          title: Text(
            getDate(0).toUpperCase(),
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
        );
      }

      else if (currentHour == 24 && isTomorrow == true) {
        print('TOMROROW');
        return ListTile(
          subtitle: Text(
            "Tomorrow",
            style: TextStyle(
                fontSize: 34,
                color: Colors.black,
                fontWeight: FontWeight.w800),
            textAlign: TextAlign.left,
          ),
          title: Text(
            getDate(1).toUpperCase(), // Increments the day
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.left,
          ),
        );
      }
      else {
        isTomorrow = false;
        return _buildBlock(context, index, currentHour);
      }
    }

    else {
      print('Current hour is to high $currentHour');
    }
    });

  }

  Widget _buildBlock(context, index, currentHour) {

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Card(
        color: Colors.white,
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      cells[currentHour],
                      style: TextStyle(fontSize: 24.0, color: Colors.grey, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: new Image.asset("resources/androidAdd@3x.png"),
                iconSize: 48,
                  color: Colors.grey,
                  onPressed: () {
                    cells[currentHour] == 'Empty' ? addDialog(context, index, currentHour, setState) : editDialog(context, index, currentHour, setState);
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
