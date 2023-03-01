// To parse this JSON data, do
//
//     final notificationsToReadResponse = notificationsToReadResponseFromJson(jsonString);

import 'dart:convert';

NotificationsToReadResponse notificationsToReadResponseFromJson(String str) => NotificationsToReadResponse.fromJson(json.decode(str));

String notificationsToReadResponseToJson(NotificationsToReadResponse data) => json.encode(data.toJson());

class NotificationsToReadResponse {
  NotificationsToReadResponse({
    this.status,
    this.data,
  });

  int? status;
  Data? data;

  factory NotificationsToReadResponse.fromJson(Map<String, dynamic> json) => NotificationsToReadResponse(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.target,
    this.publishWays,
    this.id,
    this.title,
    this.description,
    this.type,
    this.data,
    this.publishDateTime,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.dataId,
  });

  Target? target;
  PublishWays? publishWays;
  String? id;
  String? title;
  String? description;
  String? type;
  String? data;
  DateTime? publishDateTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? dataId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    target: Target.fromJson(json["target"]),
    publishWays: PublishWays.fromJson(json["publishWays"]),
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    type: json["type"],
    data: json["data"],
    publishDateTime: DateTime.parse(json["publishDateTime"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    dataId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "target": target!.toJson(),
    "publishWays": publishWays!.toJson(),
    "_id": id,
    "title": title,
    "description": description,
    "type": type,
    "data": data,
    "publishDateTime": publishDateTime!.toIso8601String(),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "__v": v,
    "id": dataId,
  };
}

class PublishWays {
  PublishWays({
    this.inApp,
    this.push,
  });

  bool? inApp;
  bool? push;

  factory PublishWays.fromJson(Map<String, dynamic> json) => PublishWays(
    inApp: json["inApp"],
    push: json["push"],
  );

  Map<String, dynamic> toJson() => {
    "inApp": inApp,
    "push": push,
  };
}

class Target {
  Target({
    this.userIds,
  });

  List<UserId>? userIds;

  factory Target.fromJson(Map<String, dynamic> json) => Target(
    userIds: List<UserId>.from(json["userIds"].map((x) => UserId.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userIds": List<dynamic>.from(userIds!.map((x) => x.toJson())),
  };
}

class UserId {
  UserId({
    this.read,
    this.id,
    this.userIdId,
  });

  bool? read;
  String? id;
  String? userIdId;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    read: json["read"],
    id: json["_id"],
    userIdId: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "read": read,
    "_id": id,
    "id": userIdId,
  };
}
