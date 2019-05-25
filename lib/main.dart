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

String getDate(index) {
  DateTime date = DateTime.now();
  var prevMonth = new DateTime(date.year, date.month, date.day + index);
  return DateFormat('EEE d MMM').format(prevMonth).toString();
}

String createArrayElements(i) {
  // Gets the cells
  final array = [];
  // Rounding down basically, if time is 80:30, we want the 8PM Cell to be their
  for (int i = getCurrentHour(); i < 48; i++) {
    array.add("Empty");
  }
  return array[i];
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

// This is like the TableView
Widget _buildBlocks() {
  int currentHour = getCurrentHour() - 1 % 24;
  return ListView.builder(
      padding: const EdgeInsets.all(32.0),
      physics: const BouncingScrollPhysics(),
      itemCount: getArrayLength(),
      itemBuilder: (context, index) {
        currentHour += 1;
        print(currentHour);

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
                    createArrayElements(i), // ^ similar to time
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
