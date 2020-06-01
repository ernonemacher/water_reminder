import 'package:http/http.dart';

class FacebookApi {
  static Future<String> buscaDadosUsuario(String token) async {
    final response = await get(
        "https://graph.facebook.com/v2.12/me?fields=name,picture.width(200)&access_token=$token");
    if(response.statusCode == 200) {
      return response.body;
    }
    throw "Falhou ao buscar dados do usuario";
  }
}
