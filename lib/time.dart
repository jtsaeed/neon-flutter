import 'package:intl/intl.dart'; // Time package

String getDate(index) { // Gets date
  DateTime date = DateTime.now();
  var prevMonth = new DateTime(date.year, date.month, date.day + index);
  return DateFormat('EEE d MMM').format(prevMonth).toString();
}

int getCurrentHour() => DateTime.now().hour - 1; // Rounding down basically, if time is 80:30, we want the 8PM Cell to be their
int getArrayLength() => 48 - getCurrentHour(); // Gets current amount of cells (From current time until tomorrows 23pm)

final time = <String>[];

String getHours(index) { // Gets the hour labels
  int currentHour = getCurrentHour();

  if  (time.length != getArrayLength()) { // iI array is full then do not repeat

    while (currentHour < 48) {
      var y = currentHour + 1; // Store the actual count
      currentHour = currentHour % 24; // keep number between 0 & 24
      currentHour == 0 ? currentHour = 12 : print('');

      if (y <= 12) {
        time.add(currentHour.toString() + 'AM');
      }
      else if (y > 24 && y < 37) {
          currentHour -= 1;
          currentHour == 0 ? currentHour = 12 : print('');
          time.add(currentHour.toString() + 'AM');
      }

      else
        time.add(currentHour.toString() + 'PM');


      currentHour = y; // Reassign the count
    }
  }
  return time[index];
}

