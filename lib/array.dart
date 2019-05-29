import "time.dart";
import 'cache_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> cells = [];
List<String> cellsCached = [];
int x = 0;

void makeArray() {

  read(); // Doesnt do anything

  if (x < 47) {
    for (int i = getCurrentHour(); i < 48; i++) {
        cells.add('Empty');
        x = i;
    }
  }
  print("??? -- $cells");


  read();
//  print(cellsCached);

}

//read() async {
//  final prefs = await SharedPreferences.getInstance();
//  final key = 'allCells';
//  final value = prefs.getStringList(key) ?? 'Nothing';
//  cellsCached = value;
//  print('read: $value');
//  print("aaaa");
//  print(cellsCached);
//}



//read(index) async {
//  final prefs = await SharedPreferences.getInstance();
//  final key = index.toString();
//  final value = prefs.getString(key) ?? 'Empty';
//  print('Read: ---{ $value }---- At index: $index');
//  cells.add(value.toString());
//   cells.add(value);
//}
