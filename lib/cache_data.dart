import 'package:shared_preferences/shared_preferences.dart';
import 'array.dart';
import 'time.dart';

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

bool runOnce = false;

loadArray(setState) async {

  print("loading array");
  print(cells);

  final prefs = await SharedPreferences.getInstance();
//  prefs.clear();

  if (runOnce == false) {
  Set<String> cachedKeys = prefs.getKeys();
  print('cached Keys: $cachedKeys');

  print('cache keys length: ${cachedKeys.length}');
//  print('Current keys in temp array ${keys.length}');

//  if (keys.length < cachedKeys.length) { // Load in the cache keys into this array

//    setState(() {
//      for (int i = 0; i < cachedKeys.length; i++) {
//        if (keys.contains(cachedKeys.elementAt(i)) == false) {
//          keys.add(cachedKeys.elementAt(i)); // Store cache element
//        }
////        cells[int.parse(keys[i])] = prefs.getString(keys.elementAt(i)); // Changing the array with values from the cache
////        removeOldKeys(prefs, i);
//      }
//    });


    setState(() {
      for (int k = 0; k < cachedKeys.length; k++) {

        for (int t = getCurrentHour(); t < time.length; t++) {
          removeOldKeys(t);

          if (cachedKeys.elementAt(k).toString() == time[t]) {
            cells[t - getCurrentHour()] = prefs.getString(cachedKeys.elementAt(k));
            print('With key: ${cachedKeys.elementAt(k)}, storing value:  ${prefs.getString(cachedKeys.elementAt(k))})');
          }
        }
      }
    });

    runOnce = true;
  }


  print('after loading');
  print(cells);
//  print('Keys in array: $keys');


}

final intTime = <int>[12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                       1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, // the second 12 is the tomorrow title
                      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
                      12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];



// Removing any cache data that is before the current time as it is not needed
removeOldKeys(i) async {

  final prefs = await SharedPreferences.getInstance();

  if ((intTime[i]) < getCurrentHour()) {

//    if (prefs.get(time[i + getCurrentHour()].toString().toString)) {
       prefs.remove(time[i - getCurrentHour()].toString()); // Remove key from cache
    }
//  }



  print('Keys are now: ${prefs.getKeys()}');


}

save(index, input) async { // each input with the index passed in (which cell the text should be in)
  final prefs = await SharedPreferences.getInstance();
  final key = index.toString();
  final value = input.toString();
  prefs.setString(key, value);
  print('saved $value with key: $key');
}