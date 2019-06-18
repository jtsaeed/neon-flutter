import 'package:scheduled_notifications/scheduled_notifications.dart';
import 'main.dart';
import 'time.dart';

scheduleNotification(cellTime, minsToWait) async {
  int notificationId = await ScheduledNotifications.scheduleNotification(
      new DateTime.now().add(new Duration(seconds: minsToWait)).millisecondsSinceEpoch,
      "Ticker text",
      'Reminder at ${allTimeLabels[cellTime + getCurrentHour()]}',
      cells[cellTime]);
}



