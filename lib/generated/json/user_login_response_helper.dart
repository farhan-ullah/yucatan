import 'package:yucatan/services/response/api_error.dart';
import 'package:yucatan/services/response/user_login_response.dart';

userLoginResponseFromJson(UserLoginResponse data, Map<String, dynamic> json) {
  if (json['status'] != null) {
    data.status = json['status'].toInt();
  }
  if (json['data'] != null) {
    data.data = new UserLoginResponseData().fromJson(json['data']);
  }
  if (json['errors'] != null) {
    data.errors = new ApiError().fromJson(json['errors']);
  }
  return data;
}

Map<String, dynamic> userLoginResponseToJson(UserLoginResponse entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['status'] = entity.status;
  if (entity.data != null) {
    data['data'] = entity.data!.toJson();
  }
  if (entity.errors != null) {
    data['errors'] = entity.errors!.toJson();
  }
  return data;
}

userLoginResponseDataFromJson(
    UserLoginResponseData data, Map<String, dynamic> json) {
  if (json['token'] != null) {
    data.token = json['token'].toString();
  }
  if (json['user'] != null) {
    data.user = new UserLoginModel().fromJson(json['user']);
  }
  return data;
}

Map<String, dynamic> userLoginResponseDataToJson(UserLoginResponseData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['token'] = entity.token;
  if (entity.user != null) {
    data['user'] = entity.user.toJson();
  }
  return data;
}

userLoginModelFromJson(UserLoginModel data, Map<String, dynamic> json) {
  if (json['_id'] != null) {
    data.sId = json['_id'].toString();
  }
  if (json['refreshToken'] != null) {
    data.refreshToken = json['refreshToken'].toString();
  }
  if (json['email'] != null) {
    data.email = json['email'].toString();
  }
  if (json['role'] != null) {
    data.role = json['role'].toString();
  }

  if (json['username'] != null) {
    data.username = json['username'].toString();
  }
  if (json['firstname'] != null) {
    data.firstname = json['firstname'].toString();
  }
  if (json['lastname'] != null) {
    data.lastname = json['lastname'].toString();
  }
  if (json['phone'] != null) {
    data.phone = json['phone'].toString();
  }
  if (json['street'] != null) {
    data.street = json['street'].toString();
  }
  if (json['housenumber'] != null) {
    data.housenumber = json['housenumber'].toString();
  }
  if (json['zipcode'] != null) {
    data.zipcode = json['zipcode'].toString();
  }
  if (json['city'] != null) {
    data.city = json['city'].toString();
  }

  if (json['countryISO2'] != null) {
    data.countryISO2 = json['countryISO2'].toString();
  }
  if (json['areaCode'] != null) {
    data.areaCode = json['areaCode'].toString();
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

Map<String, dynamic> userLoginModelToJson(UserLoginModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['_id'] = entity.sId;
  data['refreshToken'] = entity.refreshToken;
  data['email'] = entity.email;
  data['role'] = entity.role;

  data['countryISO2'] = entity.countryISO2;
  data['areaCode'] = entity.areaCode;

  data['username'] = entity.username;
  data['firstname'] = entity.firstname;
  data['lastname'] = entity.lastname;
  data['phone'] = entity.phone;
  data['street'] = entity.street;
  data['housenumber'] = entity.housenumber;
  data['zipcode'] = entity.zipcode;
  data['city'] = entity.city;

  data['createdAt'] = entity.createdAt;
  data['updatedAt'] = entity.updatedAt;
  data['__v'] = entity.iV;
  return data;
}
