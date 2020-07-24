import 'dart:convert';
import 'package:controle_financeiro_frontend/models/TipoDespesa.dart';
import 'package:http/http.dart' as http;

class TipoDespesaService {

  Future<List<TipoDespesa>> getTipoDespesas() async {

    http.Response response = await http.get(
        "http://localhost:8888/tipoDespesas");
    return decode(response);
  }

  List<TipoDespesa> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);

      List<TipoDespesa> tipoDespesa = decoded.map<TipoDespesa>((tipoDespesa) {
        return TipoDespesa.fromJson(tipoDespesa);
      }).toList();

      return tipoDespesa;
    }
  }
}