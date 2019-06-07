import "time.dart";
import 'cache_data.dart';
import 'package:shared_preferences/shared_preferences.dart';


//TODO: Make all 48 cells
//TODO: Filter cells

List<String> cells = List.filled(48, 'Empty');

int arrayLimit = 0;

//List<String> cells = [];
//List<String> cellsCached = [];
//int x = 0;
//
//void makeArray(setState) async {
//
//  read();
//
//    if (x < 47) {
//      print("Making array2");
//      for (int i = getCurrentHour(); i < 48; i++) {
//        cells.add('Empty');
//        x = i;
//      }
//    }
//
//  read();
//
//}
//
////read() async {
////  final prefs = await SharedPreferences.getInstance();
////  final key = 'allCells';
////  final value = prefs.getStringList(key) ?? 'Nothing';
////  cellsCached = value;
////  print('read: $value');
////  print("aaaa");
////  print(cellsCached);
////}
//
//
//
////read(index) async {
////  final prefs = await SharedPreferences.getInstance();
////  final key = index.toString();
////  final value = prefs.getString(key) ?? 'Empty';
////  print('Read: ---{ $value }---- At index: $index');
////  cells.add(value.toString());
////   cells.add(value);
////}
