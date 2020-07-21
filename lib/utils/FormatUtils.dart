import 'package:intl/intl.dart';

formatNumero(double n){

  var f2 = NumberFormat("#,##0.00", "pt_BR");

  String numeroFormatado = f2.format(n);

  return numeroFormatado;

}