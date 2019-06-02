import 'package:flutter/material.dart';
import 'time.dart';
import 'array.dart';
import 'dialogs.dart';
import 'cache_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        body: BodyLayout(),
        // body: Center(
        // child: Blocks(),
        // ),
      ),
    );
  }
}

///*This is like the TableViewDelegate

// Also makes a state/Object/Widget, which is then added to the view controller?
//class Blocks extends StatefulWidget {// Stateful are mutable / Can change
//  @override
//  BlocksState createState() => BlocksState();
//}
//
///* This is like the TableViewDataSource
// */
//class BlocksState extends State<Blocks> {
//  @override
//  Widget build(BuildContext context) {
////     return _buildBlocks(context);
//  }
//}

///*This is like the TableViewDelegate - Creates a widget state, which is stateful / mutable
class BodyLayout extends StatefulWidget {
  @override
  BodyLayoutState createState() => BodyLayoutState();
}


List<String> cells = ["--", "Empty", "Empty", "Empty", "Empty", "Empty",
  "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty",
  "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty",
  "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty",
  "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty", "Empty"];
int x = 0;

///* This is like the TableViewDataSource / This adds the widget
class BodyLayoutState extends State<BodyLayout> {
  ///*This is like the TableView
  ///
  ///
  Widget _myListView() {

//    read();
//    makeArray(setState);
//    List<String> cells = [];

  /*
    _loadArray() async {
      print("Loading from save");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        cells = (prefs.getStringList('cells'));
        x = cells.length;
        print("loaded array length: $x");
        print(cells);
      });
    }

    if (x < getArrayLength()) {
      print("in If $x");
      _loadArray();
      print("in If $x");
      }

    if (x < 47) {
      print("Making empty arrays");
      print("Curent hour ${getCurrentHour()}");
      for (int i = getCurrentHour(); i < 48; i++) {
        cells.add('Empty');
        x = i;
      }
      print("x --- $x");
    }



*/
    int currentHour = getCurrentHour() - 1 % 24;
    // Makes the cells
    return ListView.builder(

        padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
        physics: const BouncingScrollPhysics(),
        itemCount: getArrayLength(),
        itemBuilder: (context, index) {
          currentHour += 1;
          if (index == 0) {
            return ListTile(
              subtitle: Text(
                "Today",
                style: TextStyle(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.left,
                // style: Theme.of(context).textTheme.headline,
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
          } else if (currentHour == 24) {
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
          return _buildBlock(context, index);
        });
  }

  Widget _buildBlock(context, index) {
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
                      cells[index],
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              IconButton(
//                  icon: new Image.asset("resources/androidAdd@3x.png"),
               icon:  Icon(Icons.add_circle, size: 48, color: Colors.amberAccent),
                iconSize: 48,
                  color: Colors.grey,
                  onPressed: () {
                    _showDialog(context, index, setState);
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Runs every time AFTER a cell is clicked on and setState is called

    return _myListView();
  }
}

// user defined function
void _showDialog(context, index, setState) {
  String input = "";

  showDialog(
    // flutter defined function
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: new Text('What\'s in store at ${getHours(index).toLowerCase()}?'),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                cursorColor: Colors.orange,
                autofocus: true,
                decoration: new InputDecoration(hintText: 'Revise Maths'),
                onChanged: (value) {
                  input = value; // Update the empty label array with the value they have entered
                },
              ),
            )
          ],
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            textColor: Colors.grey,
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            textColor: primaryColor,
            child: new Text("Add"),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {// This should rerun the build widget and return the updated viewList
                cells.insert(index, input);
//                cells[index] = input;
                save(cells);
                print("CELLS ARE $cells");
                print(cells.length);
              });
            },
          ),
        ],
      );
    },
  );
}