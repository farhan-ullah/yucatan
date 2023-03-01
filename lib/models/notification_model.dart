import 'dart:convert';

class NotificationModel {
  String? id;
  String? title;
  String? description;
  String? descriptionSubject;
  NotificationType? type;
  NotificationTarget? target;
  NotificationPublishWay? publishWays;
  String? data;
  DateTime? publishDateTime;
  bool opened = false;

  NotificationModel({
    this.id,
    this.title,
    this.description,
    this.descriptionSubject,
    this.type,
    this.target,
    this.publishWays,
    this.data,
    this.publishDateTime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      descriptionSubject: json['descriptionSubject'],
      type: NotificationType.values.firstWhere(
        (element) => element.toString().split('.')[1].toLowerCase() == json['type'].toString().toLowerCase(),
        orElse: () => NotificationType.SYSTEM,
      ),
      target: json['target'] != null ? NotificationTarget.fromJson(json['target']) : null,
      publishWays: NotificationPublishWay.fromJson(json['publishWays']),
      data: json['data'],
      publishDateTime: DateTime.tryParse(json['publishDateTime']),
    );
  }
}

class NotificationPublishWay {
  bool? inApp;
  bool? push;

  NotificationPublishWay({
    this.inApp,
    this.push,
  });

  factory NotificationPublishWay.fromJson(Map<String, dynamic> json) {
    return NotificationPublishWay(
      inApp: json['inApp'],
      push: json['push'],
    );
  }
}

class NotificationData {
  String? action;
  dynamic? data;

  NotificationData({
    this.action,
    this.data,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      action: json['action'],
      data: json['data'],
    );
  }
}

class NotificationTarget {
  String? id;
  NotificationTopic? topic;
  List<NotificationUserId>? userIds;

  NotificationTarget({
    this.id,
    this.topic,
    this.userIds,
  });

  factory NotificationTarget.fromJson(Map<String, dynamic> json) {
    return NotificationTarget(
      id: json['_id'],
      topic: NotificationTopic.values.firstWhere(
        (element) => element.toString().toLowerCase() == json['topic'].toString().toLowerCase(),
        orElse: () => NotificationTopic.SYSTEM,
      ),
      userIds: json['userIds'] != null
          ? json['userIds']
              .map<NotificationUserId>(
                (element) => NotificationUserId.fromJson(element),
              )
              .toList()
          : [],
    );
  }
}

class NotificationUserId {
  String? id;
  String? userId;
  bool? read;

  NotificationUserId({
    this.id,
    this.userId,
    this.read,
  });

  factory NotificationUserId.fromJson(Map<String, dynamic> json) {
    return NotificationUserId(
      id: json['_id'],
      userId: json['id'],
      read: json['read'],
    );
  }
}

class SavedNotificationData {
  String? notificationId;
  String? userId;
  bool? read;

  SavedNotificationData({
    this.notificationId,
    this.userId,
    this.read,
  });

  factory SavedNotificationData.fromJson(Map<String, dynamic> jsonData) {
    return SavedNotificationData(
      notificationId: jsonData['notificationId'],
      userId: jsonData['userId'],
      read: jsonData['read'],
    );
  }

  static Map<String, dynamic> toMap(SavedNotificationData savedNotificationData) => {
        'notificationId': savedNotificationData.notificationId,
        'userId': savedNotificationData.userId,
        'read': savedNotificationData.read,
      };

  static String encode(List<SavedNotificationData> savedNotificationData) => json.encode(
        savedNotificationData.map<Map<String, dynamic>>((savedNotificationData) => SavedNotificationData.toMap(savedNotificationData)).toList(),
      );

  static List<SavedNotificationData> decode(String savedNotificationData) =>
      (json.decode(savedNotificationData) as List<dynamic>).map<SavedNotificationData>((item) => SavedNotificationData.fromJson(item)).toList();
}

enum NotificationType {
  REQUEST,
  CANCELLATION,
  BOOOKING,
  SYSTEM,
}

enum NotificationTopic {
  SYSTEM,
}
