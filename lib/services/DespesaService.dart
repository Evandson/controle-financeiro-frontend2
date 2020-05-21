import 'dart:convert';
import 'package:controle_financeiro_frontend/models/TipoDespesa.dart';
import 'package:controle_financeiro_frontend/models/Despesa.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DespesaService {

  Future<List<Despesa>> getDespesas() async {

    var prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("authorization") ?? "");

    print("authorization : $token");

    var header = {
      "Content-Type": "application/json",
      "Authorization": "$token"
    };

    http.Response response = await http.get(
        "http://locahost:8888/despesas", headers: header);
    return decode(response);
  }

  List<Despesa> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);

      List<Despesa> despesa = decoded.map<Despesa>((despesa) {
        return Despesa.fromJson(despesa);
      }).toList();

      print(despesa);
      return despesa;
    }
  }
}