import 'package:flutter/material.dart';
import 'time.dart';
import 'main.dart';
import 'scheduled_notifcations.dart';

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
                decoration: new InputDecoration(hintText: 'Revise Maths'),
                onChanged: (value) {
                  input = value; // Update the empty label array with the value they have entered
                },
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
                cells[index] = input;
//                cells[index] = input;
//                save(cells);
                print("CELLS ARE $cells");
                print(cells.length);
              });
            },
          ),
        ],
      );
    },
  );
}


editDialog(context, index, setState)  {
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
                    addDialog(context, index, setState);
                  }
              ),
              new ListTile(
                  trailing: new Icon(Icons.delete),
                title: new Text('Clear'),
                  onTap: () {
//                    setState(() {cells[index] = 'Empty';});
                  setState(() => cells[index] = 'Empty');
                  Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                  trailing: new Icon(Icons.timer),
                title: new Text('set reminder'),
                onTap: () {
                 Navigator.of(context).pop();
                 _setRemainderDialog(context, index);
                  }
              ),
              new ListTile(
                  trailing: new Icon(Icons.cancel),
                title: new Text('cancel'),
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


_setRemainderDialog(context, index)  {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  title: new Text('60 Minutes'),
                  onTap: () {
                    scheduleNotification(index, 60);
                    Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                  title: new Text('30 Minutes'),
                  onTap: () {
                    scheduleNotification(index, 30);
                    Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                  title: new Text('15 Minutes'),
                  onTap: () {
                    scheduleNotification(index, 15);
                    Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                  title: new Text('5 Minutes'),
                  onTap: () {
                    scheduleNotification(index, 5);
                    Navigator.of(context).pop();
                  }
              ),
              new ListTile(
                  title: new Text('cancel'),
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
