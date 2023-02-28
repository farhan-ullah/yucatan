import 'package:yucatan/utils/StringUtils.dart';
import 'package:intl/intl.dart';

String formatPriceDouble(double price) {
  if (price == null) return 'NaN';
  return price.toStringAsFixed(2).replaceFirst('.', ',');
}

String formatPriceDoubleWithCurrency(double price) {
  if (price == null) return 'NaN';
  var nf =
      NumberFormat.simpleCurrency(name: "EUR", decimalDigits: 2, locale: "de");

  return nf.format(price);
}

String formatInteger(num number) {
  var nf = NumberFormat.decimalPattern("de");
  nf.maximumFractionDigits = 0;
  return nf.format(number);
}

String formatPriceString(String price) {
  if (!isNotNullOrEmpty(price)) return 'NaN';
  return double.parse(price).toStringAsFixed(2).replaceFirst('.', ',');
}
