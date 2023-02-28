import 'package:hive/hive.dart';

part 'schedule_notification.g.dart';

@HiveType(typeId: 23)
class ScheduleNotification {
  @HiveField(0)
  String id;

  @HiveField(1)
  String bookingTitle;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  int notificationId;

  ScheduleNotification(this.id, this.bookingTitle, this.dateTime,this.notificationId);
}
