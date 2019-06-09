import 'package:scheduled_notifications/scheduled_notifications.dart';
import 'array.dart';
import 'time.dart';

scheduleNotification(cellTime, minsToWait) async {
  int notificationId = await ScheduledNotifications.scheduleNotification(
      new DateTime.now().add(new Duration(minutes: minsToWait)).millisecondsSinceEpoch,
      "Ticker text",
      'Reminder for ${cells[cellTime]}',
      time[cellTime]);
}