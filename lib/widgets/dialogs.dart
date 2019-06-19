import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../scheduled_notifcations.dart';
import '../time.dart';
import '../palette.dart';
import '../main.dart';
import '../cache_data.dart';

var edit = false; // Check if user is editing a cell and not adding, used to edit the hintText message

addDialog(context, index, setState)  {
  String input = "";

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: new Text(
            'What\'s in store at ${getHours(index).toLowerCase()}?'),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                cursorColor: Colors.orange,
                autofocus: true,
                decoration: new InputDecoration(hintText: edit == true ? cells[index] : 'e.g. Have breakfast'),
                onChanged: (value) => input = value // Update the empty label array with the value they have entered
              ),
            )
          ],
        ),
        actions: <Widget>[ // usually buttons at the bottom of the dialog
          new FlatButton(
            textColor: Colors.grey,
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            textColor: primaryColor,
            child: new Text("Add"),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() { // This should rerun the build widget and return the updated viewList
                cells[index] = input == '' ? 'Empty' : input; // If they enter nothing then add empty again
                save(timeKeys[index + getCurrentHour()],  cells[index]); // Save message and use the hour as the key
                saveDate();
                edit = false;
              });
            },
          ),
        ],
      );
    },
  );
}


editDialog(context, currentHourKey, setState) async  {
  final prefs = await SharedPreferences.getInstance();

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(

          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  trailing: new Icon(Icons.edit),
                  title: new Text('Edit'),
                  onTap: () {
                    Navigator.of(context).pop();
                    edit = true;
                    addDialog(context, currentHourKey, setState);
                  }
              ),
              new ListTile(
                  trailing: new Icon(Icons.delete),
                title: new Text('Clear'),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                        cells[currentHourKey] = 'Empty';
//                        print('editing cell: $currentHourKey');
                        prefs.remove(timeKeys[currentHourKey + getCurrentHour()].toString()); // Remove key from cache
//                        print('REMOVED: ${timeKeys[currentHourKey].toString()}');


                    });
                  }
              ),
              new ListTile(
                  trailing: new Icon(Icons.timer),
                title: new Text('Set Reminder'),
                onTap: () {
                 Navigator.of(context).pop();
                 _setRemainderDialog(context, currentHourKey);
                  }
              ),
              new ListTile(
                  trailing: new Icon(Icons.cancel),
                title: new Text('Cancel'),
                  onTap: () {
                    Navigator.of(context).pop();
                  }
              ),
            ],
          ),
        );
      }
  );
}

_setRemainderDialog(context, cellTime)  {

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  title: new Text('60 Minutes'),
                  onTap: () {
                    scheduleNotification(cellTime, 60);
                    Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                  title: new Text('30 Minutes'),
                  onTap: () {
                    scheduleNotification(cellTime, 30);
                    Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                  title: new Text('15 Minutes'),
                  onTap: () {
                    scheduleNotification(cellTime, 15);
                    Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                  title: new Text('5 Minutes'),
                  onTap: () {
                    scheduleNotification(cellTime, 5);
                    Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                  title: new Text('Cancel'),
                  onTap: () {
                    Navigator.of(context).pop();
                  }
              ),
            ],
          ),
        );
      }
  );
}
