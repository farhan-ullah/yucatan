import 'package:yucatan/models/user_model.dart';

userModelFromJson(UserModel data, Map<String, dynamic> json) {
  if (json['_id'] != null) {
    data.sId = json['_id'].toString();
  }
  if (json['password'] != null) {
    data.password = json['password'].toString();
  }
  if (json['email'] != null) {
    data.email = json['email'].toString();
  }
  if (json['username'] != null) {
    data.username = json['username'].toString();
  }
  if (json['image'] != null) {
    data.image = json['image'].toString();
  }
  if (json['createdAt'] != null) {
    data.createdAt = json['createdAt'].toString();
  }
  if (json['updatedAt'] != null) {
    data.updatedAt = json['updatedAt'].toString();
  }
  if (json['__v'] != null) {
    data.iV = json['__v'].toInt();
  }
  return data;
}

Map<String, dynamic> userModelToJson(UserModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['_id'] = entity.sId;
  data['password'] = entity.password;
  data['email'] = entity.email;
  data['username'] = entity.username;
  data['image'] = entity.image;
  data['createdAt'] = entity.createdAt;
  data['updatedAt'] = entity.updatedAt;
  data['__v'] = entity.iV;
  return data;
}
