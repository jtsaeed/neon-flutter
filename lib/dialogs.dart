import 'package:flutter/material.dart';

void showDialogs(context) {
// user defined function
   void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
}

//class MyApp extends StatelessWidget {
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: TextFieldAlertDialog(),
//    );
//  }
//}
//
//
//class TextFieldAlertDialog extends StatelessWidget {
//  TextEditingController _textFieldController = TextEditingController();
//
//  _displayDialog(BuildContext context) async {
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
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('TextField in AlertDialog'),
//      ),
//      body: Center(
//        child: RaisedButton(
//          child: Text('Show Alert Dialog'),
//          color: Colors.red,
//          onPressed: () => _displayDialog(context),
//        ),
//      ),
//    );
//  }
//}