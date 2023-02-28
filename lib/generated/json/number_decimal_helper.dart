import 'package:yucatan/generated/json/base/json_convert_content.dart';

class NumberDecimal with JsonConvert<NumberDecimal> {
  double? decimalValue;
}

numberDecimalFromJson(NumberDecimal data, Map<String, dynamic> json) {
  if (json['\$numberDecimal'] != null) {
    data.decimalValue = double.tryParse(json['\$numberDecimal'].toString());
  }
  return data;
}

Map<String, dynamic> numberDecimalToJson(NumberDecimal entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['\$numberDecimal'] = entity.decimalValue;
  return data;
}
