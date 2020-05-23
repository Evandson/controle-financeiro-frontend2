import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {

  Future deleteToken() async {

    var prefs = await SharedPreferences.getInstance();
    var tokenAtivo = (prefs.getString("authorization") ?? "");

    print("authorization : $tokenAtivo");

    var prefsDelete = await SharedPreferences.getInstance();
    var tokenRemovido = (prefsDelete.remove("authorization") ?? "");

    print("authorization : $tokenRemovido");
  }
}

