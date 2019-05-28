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
        // body: Center(
        body: BodyLayout(),
       
        // child: Blocks(),
        // ),
      ),
    );

  }
}

/* This is like the TableViewDelegate
 */
// Also makes a state/Object/Widget, which is then added to the view controller?
class Blocks extends StatefulWidget {// Stateful are mutable / Can change
  @override
  BlocksState createState() => BlocksState();
}

/* This is like the TableViewDataSource
 */
class BlocksState extends State<Blocks> {
  @override
  Widget build(BuildContext context) {
    // return _buildBlocks(context);
  }
}

// -------
class BodyLayout extends StatefulWidget {
  @override
  BodyLayoutState createState() {
    return new BodyLayoutState();
  }
}

class BodyLayoutState extends State<BodyLayout> {
  @override
  Widget build(BuildContext context) {
    return _myListView();
  }

/*This is like the TableView
 */
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
            child: ListTile(
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
                setState(() {
                  cells[index] = "test";
                  print(cells);
                });

              },
            ),
          );

          // return _buildCell(index);
        });
  }
}




//class Dialogs extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    print("222");
//    return MaterialApp(
//      home: TextFieldAlertDialog(),
//    );
//  }
//}


//class TextFieldAlertDialog extends StatelessWidget {
//   TextEditingController _textFieldController = TextEditingController();
//
//  _displayDialog(BuildContext context) async {
//    print("11");
//
//    return showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            title: Text('TextField in Dialog'),
//            content: TextField(
//              controller: _textFieldController,
//              decoration: InputDecoration(hintText: "TextField in Dialog"),
//            ),
//            actions: <Widget>[
//              new FlatButton(
//                child: new Text('CANCEL'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              )
//            ],
//          );
//        });
//  }
//}

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
