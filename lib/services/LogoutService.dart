import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {

  Future deleteToken() async {

    var prefs = await SharedPreferences.getInstance();
    var tokenAtivo = (prefs.getString("authorization") ?? "");

    print("authorization : $tokenAtivo");

    var prefsDelete = await SharedPreferences.getInstance();
    var tokenRemovido = (prefsDelete.remove("authorization") ?? "");
    var emailRemovido = (prefsDelete.remove("login") ?? "");
    var idRemovido = (prefsDelete.remove("id") ?? "");

    print("tokenRemovido : $tokenRemovido");
    print("emailRemovido : $emailRemovido");
    print("idRemovido : $idRemovido");
  }
}

