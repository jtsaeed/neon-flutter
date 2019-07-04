import 'package:flutter/material.dart';
import 'to_do_list.dart';
import '../palette.dart';

// move the dialog into it's own stateful widget.
// It's completely independent from your page
// this is good practice
class AddDialog extends StatefulWidget {
  /// initial selection for the slider

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  /// current selection of the slider
  double sliderVal = 0;
  var priorityLabel = 'No Priority';
  var input = '';

  void _addTodoItem(String task) {
    if (task.length > 0) {
      setState(() => todoItems.add(task));
      saveList('savedToDoList', todoItems);
      print(todoItems);
    }
  }

  void _addPriority(String priority) {
    if (priority.length > 0) {
      setState(() => priorityList.add(priority));
      saveList('savedToDoPriorities', priorityList);
      print(priorityList);
    }
  }

  _updateLabel() {

    if (sliderVal > 2 && sliderVal < 5)
      priorityLabel = 'Low Priority';
    else if (sliderVal > 4 && sliderVal < 7)
      priorityLabel = 'Medium Priority';
    else
      priorityLabel = 'High Priority';
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: new Text('What\'s on your to do list?'),

      content: new Container(
        constraints: BoxConstraints(
          maxHeight: 150.0,
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new TextField(
                cursorColor: primaryLightColor,
                autofocus: true,
                decoration: new InputDecoration(hintText: 'e.g. Revise maths'),
                onChanged: (value) => input = value // Update the empty label array with the value they have entered
                ),
            new Slider(
              value: sliderVal,
              label: priorityLabel,
              /// SOME colors for you to play with
              activeColor: primaryColor,
              inactiveColor: lightGrayColor,
              min: 0,
              max: 10,
              divisions: 3,
              onChanged: (value) {
                setState(() {
                  sliderVal = value;
                  _updateLabel();
                });
              },
            ),
          ],
        ),
      ),

      ///Buttons
      actions: <Widget>[
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
            _addTodoItem(input);
            _addPriority(priorityLabel);
            Navigator.pop(context, sliderVal);
          },
        ),
      ],

      ///Buttons end
    );
  }
}
