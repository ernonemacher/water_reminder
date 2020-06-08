import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rxdart/rxdart.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/config/config_rotas.dart';
import 'package:waterreminder/model/usuario.dart';

class AcessoBloc extends BlocBase {
  final _facebookLogin = FacebookLogin();
  final AcessoController = BehaviorSubject<FacebookLoginStatus>();

  ValueStream<FacebookLoginStatus> get AcessoStream => AcessoController.stream;

  Future<String> validaAcesso() async {
    return Future.delayed(Duration(seconds: 1), () async {
      print("antes");
      bool usuarioLogado = await _facebookLogin.isLoggedIn;
      print("durante");
      if (usuarioLogado) {
        print("depois");

        await _carregarUsuario();

        return ConfigRotas.HOME;
      } else {
        print("depois");
        return ConfigRotas.BOAS_VINDAS;
      }
    });
  }

  Future<FacebookLoginStatus> login() async {
    final result = await _facebookLogin.logIn([]);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        await _carregarUsuario();
        print("Logou com Facebook ${result.accessToken.token}");
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelou login");
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.error:
        print("Login com Facebook falhou ${result.errorMessage}");
        // TODO: Handle this case.
        break;
    }

    AcessoController.add(result.status);
    return result.status;
  }

  Future<void> logout() async {
    await _facebookLogin.logOut();
    AcessoController.sink.add(FacebookLoginStatus.cancelledByUser);
  }

  Future<void> _carregarUsuario() async {
    FacebookAccessToken tk = await _facebookLogin.currentAccessToken;
    final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();
    Usuario usuario = await _usuarioBloc.buscarDadosUsuarioFacebook(tk.token);
    await _usuarioBloc.sincronizarUsuarioFirebase(usuario);
  }

  @override
  void dispose() {
    // TODO: implement dispos
    AcessoController.close();
    super.dispose();
  }
}
