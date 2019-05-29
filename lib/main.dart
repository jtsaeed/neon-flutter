import 'package:flutter/material.dart';
import 'time.dart';
import 'array.dart';
//import 'dialogs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hour Blocks",
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

///* This is like the TableViewDataSource / This adds the widget
class BodyLayoutState extends State<BodyLayout> {

  ///*This is like the TableView
  Widget _myListView() {
    makeArray();
    int currentHour = getCurrentHour() - 1 % 24;

    // Makes the cells
    return ListView.builder(
        padding: const EdgeInsets.all(32.0),
        physics: const BouncingScrollPhysics(),
        itemCount: getArrayLength(),
        itemBuilder: (context, index) {
          currentHour += 1;
          if (index == 0) {
            return ListTile(
              title: Text(
                "Today",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
                // style: Theme.of(context).textTheme.headline,
              ),
              subtitle: Text(
                getDate(0),
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
            );
          } else if (currentHour == 24) {
            return ListTile(
              title: Text(
                "Tomorrow",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                getDate(1), // Increments the day
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              ),
            );
          }
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              trailing:
                  Icon(Icons.add_circle, size: 48, color: Colors.amberAccent),
              title: Text(
                getHours(index),
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                cells[index],
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                textAlign: TextAlign.left,
              ),
              onTap: () {
                _showDialog(context, index, setState, index);
              },
            ),
          );
          // return _buildCell(index);
        });
  }

  @override
  Widget build(BuildContext context) {
    // Runs every time AFTER a cell is clicked on and setState is called
    return _myListView();
  }
}

// user defined function
void _showDialog(context, index, setState, i) {

  String input = "";

  showDialog(
    // flutter defined function
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: new Text('What\'s in store at ${getHours(index)}?'),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Enter', hintText: 'Revise Maths'),
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
            child: new Text("Add"),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {// This should rerun the build widget and return the updated viewList
                cells[index] = input;
              });
            },
          ),
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// This is like the TableViewCell
// Widget _buildCell(int i) {
//   return Container(
//     padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
//     child: Card(
//       color: Colors.white,
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     getHours(
//                         i), // Will be changed into a variable/array for every hour, use the array index or a seperate for loop to do it
//                     style: TextStyle(fontSize: 14, color: Colors.grey),
//                     textAlign: TextAlign.left,
//                   ),
//                   Text(
//                     createArrayElements(i), // ^ similar to time
//                     style: TextStyle(
//                         fontSize: 24.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey),
//                     textAlign: TextAlign.left,
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.add_circle, size: 48, color: Colors.amberAccent),
//           ],
//         ),
//       ),
//     ),
//   );
// }
