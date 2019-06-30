import 'package:flutter/material.dart';
import '../cache_data.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../time.dart';

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
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return new AlertDialog(
                    title: new Text('Mark "${todoItems[index]}" as done?'),
                    actions: <Widget>[
                        new FlatButton(
                            child: new Text('CANCEL'),
                            onPressed: () => Navigator.of(context).pop()),
                        new FlatButton(
                            child: new Text('MARK AS DONE'),
                            onPressed: () {
                                _removeTodoItem(index);
                                Navigator.of(context).pop();
                            }),
                        new FlatButton(
                            child: new Text('Assign to current hour blocks'),
                            onPressed: () {
                                setState(() {
                                    cells[1] = todoItems[index];
                                    save(timeKeys[getCurrentHour() + 1], todoItems[index]);
                                    new TableView();
                                });
                                Navigator.of(context).pop();
                            })
                    ]);
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
        return new ListTile(
            title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index));
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