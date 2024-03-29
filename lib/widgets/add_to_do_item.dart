import 'package:flutter/material.dart';
import 'to_do_list.dart';
import '../palette.dart';
import 'bottom_navbar.dart';

var input = '';
var placeHolderVar = _placeHolder('');
var runOnce = false;

List<String> priorityLabels = ['No Priority', 'Low Priority', 'Medium Priority', 'High Priority'];
// move the dialog into it's own stateful widget.
// It's completely independent from your page


checkInput() {
   if (edit == true && editIndex != -1){
    input = _placeHolder(todoItems[editIndex]).text;
    placeHolderVar = _placeHolder(todoItems[editIndex]);
  }
   else {
     input = _placeHolder('').text;
     placeHolderVar = _placeHolder('');
   }
}

TextEditingController _placeHolder(cellValue) {
  if (cellValue != null || cellValue != '')
    textController.text = edit == true ? cellValue : '';
  return textController;
}

class AddDialog extends StatefulWidget {
  /// initial selection for the slider

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  /// current selection of the slider
  double sliderVal = 0;
  var displayPriorityLabel = 'No Priority';

  void _addItemAndPriority() {
    setState(() => edit == true ? // If
    todoItems[editIndex] = input : // True
    todoItems.add(input)); // False

    setState(() => edit == true ?
    priorityList[editIndex] = displayPriorityLabel :
    priorityList.add(displayPriorityLabel));
  }


  void _sortList() {
    List<String> noP = [];
    List<String> lowP = [];
    List<String> medP = [];
    List<String> highP = [];
    List<String> taskNoP = [];
    List<String> taskLowP = [];
    List<String> taskMedP = [];
    List<String> taskHighP = [];

    for (int p = 0; p < priorityList.length; p++) {


      if (priorityList[p] == priorityLabels[0]) {
        noP.add(priorityList[p]);
        taskNoP.add(todoItems[p]);
      }
      else if (priorityList[p] == priorityLabels[1]) {
        lowP.add(priorityList[p]);
        taskLowP.add(todoItems[p]);
      }
      else if (priorityList[p] == priorityLabels[2]) {
        medP.add(priorityList[p]);
        taskMedP.add(todoItems[p]);
      }
      else if (priorityList[p] == priorityLabels[3]) {
        highP.add(priorityList[p]);
        taskHighP.add(todoItems[p]);
      }
    }

    todoItems = [taskHighP, taskMedP, taskLowP, taskNoP].expand((x) => x).toList();
    priorityList = [highP, medP, lowP, noP].expand((x) => x).toList();
    saveList('savedToDoList', todoItems);
    saveList('savedToDoPriorities', priorityList);
  }

  _updateLabel() {
    if  (sliderVal <= 2) {
      displayPriorityLabel = priorityLabels[0];
    }
    else if (sliderVal > 2 && sliderVal < 5)
      displayPriorityLabel = priorityLabels[1];
    else if (sliderVal > 4 && sliderVal < 7)
      displayPriorityLabel = priorityLabels[2];
    else
      displayPriorityLabel = priorityLabels[3];
  }


  @override
  Widget build(BuildContext context) {

    /// if we keep running check input then when we interact with the widget,
    /// the place holder value resets
    if (runOnce == false) {
      checkInput();
      runOnce = true;
    }

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
                controller: placeHolderVar,
                decoration: new InputDecoration(hintText: 'e.g. Clean the house'),
                onChanged: (value) => input = value // Update the empty label array with the value they have entered
                ),
            new Slider(
              value: sliderVal,
              label: displayPriorityLabel,
              activeColor: getPriorityColor(displayPriorityLabel),
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
            edit = false;
            editIndex = -1;
            runOnce = false;
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          textColor: primaryColor,
          child: new Text("Add"),
          onPressed: () {
            _addItemAndPriority();
            _sortList();
            edit = false;
            editIndex = -1;
            runOnce = false;
            Navigator.pop(context, sliderVal);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ],
      ///Buttons end
    );
  }
}

//class ToDoItemClass { // Create objects
//  final String task;
//  final String priority;
//  ToDoItemClass(this.task, this.priority);
//}

