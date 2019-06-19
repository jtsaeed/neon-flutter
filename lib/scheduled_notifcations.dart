import 'time.dart';
import 'cache_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';


showNotification(cellTime, minsToWait) async {
  print('set Reminder:' );

  var scheduledNotificationDateTime = new DateTime.now().add(new Duration(minutes: minsToWait));

  var androidPlatformChannelSpecifics =
  new AndroidNotificationDetails('your other channel id',
      'your other channel name', 'your other channel description');
  var iOSPlatformChannelSpecifics =
  new IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(
      0,
      'Reminder at ${allTimeLabels[cellTime + getCurrentHour()]}',
      cells[cellTime],
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}
