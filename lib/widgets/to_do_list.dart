import 'package:flutter/material.dart';
import '../cache_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../time.dart';
import '../palette.dart';
import 'add_to_do_item.dart';

List<String> todoItems = [];
List<String> priorityList = [];

// Used for the placeholder text
var textController = new TextEditingController();
var edit = false; // Check if user is editing a cell and not adding, used to edit the hintText message
var editIndex = -1;

toDoListMain() async {
  final prefs = await SharedPreferences.getInstance();
  todoItems = prefs.getStringList('savedToDoList');
  priorityList = prefs.getStringList('savedToDoPriorities');
  if (todoItems == null || priorityList == null) {
    todoItems = [];
    priorityList = [];
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}


class TodoListState extends State<TodoList> {

  // Build the whole list of todo items // MAIN widget for to do list
  Widget _buildTodoList() {
    return new ListView.builder(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var itemCount = todoItems.length;
        var message = '$itemCount ${itemCount == 1 ? 'ITEM' : 'ITEMS'}';

        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
            child: ListTile(
              subtitle: Text(
                "To Do List",
                style: TextStyle(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.left,
              ),
              title: Text(
                message,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
          );
        }
        // Have to reset index back to 0 since technically, because of the section title, the index is 1, which aint good broooo
        if (index - 1 < todoItems.length && index - 1 < priorityList.length) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: _buildTodoItem(
                todoItems[index - 1], priorityList[index - 1], index - 1),
          );
        }
      },
    );
  }

  void _removeTodoItemAndPriority(int index) {
    setState(() => todoItems.removeAt(index));
    setState(() => priorityList.removeAt(index));
  }

  void _promptRemoveTodoItem(int index) {
    var toDoItem = todoItems[index];

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  trailing: new Icon(Icons.edit),
                  title: new Text('Edit'), /// IMPORTANT
                  onTap: () {
                    edit = true; // Set edit mode to true
                    editIndex = index; // Store index of the selected cell
                    _showAddDialog();
                  }
                ),
                new ListTile(
                    trailing: new Icon(Icons.done),
                    title: new Text('Clear'),
                    onTap: () {
                      _removeTodoItemAndPriority(index);
                      saveList('savedToDoList', todoItems);
                      saveList('savedToDoPriorities', priorityList);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                    trailing: new Icon(Icons.arrow_forward),
                    title: new Text('Add to Current Hour Block'),
                    onTap: () {
                      setState(() {
                        cells[1] = toDoItem;
                      });
                      save(timeKeys[getCurrentHour() + 1], toDoItem);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  trailing: new Icon(Icons.cancel),
                  title: new Text('Cancel'),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTodoItem(String toDoText, String priority, int index) {
    return Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            new BoxShadow(
              color: Colors.black.withOpacity(0.075),
              blurRadius: 8,
            )
          ]),
      child: GestureDetector(
        onTap: () {
          _promptRemoveTodoItem(index);
        },
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        priority.toUpperCase(),
                        style: TextStyle(
                            fontSize: 14,
                            color: getPriorityColor(priority),
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        _capitalisedTitle(toDoText),
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//  _editDialog(BuildContext context, index) async {
////    var input = _placeHolder(todoItems[index]).text;
//
//    return showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            shape:
//                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//            title: new Text('What\'s on your to do list?'),
//            content: new Row(
//              children: <Widget>[
//                new Expanded(
//                  child: new TextField(
//                      cursorColor: primaryColor,
//                      autofocus: true,
////                      controller: _placeHolder(todoItems[index]),
////                      onChanged: (value) => input = value // Update the empty label array with the value they have entered
//                      ),
//                )
//              ],
//            ),
//            actions: <Widget>[
//              new FlatButton(
//                textColor: Colors.grey,
//                child: new Text("Close"),
//                onPressed: () {
//                  edit = false;
//                  Navigator.of(context).pop();
//                },
//              ),
//              new FlatButton(
//                textColor: primaryColor,
//                child: new Text("Add"),
//                onPressed: () {
////                  setState(() => todoItems[index] = input);
////                  setState(() => priorityList[index] = toDoPriority);
//                  print(todoItems);
//                  print(priorityList);
//                  Navigator.of(context).pop();
//                  Navigator.of(context).pop();
//
//                },
//              ),
//            ],
//          );
//        });
//  }

  void _showAddDialog() async {
    // this will contain the result from Navigator.pop(context, result)
    await showDialog<double>(
      // Waits for the result of the slider
      context: context,
      builder: (context) => AddDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _buildTodoList(),
        floatingActionButton: Padding(
          padding: EdgeInsets.all(16),
          child: new FloatingActionButton(
              onPressed: _showAddDialog,
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 4.0,
              child: new Icon(Icons.add)),
        ));
  }
}

//TextEditingController _placeHolder(cellValue) {
//  textController.text = cellValue;
//  return textController;
//}



String _capitalisedTitle(String title) {
  var capitalisedTitle = "";
  var words = title.split(" ");

  for (String word in words) {
    capitalisedTitle += _capitaliseWord(word);
    capitalisedTitle += " ";
  }

  capitalisedTitle = capitalisedTitle.substring(0, capitalisedTitle.length - 1);

  return capitalisedTitle;
}

String _capitaliseWord(String original) {
  if (original == null || original.length == 0) {
    return original;
  }
  return original.substring(0, 1).toUpperCase() + original.substring(1);
}

saveList(listName, listValues) async {
  final prefs = await SharedPreferences.getInstance();
  final key = listName;
  final value = listValues;
  prefs.setStringList(key, value);
}
