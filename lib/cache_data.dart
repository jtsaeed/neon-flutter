import 'package:shared_preferences/shared_preferences.dart';
import 'array.dart';
import 'main.dart';

List<String> cellsCached2 = ["Nothing"];


void save(cells) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList('cells', cells);
  print("Saving: $cells");
}

void read() async {
  final prefs = await SharedPreferences.getInstance(); // Wait to find data
  final xx = prefs.getStringList('cells') ?? cellsCached2;
  cells = xx;
  print("loadding $cells");
}


//read() async {
//  final prefs = await SharedPreferences.getInstance();
//  final key = 'allCells';
//  final value = prefs.getStringList(key) ?? 'Nothing';
//  cells = value;
//  print('read: $value');
//}

//save(cells) async { // Save the whole array
//  print("Saving");
//  print(cells);
//  final prefs = await SharedPreferences.getInstance();
//  final key = 'allCells';
//  final value = cells;
// prefs.setStringList(key, value);
//  print('saved $value');
//}


//read(index) async {
//  final prefs = await SharedPreferences.getInstance();
//  final key = index;
//  final value = prefs.getString(key) ?? 'Nothing';
//  print('read: $value');
//  return value;
//}

//save(index, input) async { // each input with the index passed in (which cell the text should be in)
//  print("Saving");
//  final prefs = await SharedPreferences.getInstance();
//  final key = index.toString();
//  final value = input.toString();
//  prefs.setString(key, value);
//  print('saved $value');
//}