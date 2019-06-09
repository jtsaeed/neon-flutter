import 'package:shared_preferences/shared_preferences.dart';
import 'array.dart';
import 'main.dart';
//
//
//
//save(cells) async {
//  print("trying to Saving!");
//  final prefs = await SharedPreferences.getInstance(); // wait until done
//  prefs.setStringList('cells2', cells);
//  print("Saving: $cells");
//}

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


//read(index) async {
//  final prefs = await SharedPreferences.getInstance();
//  final key = index;
//  final value = prefs.getString(key) ?? 'Nothing';
//  print('read: $value with key: $key');
//  return value;
//}

List<String> keys = [];


loadArray(setState) async {

  print("loading array");
  print(cells);

  final prefs = await SharedPreferences.getInstance();
  prefs.clear();

  Set<String> cachedKeys = prefs.getKeys();
  print('Keys: $cachedKeys');


  print(cachedKeys.length);
  print(keys.length);

  if (keys.length < cachedKeys.length) {
    setState(() {
      for (int i = 0; i < cachedKeys.length; i++) {
        keys.add(cachedKeys.elementAt(i));
        cells[int.parse(keys[i])] = prefs.getString(keys.elementAt(i)); // Changing the array with values from the cache
       }
    });
  }
  print(cells);
  print('Keys: $keys');

}

save(index, input) async { // each input with the index passed in (which cell the text should be in)
  print("Saving");
  final prefs = await SharedPreferences.getInstance();
  final key = index.toString();
  final value = input.toString();
  prefs.setString(key, value);
  print('saved $value with key: $key');
}