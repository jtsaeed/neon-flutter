import 'package:flutter/material.dart';
import '../cache_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../time.dart';
import '../palette.dart';
import 'add_to_do_item.dart';

List<String> todoItems = [];
List<String> priorityList = [];

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


  void _removeTodoItem(int index) {
    setState(() => todoItems.removeAt(index));
    setState(() => priorityList.removeAt(index));

  }

  void _promptRemoveTodoItem(int index) {
    var toDoItem = todoItems[index];
    var toDoPriority = priorityList[index];

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
                      saveList('savedToDoPriorities', priorityList);
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
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {

        var message = '';
        var itemCount = todoItems.length > 2 ? 'ITEMS' : 'ITEM'; // 1 item or 2
        itemCount = todoItems.length == 1 ? '' : itemCount; // If empty
        if (todoItems.length > 1) // If have 1 item, then display message
          message = '${todoItems.length - 1}  $itemCount';

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
                '$message // BETA 3',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
          );
        }
        if (index < todoItems.length && index < priorityList.length) {
          return _buildTodoItem(todoItems[index], priorityList[index], index);
        }
      },
    );
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
                        priority,
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
                  setState(() => todoItems[index] = input);
                  setState(() => priorityList[index] = input);
                  print(todoItems);
                  print(priorityList);
                  Navigator.of(context).pop();

                },
              ),
            ],
          );
        });
  }

  void _showAddDialog() async {
    // <-- note the async keyword here

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

saveList(listName, listValues) async {
  final prefs = await SharedPreferences.getInstance();
  final key = listName;
  final value = listValues;
  prefs.setStringList(key, value);
}
