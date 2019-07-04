import 'package:flutter/material.dart';
import '../cache_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../time.dart';
import '../palette.dart';

List<String> todoItems = [];

toDoListMain() async {
  final prefs = await SharedPreferences.getInstance();
  todoItems = prefs.getStringList('savedToDoList');
  if (todoItems == null) {
    todoItems = [];
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  void _addTodoItem(String task) {
    if (task.length > 0) {
      setState(() => todoItems.add(task));
      saveList('savedToDoList', todoItems);
    }
  }

  void _removeTodoItem(int index) {
    setState(() => todoItems.removeAt(index));
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
                    trailing: new Icon(Icons.arrow_forward),
                    title: new Text('Assign to current hour blocks'),
                    onTap: () {
                      setState(() {
                        cells[1] = toDoItem;
                      });
                      save(timeKeys[getCurrentHour() + 1], toDoItem);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                    trailing: new Icon(Icons.done),
                    title: new Text('Mark "$toDoItem" as done?'),
                    onTap: () {
                      _removeTodoItem(index);
                      saveList('savedToDoList', todoItems);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  trailing: new Icon(Icons.edit),
                  title: new Text('Edit'),
                  onTap: () => _editDialog(context, index),
                ),
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

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < todoItems.length ?? 0) {
          return _buildTodoItem(todoItems[index], index);
        }
      },
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(String todoText, int index) {
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
        onTap: () => _promptRemoveTodoItem(index),
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      todoText,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  _editDialog(BuildContext context, index) async {
    var input = '';

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: new Text('What\'s on your to do list?'),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                      cursorColor: primaryColor,
                      autofocus: true,
                      decoration: new InputDecoration(hintText: cells[index]),
                      onChanged: (value) => input =
                          value // Update the empty label array with the value they have entered
                      ),
                )
              ],
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
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
                  setState(() => todoItems[index] = input);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.orange[800],
        title: new Text('Todo List'),
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          backgroundColor: Colors.orange[800],
          child: new Icon(Icons.add)),
    );
  }

  _pushAddTodoScreen() {
    // Push this page onto the stack
    String input = "";

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: new Text('What\'s on your to do list?'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                    cursorColor: Colors.orange,
                    autofocus: true,
                    decoration:
                        new InputDecoration(hintText: 'e.g. Revise maths'),
                    onChanged: (value) => input =
                        value // Update the empty label array with the value they have entered
                    ),
              )
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
                _addTodoItem(input);
              },
            ),
          ],
        );
      },
    );
  }

  saveList(listName, listValues) async {
    final prefs = await SharedPreferences.getInstance();
    final key = listName;
    final value = listValues;
    prefs.setStringList(key, value);
  }
}
