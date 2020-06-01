import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:waterreminder/api/facebook_api.dart';
import 'package:waterreminder/model/usuario.dart';

class UsuarioBloc extends BlocBase {
  final _usuarioContoller = BehaviorSubject<Usuario>();
  ValueStream<Usuario> get usuarioStream => _usuarioContoller.stream;
  Future<Usuario> buscarDadosUsuarioFacebook(String token) async {
    String json = await FacebookApi.buscaDadosUsuario(token);

    if (json == null) {
      return null;
    }

    Map dadosFacebook = Map.from(jsonDecode(json));
    final usuario = Usuario();
    usuario.facebookId = dadosFacebook["id"];
    usuario.nome = dadosFacebook["name"];
    usuario.urlFoto = dadosFacebook["picture"]["data"]["url"];

    _usuarioContoller.sink.add(usuario);

    return usuario;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _usuarioContoller.close();
    super.dispose();
  }
}
