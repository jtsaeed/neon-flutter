import 'package:intl/intl.dart'; // Time package

String getDate(index) {
  DateTime date = DateTime.now();
  var prevMonth = new DateTime(date.year, date.month, date.day + index);
  return DateFormat('EEE d MMM').format(prevMonth).toString();
}

int getCurrentHour() {
  DateTime getTime = DateTime.now();
  return getTime.hour - 1; // Rounding down basically, if time is 80:30, we want the 8PM Cell to be their
}

int getArrayLength() => 48 - getCurrentHour(); // Gets current amount of cells (From current time until tomorrows 23pm)


final time = <String>[];

String getHours(i) {
  int currentHour = getCurrentHour();

  while (currentHour < 48) {
    var y = currentHour + 1; // Store the actual count
    currentHour = currentHour % 24; // keep number between 0 & 24

    if (y > 24 && y < 37 && time.length != getArrayLength()) {
      currentHour = currentHour - 1 % 25; // keep number between 0 & 24
      currentHour == 0 ? currentHour = 12 : "";
      time.add(currentHour.toString() + 'AM');
    }
    else if (time.length != getArrayLength()) {
      time.add(currentHour.toString() + 'PM');
    }
    currentHour = y; // Reassign the count

  }
  return time[i];
}

