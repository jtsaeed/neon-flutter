import 'package:flutter/material.dart';

class Dialogs{
  Information(BuildContext context, String Title, String Desc) {
    return showDialog(context: context, 
    barrierdismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(desc)
            
            ], 
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed () => Navigator.pop(context),
            child: Text('Okay'),
          )
        ],
      );
    }
    );
  }
}