import 'package:hive/hive.dart';

part 'local_search_model.g.dart';

@HiveType(typeId: 102)
class LocalSearchModel {
  @HiveField(0)
  int? index;

  @HiveField(1)
  String? query;

  @HiveField(2)
  DateTime? dateTime;
}
