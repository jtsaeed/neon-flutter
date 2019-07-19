import 'package:intl/intl.dart'; // Time package
import 'cache_data.dart';

// Stores all the time annotations/labels
List<String> allTimeLabels = ['TodaySection', '12AM', '1AM', '2AM', '3AM', '4AM', '5AM', '6AM', '7AM', '8AM', '9AM', '10AM', '11AM', '12PM',
  '1PM', '2PM', '3PM', '4PM', '5PM', '6PM', '7PM', '8PM', '9PM', '10PM', '11PM', 'TomorrowSection', 'adsBanner',
  '12AM', '1AM', '2AM', '3AM', '4AM', '5AM', '6AM', '7AM', '8AM', '9AM', '10AM', '11AM', '12PM',
  '1PM', '2PM', '3PM', '4PM', '5PM', '6PM', '7PM', '8PM', '9PM', '10PM', '11PM', 'adsBanner']; // 52


String getDate(index) { // Gets date
  DateTime date = DateTime.now();
  var prevMonth = new DateTime(date.year, date.month, date.day + index); // Increment day
  return DateFormat('EEE d MMM').format(prevMonth).toString();
}


int getCurrentHour() => DateTime.now().hour; // Rounding down basically, if time is 80:30, we want the 8PM Cell to be their
int getArrayLength() => cells.length - getCurrentHour(); // Gets current amount of cells (From current time until tomorrows 23pm)

// Gets the hour labels
String getHours(index) => allTimeLabels[index + getCurrentHour()];

