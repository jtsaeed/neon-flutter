import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
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

//class GetTime {
//  DateTime now = DateTime.now();
//  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
//}

// This is like the TableView
Widget _buildBlocks() {

  final europeanCountries = ['Albania', 'Andorra', 'Armenia', 'Austria',
    'Azerbaijan', 'Belarus', 'Belgium', 'Bosnia and Herzegovina'];

  return ListView.builder(
      padding: const EdgeInsets.all(32.0),
      physics: const BouncingScrollPhysics(),
      itemCount: europeanCountries.length,

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
              "I cant revise so lets code flutter 2 days before my exam",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,
            ),
          );
          // Just adding this for now, depends how the arrays etc are worked out
        } else if (index == 25) {
          return ListTile(
            title: Text(
              "Tomorrow",
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          );
        }


        return _buildCell(index);
      });
}

// This is like the TableViewCell
Widget _buildCell(int i) {
  final time = <String>[];
  for (var i = 0; i < 25; i++) {
    time.add(i.toString());
  }
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
                    time[i] + "PM",// Will be changed into a variable/array for every hour, use the array index or a seperate for loop to do it
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Empty", // ^ similar to time
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle, size: 48, color: Colors.amberAccent ),
//            Stack(
//              children: <Widget>[
//                Positioned(
////                  left: 1.0,
//                  top: -1, // Adds a background layer, giving a shadow affect
//                  child: Icon(Icons.add_circle, size: 48, color: Colors.grey),
//                ),
//                Icon(Icons.add_circle, size: 48, color: Colors.amberAccent),
//              ],
//            ),
          ],
        ),
      ),
    ),
  );
}
