
import 'package:easy_localization/easy_localization.dart';

String formatDate(String date){
  return DateFormat('MMMM-d-yyyy').format(DateTime.parse(date));
}
NumberFormat formatCurrency(String amount){
  return NumberFormat("#,##0.00", "en_US");
}