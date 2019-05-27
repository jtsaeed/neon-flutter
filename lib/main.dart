import 'package:flutter/material.dart';
import "time.dart";
import "array.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

class BodyLayoutState extends State<BodyLayout> {
  @override
  Widget build(BuildContext context) {
    return _myListView();
  }

// This is like the TableView
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
