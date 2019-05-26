import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Time package

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Welcome to Flutter',
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
//
//class MyApp extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      debugShowCheckedModeBanner: false,
//      home: TextFieldAlertDialog(),
//    );
//  }
//}

String getDate(index) {
  DateTime date = DateTime.now();
  var prevMonth = new DateTime(date.year, date.month, date.day + index);
  return DateFormat('EEE d MMM').format(prevMonth).toString();
}

int getCurrentHour() {
  DateTime getTime = DateTime.now();
  return getTime.hour -
      1; // Rounding down basically, if time is 80:30, we want the 8PM Cell to be their
}

int getArrayLength() =>
    48 -
    getCurrentHour(); // Gets current amount of cells (From current time until tomorrows 23pm)

String getHours(i) {
  final time = <String>[];

  // Rounding down basically, if time is 80:30, we want the 8PM Cell to be their
  int currentHour = getCurrentHour();
  while (currentHour < 48) {
    var y = currentHour + 1; // Store the actual count
    currentHour = currentHour % 24; // keep number between 0 & 24
    (y > 24 && y < 37) //
        ? time.add(currentHour.toString() +
            "AM") // if Between midnight hours (12am - 12pm)
        : time.add(currentHour.toString() + "PM"); // Else it is PM
    currentHour = y; // Reassign the count
  }
  return time[i];
}

// This is like the TableViewDelegate
// Also makes a state, which is then added to the view controller?
class Blocks extends StatefulWidget {
  // Stateful are mutable / Can change
  @override
  BlocksState createState() => BlocksState();
}

// This is like the TableViewDataSource
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


class TextFieldAlertDialog extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "TextField in Dialog"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextField in AlertDialog'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Show Alert Dialog'),
          color: Colors.red,
          onPressed: () => _displayDialog(context),
        ),
      ),
    );
  }
}

List<String> array = [];
int x = 0;

int makeArray() {
  if (x < 47) {
    for (int i = getCurrentHour(); i < 48; i++) {
      array.add("Empty");
      x = i;
    }
  }
}

class BodyLayoutState extends State<BodyLayout> {
  @override
  Widget build(BuildContext context) {
    return _myListView();
  }

// This is like the TableView
  Widget _myListView() {
    print("hello");
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
              onTap: () {
                print('Moon');
              },
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
            // Just adding this for now, depends how the arrays etc are worked out
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
                getHours(
                    index), // Will be changed into a variable/array for every hour, use the array index or a seperate for loop to do it
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.left,
              ),
              subtitle: Text(
                array[index],
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                textAlign: TextAlign.left,
              ),

              onTap: () {
                setState(() {
                  array[index] = "test";
                  print(array);
                  print(array.length);
                });
              },
            ),
          );

          // return _buildCell(index);
        });
  }
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
