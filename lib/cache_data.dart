import 'package:shared_preferences/shared_preferences.dart';
import 'array.dart';
import 'time.dart';


List<int> timeKeys = [ // these are the keys for all the cells
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
  13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
  25, 26, 27, 28, 29, 30,31, 32, 33, 34, 35, 36,
  37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48
];

List<String> tempKeys = [];


bool runOnce = false; // Used to make loadArray run once

loadCells(setState) async {


  final prefs = await SharedPreferences.getInstance();
//  prefs.clear(); // Deletes all cache

  if (runOnce == false) {


    if (prefs.get('today') == getDate(0)) {
      print('Same day!');

      print('cached Keys: ${prefs.getKeys()}');
      print('cache keys length: ${prefs.getKeys().length}');
      print('CURRENT HOUR IS: ${getCurrentHour()}');

      setState(() {
        for (int k = 0; k < prefs.getKeys().length; k++) {
          for (int t = getCurrentHour(); t < timeKeys.length; t++) {
            var currentHour = (t == -1 ? 0 : t); // 24h is = -1, so change this 0

            if (timeKeys[currentHour].toString() == prefs.getKeys().elementAt(k).toString()) { // If the current hour matches a key
              cells[t - getCurrentHour()] = prefs.getString(prefs.getKeys().elementAt(k)); // Assign the keys value to the cells array
              print('With key: ${prefs.getKeys().elementAt(k)}, storing value:  ${prefs.getString(prefs.getKeys().elementAt(k))})');
            }
            else if (currentHour <= getCurrentHour()) // Removing any cache data that is before the current time as it is not needed
              prefs.remove(timeKeys[currentHour].toString());
          }
        }
      });
    }

    else { // Now we are in tomorrow, so tomorrows section cells needs to move into today's section

      print('different day');

      prefs.remove('today'); // Remove the date key, we reinitialise it after updating the keys

      print(prefs.getKeys().length);
      var cacheLength = prefs.getKeys().length;
      print(prefs.getKeys());
      var count = 0; // Stores the tempKeys array count, using prefs.getKeys.length is dynamic, count is static

      setState(() {

        for (int k = 0; k < cacheLength; k++) { // for every key

          if (int.parse(prefs.getKeys().elementAt(k)) >= 24 ) { // if the key value is above 24h, then we subtract it by 25 (don't ask)


            tempKeys.add(prefs.getKeys().elementAt(k)); // Gets the key
            print('Inside tempkeys: $tempKeys');
            print(int.parse(tempKeys[count]));

            int intKey = int.parse(tempKeys[count]); // convert to int
            prefs.remove(tempKeys[count]); // Remove old key

            intKey -= 25; // Go back 24 hours (25 due to rounding down)
            // ?? We do this as: (48 / 2 = 24), thus when this is ran again it divides again, 24/24 = 1, but should be really 23
//            intKey = intKey < 0 ? 1 : intKey;
//            intKey = intKey < 0 ? 23 : intKey;


            print('key was changed from ${tempKeys[count]} to $intKey, Storing: ${prefs.getString((prefs.getKeys().elementAt(k)))} with key: $intKey');

            prefs.setString(intKey.toString(), prefs.getString((prefs.getKeys().elementAt(k)))); // store old value with new key
            cells[intKey - getCurrentHour()] =  prefs.getString((prefs.getKeys().elementAt(k))); // Update cell array with new key & old value

            count += 1;


          }
        }

//        for (int k = 0; k < prefs.getKeys().length - 1; k++) { // for every key
//          prefs.remove(tempKeys[k]); // Remove old key
//        }

        saveDate('today'); // Save the current data, as this is the today section now

      });
    }
    runOnce = true;
  }

  print('cache keys length: ${prefs.getKeys().length}');
  print('Keys are now: ${prefs.getKeys()}');
  print('after loading');
  print(cells);
}



save(index, input) async { // each input with the index passed in (which cell the text should be in)
  final prefs = await SharedPreferences.getInstance();
  final key = index.toString();
  final value = input.toString();
  prefs.setString(key, value);
  print('saved $value with key: $key');
}

saveDate(passedInKey) async { // Saving the data with a key called 'today'
  final prefs = await SharedPreferences.getInstance();
  final key = passedInKey;
  final value = getDate(0); // Save current date
  prefs.setString(key, value);
  print('saved $value with key: $key');
}