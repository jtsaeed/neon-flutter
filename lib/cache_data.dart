import 'package:shared_preferences/shared_preferences.dart';
import 'time.dart';
import 'load_calendar.dart';
import 'widgets/settings_page.dart';
import 'dart:convert';

List<String> cells = List.filled(50, 'Empty');

List<int> timeKeys = [
  // these are the keys for all the cells
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
  13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
  25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36,
  37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48
];
List<String> tempKeys =
    []; // When the day changes, we want to update all the tomorrow cell keys and convert them into today
bool runOnce = false; // Used to make loadArray run once

var startHour = 0;

loadCalendar(setState) async {
  if (runOnce == false) {
    if (todayCalendarEvents != null) {

      for (int i = 0; i < todayCalEvents.length; i++) {
        for (int e = 0; e < todayCalEvents[i].length; e++) {

          print('Today $i ${todayCalEvents[i][e].title}');

          for (int h = getCurrentHour(); h < timeKeys.length; h++) {

           if (h == todayCalEvents[i][e].start.hour) {
             startHour = todayCalEvents[i][e].start.hour;

             if (tomorrowCalEvents[i][e].title != tomorrowTitle &&
                 tomorrowCalEvents[i][e].title != todayTitle) {
                 setState(() {
                   print('updating:');
                   cells[startHour - getCurrentHour()] =
                       todayCalEvents[i][e].title;
                   save(timeKeys[startHour], todayCalEvents[i][e].title);
                 });


               if (h + 1 == todayCalEvents[i][e].end.hour) {
                 print('skip!');
               } else {
                 while (startHour < todayCalEvents[i][e].end.hour - 1) {
                   // Dont use the ending hour for a cell, so subtract 1
                   startHour++;
                   cells[startHour - getCurrentHour()] =
                       todayCalEvents[i][e].title;
                   save(timeKeys[startHour], todayCalEvents[i][e].title);
                 }
               }
             }
           }
            startHour = 0;
          }
        }
      }
    }
  }
}

loadCalendarTomorrow(setState) async {
  if (runOnce == false) {
    if (tomorrowCalendarEvents != null) {

      for (int i = 0; i < tomorrowCalEvents.length; i++) {
        for (int e = 0; e < tomorrowCalEvents[i].length; e++) {

          print('tomorrow $i ${tomorrowCalEvents[i][e].title}');


            for (int h = 0; h < timeKeys.length; h++) {
              if (h == tomorrowCalEvents[i][e].start.hour) {
                startHour = tomorrowCalEvents[i][e].start.hour;

                if (tomorrowCalEvents[i][e].title != tomorrowTitle && tomorrowCalEvents[i][e].title != todayTitle) {
                  setState(() {
                    print('in tomorrow: updating: ${tomorrowCalEvents[i][e].title}');
                    cells[startHour - getCurrentHour() + 25] =
                        tomorrowCalEvents[i][e].title;
                    save(timeKeys[startHour + 25],
                        tomorrowCalEvents[i][e].title);
                  });


                  if (h + 1 == tomorrowCalEvents[i][e].end.hour) {
                    print('skip!');
                  } else {
                    while (startHour < tomorrowCalEvents[i][e].end.hour - 1) {
                      // Dont use the ending hour for a cell, so subtract 1
                      startHour++;
                      cells[startHour - getCurrentHour() + 25] =
                          tomorrowCalEvents[i][e].title;
                      save(timeKeys[startHour + 25],
                          tomorrowCalEvents[i][e].title);
                    }
                  }
                }
              }
            startHour = 0;
          }
        }
      }
    }
  }
}



loadCalendarPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('calendarPrefs') == true)
    calendarMap = json
        .decode(prefs.getString('calendarPrefs')); // convert string back to map
}

loadCells(setState) async {
  final prefs = await SharedPreferences.getInstance();
//prefs.clear();  // Deletes all cache

  if (runOnce == false) {
    // Run once
    print('load cells');

    if (prefs.get('date') == getDate(0)) {
      // Compare cache date to current date, if same then we are still in the same today section AND DO NOT need to update keys

      print('Same day!');
      print('cached Keys: ${prefs.getKeys()}');
      print('CURRENT HOUR IS: ${getCurrentHour()}');

      var cacheKeys = List.from(prefs.getKeys());

      for (int k = 0; k < cacheKeys.length; k++) {
        for (int currentHour = getCurrentHour();
            currentHour < timeKeys.length;
            currentHour++) {
          currentHour = currentHour == -1 ? 0 : currentHour;

          setState(() {
            if (timeKeys[currentHour].toString() ==
                cacheKeys.elementAt(k).toString()) {
              // If the current hour matches a key from cache
              cells[currentHour - getCurrentHour()] = prefs.getString(cacheKeys
                  .elementAt(k)); // Assign the key's value to the cells array
              print(
                  'With key: ${cacheKeys.elementAt(k)}, storing value:  ${prefs.getString(cacheKeys.elementAt(k))})');
            }
          });
        }
      }
      for (int currentHour = 0; currentHour < timeKeys.length; currentHour++) {
        if (currentHour <=
            getCurrentHour()) // Removing any cache keys that is before the current time as it is not needed anymore
          prefs.remove(timeKeys[currentHour].toString());
      }
    } else if (prefs.get('date') == getDate(-1)) {
      // Now we are in tomorrow, so tomorrows section cells needs to move into today's section
      print('different day');
      prefs.remove(
          'date'); // Remove the date key as it is for the previous date, we reinitialise it after updating the keys with the current date

      print(prefs.getKeys().length);
      print(prefs.getKeys());
      var count =
          0; // Stores the tempKeys array count, using prefs.getKeys.length is dynamic, count is static

      prefs.remove('23');

      var cacheKeys = List.from(prefs.getKeys());

      for (int k = 0; k < cacheKeys.length; k++) {
        // for every key in cache

        if (int.parse(cacheKeys.elementAt(k)) >= 24) {
          // if the key value is above 24h, then we subtract it by 25 (don't ask)

          tempKeys.add(cacheKeys.elementAt(k)); // temporary stores the key

          print('Inside tempkeys: $tempKeys');
          print(tempKeys[count]);

          int intKey = int.parse(tempKeys[count]); // convert key to Int
          intKey -=
              25; // Go back 24 hours (tomorrow section counts as a day, so need to subtract 25, not 24)

          print(
              'key was changed from ${tempKeys[count]} to $intKey, Storing: ${prefs.getString(cacheKeys.elementAt(k))} with key: $intKey');
          prefs.setString(
              intKey.toString(),
              prefs.getString(
                  (cacheKeys.elementAt(k)))); // store old value with new key

          setState(() {
            cells[intKey - getCurrentHour()] = prefs.getString(cacheKeys
                .elementAt(k)); // Update cell array with new key & old value
          });

          prefs.remove(cacheKeys.elementAt(k)); // Remove old key
          count += 1;
        }
      }
      saveDate(); // Save the current data, as this is the today section now

    } else {
      // If the  cached date is equal to the date from 2 days ago or more, then clear cache
      print('Havent been active for 2days!');
      prefs.clear();
      saveDate(); // Save the current data, as this is the today section now

    }
    runOnce = true;
  }
  print('cache keys length: ${prefs.getKeys().length}');
  print('Keys are now: ${prefs.getKeys()}');
  print('after loading');
  print(cells);
}

save(index, input) async {
  // each input with the index passed in (which cell the text should be in)
  final prefs = await SharedPreferences.getInstance();
  final key = index.toString();
  final value = input.toString();
  prefs.setString(key, value);
  print('saved $value with key: $key');
}

saveList(index, arrayValue) async {
  final prefs = await SharedPreferences.getInstance();
  final key = index.toString();
  final value = arrayValue;
  prefs.setBool(key, value);
  print('saved $value with key: $key');
}

saveDate() async {
  // Saving the data with a key called 'today'
  final prefs = await SharedPreferences.getInstance();
  final key = 'date';
  final value = getDate(0).toString(); // Save current date
  prefs.setString(key, value);
  print('saved $value with key: $key');
}
