import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:waterreminder/api/facebook_api.dart';
import 'package:waterreminder/model/usuario.dart';

class UsuarioBloc extends BlocBase {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
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

  Future<Usuario> buscarUsuarioId(String id) async {
    Query query = _database
        .reference()
        .child("usuario")
        .orderByChild("facebookId")
        .equalTo(id);

    DataSnapshot snapshot = await query.once();
    if (snapshot.value != null) {
      final map = Map.from(snapshot.value);
      final userKey = map.keys.first;
      Map usuario = Map<String, dynamic>.from(map.values.first);
      return Usuario.fromJson(userKey, usuario);
    }
    return null;
  }

  Future<Usuario> insereUsuario(Usuario usuario) async {
    final reference = _database.reference().child("usuario").push();
    await reference.set(usuario.toJson());
    usuario.key = reference.key;
    return usuario;
  }

  Future<void> atualizaUsuario(Usuario usuario) async {
    await _database
        .reference()
        .child("usuario")
        .child(usuario.key)
        .set(usuario.toJson());
  }

  Future<Usuario> sincronizarUsuarioFirebase(Usuario usuario) async {
    Usuario usuarioExistente =
        await buscarUsuarioId(usuario.facebookId);

    if (usuarioExistente == null) {
      return await insereUsuario(usuario);
    } else {
      usuario.key = usuarioExistente.key;
      await atualizaUsuario(usuario);
      return usuario;
    }
  }

  @override
  void dispose() {
    _usuarioContoller.close();
    super.dispose();
  }
}
