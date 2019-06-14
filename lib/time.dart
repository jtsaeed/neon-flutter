import 'package:intl/intl.dart'; // Time package
import 'array.dart';



// Stores all the time annotations/labels
List<String> allTimeLabels = ['12AM', '1AM', '2AM', '3AM', '4AM', '5AM', '6AM', '7AM', '8AM', '9AM', '10AM', '11AM', '12PM',
  '1PM', '2PM', '3PM', '4PM', '5PM', '6PM', '7PM', '8PM', '9PM', '10PM', '11PM', 'TomorrowSection',
  '12AM', '1AM', '2AM', '3AM', '4AM', '5AM', '6AM', '7AM', '8AM', '9AM', '10AM', '11AM', '12PM',
  '1PM', '2PM', '3PM', '4PM', '5PM', '6PM', '7PM', '8PM', '9PM', '10PM', '11PM'];


String getDate(index) { // Gets date
  DateTime date = DateTime.now();
  var prevMonth = new DateTime(date.year, date.month, date.day + index); // Increment day
  return DateFormat('EEE d MMM').format(prevMonth).toString();
}


int getCurrentHour() => DateTime.now().hour  - 1; // Rounding down basically, if time is 80:30, we want the 8PM Cell to be their
int getArrayLength() => cells.length - 1 - getCurrentHour(); // Gets current amount of cells (From current time until tomorrows 23pm)

// Gets the hour labels
String getHours(index) => allTimeLabels[index + getCurrentHour()];


///Old code:...
//String getHours(index) {
//
//  if ((time[index + getCurrentHour()].length == 3)) { // 3 letter string
//    if (int.parse(time[index + getCurrentHour()].substring(0, 1)) > 24 &&
//        int.parse(time[index + getCurrentHour()].substring(0, 1)) < 37) {
//      int hour = index + getCurrentHour() - 24;
////      return time[hour] = time[hour] == '24AM' ? '12AM' : time[hour];
//      return time[hour] + '1';
//
//    }
//    else if (int.parse(time[index + getCurrentHour()].substring(0, 1)) >= 37 &&
//        int.parse(time[index + getCurrentHour()].substring(0, 1)) < 48) {
//      int x = index + getCurrentHour() - 24; // Getting the correct label based of index and currenttime
//      return time[x] + '2';
//    }
//  }
//  else { // 4 Letter string
//    if (int.parse(time[index + getCurrentHour()].substring(0, 2)) > 24 &&
//        int.parse(time[index + getCurrentHour()].substring(0, 2)) <= 37) {
//      int hour = index + getCurrentHour() - 24;
//      return time[hour] == '24AM' ? '12AM' : time[hour];
//    }
//    else if (int.parse(time[index + getCurrentHour()].substring(0, 2)) >= 37 &&
//        int.parse(time[index + getCurrentHour()].substring(0, 2)) < 48) {
//      int x = index + getCurrentHour() - 24;
//      return time[x];
//    }
//  }
////  return time[index + getCurrentHour()] == '24AM' ? '12AM' : time[index + getCurrentHour()];
//  return time[index + getCurrentHour()];



//  String getTomorrowSection(index) => time[index + getCurrentHour()];



//
//String getHours(index) {
//  // Gets the hour labels
//  int currentHour = getCurrentHour();
//
//  if (time.length != getArrayLength()) { // iI array is full then do not repeat
//
//    while (currentHour < 48) {
//      var y = currentHour + 1; // Store the actual count
//      currentHour = currentHour % 24; // keep number between 0 & 24
//      currentHour == 0 ? currentHour = 12 : print('');
//
//      if (y <= 12)
//        time.add(currentHour.toString() + 'AM');
//      else if (y > 24 && y < 37) {
//        currentHour -= 1;
//        currentHour == 0 ? currentHour = 12 : print('');
//        time.add(currentHour.toString() + 'AM');
//      }
//      else
//        time.add(
//            (currentHour - 12 == 0 ? 12 : currentHour - 12).toString() + 'PM');
//
//      currentHour = y; // Reassign the count
//    }
//  }
//  return time[index];
//}
//



//makeArray() {
//  print(cells.length);
//  if (time.length < cells.length) {
//
//    for (int i = 0; i < cells.length; i++) {
//
//      if (i <= 11) { // 0 - 12, 12am to 11am
//        time.add(i.toString() + 'AM');
//      }
//
//      else if (i >= 12 && i < 23) { // From 12PM to 11pm
//        var y = i;
//        time.add((y).toString() + 'PM');
//      }
//
//      else if (i == 24) {
//        time.add(i.toString() + 'TOMORROW');
//      }
//
//      else if (i >= 25 && i <= 37) {// var y = i % 24; // From 12am until 12AM
//        var y = i;
//        y == 0 ? y = 12 : print('');
//        time.add(y.toString() + 'AM');
//      }

//      else  {//        var y = i % 24;
//         if (i == 38) {
//           time.add((i).toString() + 'PM');
//         }
//        var y = i;
//        time.add((y).toString() + 'PM');
////        time.add((y - 12 == 0 ? 12 : y - 12).toString() + 'PM');
//
//      }
//    }
//  }
//  print(time);
//}
// -2 because we ignore the today and tomorrow section title
