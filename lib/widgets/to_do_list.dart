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
      saveList('savedToDoList', todoItems);
      setState(() => todoItems.add(task));
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
                    title: new Text('Add to Current Hour Block'),
                    onTap: () {
                      setState(() {
                        cells[1] = toDoItem;
                      });
                      save(timeKeys[getCurrentHour() + 1], toDoItem);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                    trailing: new Icon(Icons.done),
                    title: new Text('Clear'),
                    onTap: () {
                      _removeTodoItem(index);
                      saveList('savedToDoList', todoItems);
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  trailing: new Icon(Icons.edit),
                  title: new Text('Edit'),
                  onTap: () => _displayDialog(context, index),
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
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        if (index < todoItems.length ?? 0) {
          return _buildTodoItem(todoItems[index], index);
        }
      },
    );
  }

  Widget _buildTodoItem(String toDoText, int index) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NO PRIORITY",
                        style: TextStyle(
                            fontSize: 14,
                            color: grayColor,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        toDoText,
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

  // Build a single todo item
  Widget _buildTodoItemOld(String todoText, int index) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  _displayDialog(BuildContext context, index) async {
    var input = '';

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: new Text(
                'What\'s on your to do list?'),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                      cursorColor: primaryColor,
                      autofocus: true,
                      decoration: new InputDecoration(hintText: cells[index]),
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
                  setState(() => todoItems[index] = input);
                },
              ),
            ],
          );
        });
  }

  Image addIcon = new Image.asset("resources/androidAdd@3x.png");

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildTodoList(),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16),
        child: new FloatingActionButton(
            onPressed: _pushAddTodoScreen,
            tooltip: 'Add To Do List item',
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 4.0,
            child: new Icon(Icons.add)),
      )
    );
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text('Add a new task'),
            backgroundColor: Colors.orange[800],
          ),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
              hintText: 'Enter something to do...',
              contentPadding: const EdgeInsets.all(16.0),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.orange[800]),
              ),
            ),
          ));
    }));
  }

  saveList(listName, listValues) async {
    final prefs = await SharedPreferences.getInstance();
    final key = listName;
    final value = listValues;
    prefs.setStringList(key, value);
  }
}
