import 'package:yucatan/generated/json/base/json_convert_content.dart';
import 'package:yucatan/generated/json/base/json_filed.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 40)
class UserModel with JsonConvert<UserModel> {
  @JSONField(name: "_id")
  @HiveField(0)
  String? sId;
  String? password;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? username;
  @HiveField(3)
  String? image;
  String? createdAt;
  String? updatedAt;
  @JSONField(name: "__v")
  @HiveField(4)
  int? iV;
}
