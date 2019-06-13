import 'package:flutter/material.dart';
import 'time.dart';
import 'array.dart';
import 'icon_generator.dart';
import 'package:neon/widgets/dialogs.dart';
import 'cache_data.dart';


void main() => runApp(MyApp());

Color primaryColor = Color(0xffFEAB00);
Image addIcon = new Image.asset("resources/androidAdd@3x.png");

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

//var currentHour = getCurrentHour() - 1; // get the current hour


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

   ///*This is like the TableView
   Widget _myListView() {

//     makeArray(); // Create all 48 time cells
     loadArray(setState); // Load cell data from cache

       return ListView.builder( // Makes the cells
           padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
           physics: const BouncingScrollPhysics(),
           itemCount: getArrayLength(), // from 0 to the amount of cells there should be (current hour until tomorrow 11pm)

           itemBuilder: (context, index) {

               print('Index is: $index');
//               print(getHours(index));

               if (index == 0) {
                 return Padding(
                   padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                   child: ListTile(
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
                   ),
                 );
               } // if end

               //               else if (time[index] == '12PM') {

               else if (time[index + getCurrentHour()] == '24TOMORROW') {
                 return Padding(
                   padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                   child: ListTile(
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
                   ),
                 );
               } // else if end
               
               return Padding(
                 padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                 child: _buildBlock(context, index),
               );


           } // Item build // end
       ); // ListView.builder // end
   } // Widget _myListView() // end

    Widget _buildBlock(context, index) {

    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [new BoxShadow(
          color: Colors.black.withOpacity(0.075),
          blurRadius: 8,
        )]
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
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
                      style: TextStyle(fontSize: 24.0, color: cells[index] == "Empty" ? Colors.grey : Colors.black, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: cells[index] == 'Empty' ? addIcon : generateIcon(cells[index]),
                iconSize: 48,
                  color: Colors.grey,
                  onPressed: () {
                    cells[index] == 'Empty' ? addDialog(context, index, setState) : editDialog(context, index, setState);
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}