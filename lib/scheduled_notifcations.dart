import 'package:scheduled_notifications/scheduled_notifications.dart';
import 'time.dart';
import 'cache_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

scheduleNotification(cellTime, minsToWait) async {
  int notificationId = await ScheduledNotifications.scheduleNotification(
      new DateTime.now().add(new Duration(microseconds: minsToWait)).millisecondsSinceEpoch,
      "Ticker text",
      'Reminder at ${allTimeLabels[cellTime + getCurrentHour()]}',
      cells[cellTime]);
}
