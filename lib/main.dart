import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Time package

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter',
//       theme: new ThemeData(primarySwatch: Colors.yellow),
//       home: new MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   _MyHomePageState createState() => new _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         appBar: new AppBar(
//       title: new Text("Today"),
//     ));
//   }
// }

// So this is basically the main ViewController
class MyApp extends StatelessWidget {
  // Stateless are immutable / "FINAL"
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      title: 'Welcome to Flutter',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Blocks(),
        ),
      ),
    );
  }
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
    return _buildBlocks();
  }
}

String GetDate(index) {
  DateTime date = DateTime.now();
  var prevMonth = new DateTime(date.year, date.month, date.day + index);
  return DateFormat('EEE d MMM').format(prevMonth).toString();
}

String getArrayElement(i) {
  final array = [
    'dont ',
    'rate',
    'girls',
    'by',
    'programming languages',
    'shania = binary',
    '>:',
    ':<',
    '>:',
    ':<',
    '>:',
    ':<',
    '>:',
    ':<',
    '>:',
    ':<',
    '>:',
    ':<',
    ':<',
    '>:',
    ':<',
    '>:',
    ':< Element 22',
    'dont ',
    'rate',
    'girls',
    'by',
    'programming languages',
    'shania = binary',
    '>:',
    ':<',
    '>:',
    ':<',
    '>:',
    ':<',
    '>:',
    ':<',
    '>:',
    ':<',
    '>:',
    ':<',
    ':<',
    '>:',
    ':<',
    '>:',
    ':<',
    ':< Element 48?',
  ];

  return array[i];
}

int getArrayLength() =>
    48; // Can have the array as global so that we can get the length

String getHours(i) {
  final time = <String>[];
  var x = 0;
  while (x < 48) {
    var y = x + 1;
    x = x % 24;

    if (y > 24 && y < 37)
      time.add(x.toString() + "AM");
    else
      time.add(x.toString() + "PM");

    x = y;
  }
  return time[i];
}

// This is like the TableView
Widget _buildBlocks() {
  return ListView.builder(
      padding: const EdgeInsets.all(32.0),
      physics: const BouncingScrollPhysics(),
      itemCount: getArrayLength(),
      itemBuilder: (context, index) {
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
              GetDate(0),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
          );
          // Just adding this for now, depends how the arrays etc are worked out
        } else if (index == 24) {
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
              GetDate(1),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
          );
        }

        return _buildCell(index);
      });
}

// This is like the TableViewCell
Widget _buildCell(int i) {
  return Container(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
    child: Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getHours(
                        i), // Will be changed into a variable/array for every hour, use the array index or a seperate for loop to do it
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    getArrayElement(i - 1), // ^ similar to time
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle, size: 48, color: Colors.amberAccent),
          ],
        ),
      ),
    ),
  );
}
