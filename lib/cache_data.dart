import 'package:shared_preferences/shared_preferences.dart';
//import 'array.dart';
import 'main.dart';
//
//
//
void save(cells) async {
  print("trying to Saving!");
  final prefs = await SharedPreferences.getInstance(); // wait until done
  prefs.setStringList('cells', cells);
  print("Saving: $cells");
}

//void read() async {
//  print("trying to load!");
//  final prefs = await SharedPreferences.getInstance(); // Wait to find data
//  cells = prefs.getStringList('cells') ?? cells;
//  print("loadding $cells");
//}
//
//
////read() async {
////  final prefs = await SharedPreferences.getInstance();
////  final key = 'allCells';
////  final value = prefs.getStringList(key) ?? 'Nothing';
////  cells = value;
////  print('read: $value');
////}
//
////save(cells) async { // Save the whole array
////  print("Saving");
////  print(cells);
////  final prefs = await SharedPreferences.getInstance();
////  final key = 'allCells';
////  final value = cells;
//// prefs.setStringList(key, value);
////  print('saved $value');
////}
//
//
////read(index) async {
////  final prefs = await SharedPreferences.getInstance();
////  final key = index;
////  final value = prefs.getString(key) ?? 'Nothing';
////  print('read: $value');
////  return value;
////}
//
////save(index, input) async { // each input with the index passed in (which cell the text should be in)
////  print("Saving");
////  final prefs = await SharedPreferences.getInstance();
////  final key = index.toString();
////  final value = input.toString();
////  prefs.setString(key, value);
////  print('saved $value');
////}