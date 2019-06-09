import 'package:intl/intl.dart'; // Time package

final time = <String>[]; // Stores all the time annotations


String getDate(index) { // Gets date
  DateTime date = DateTime.now();
  var prevMonth = new DateTime(date.year, date.month, date.day + index); // Increment day
  return DateFormat('EEE d MMM').format(prevMonth).toString();
}

int getCurrentHour() => DateTime.now().hour - 1; // Rounding down basically, if time is 80:30, we want the 8PM Cell to be their
int getArrayLength() => time.length - getCurrentHour(); // Gets current amount of cells (From current time until tomorrows 23pm)


makeArray() {
  if (time.length < 47) {
    for (int i = 0; i < 48; i++) {
      if (i <= 12) {
        time.add(i.toString() + 'AM');
      }
      else if (i > 24 && i < 37) {
        var y = i % 24;
        y -= 1;
        y == 0 ? y = 12 : print('');
        time.add(y.toString() + 'AM');
      }
      else {
        var y = i % 24;
        time.add((y-12).toString() + 'PM');
      }
    }
  }
}
// Gets the hour labels
String getHours(index) => time[index];





//String getHours(index) { // Gets the hour labels
//  int currentHour = getCurrentHour();
//
//  if  (time.length != getArrayLength()) { // iI array is full then do not repeat
//
//    while (currentHour < 48) {
//      var y = currentHour + 1; // Store the actual count
//      currentHour = currentHour % 24; // keep number between 0 & 24
//      currentHour == 0 ? currentHour = 12 : print('');
//
//      if (y <= 12)
//        time.add(currentHour.toString() + 'AM');
//
//      else if (y > 24 && y < 37) {
//          currentHour -= 1;
//          currentHour == 0 ? currentHour = 12 : print('');
//          time.add(currentHour.toString() + 'AM');
//      }
//      else
//        time.add((currentHour - 12 == 0 ? 12 : currentHour - 12).toString() + 'PM');
//
//      currentHour = y; // Reassign the count
//    }
//  }
//  return time[index];
//}
