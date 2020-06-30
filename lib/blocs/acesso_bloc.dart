import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rxdart/rxdart.dart';
import 'package:waterreminder/blocs/consumo_diario_bloc.dart';
import 'package:waterreminder/blocs/preferencias_bloc.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/blocs/notification_bloc.dart';
import 'package:waterreminder/config/config_rotas.dart';
import 'package:waterreminder/model/usuario.dart';

import 'historico_bloc.dart';

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

    final _notificacaoBloc =  BlocProvider.getBloc<NotificationBloc>();
    await _notificacaoBloc.cancelAll();
  }

  Future<void> _carregarUsuario() async {
    FacebookAccessToken tk = await _facebookLogin.currentAccessToken;
    final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();
    Usuario usuario = await _usuarioBloc.buscarDadosUsuarioFacebook(tk.token);

    final usuarioFirebase = await  _usuarioBloc.sincronizarUsuarioFirebase(usuario);

    if(usuarioFirebase.key != null) {
      final  _preferenciasBloc  =  BlocProvider.getBloc<PreferenciasBloc>();
      await _preferenciasBloc.sincronizarPreferencias(usuarioFirebase.key);
    
    await _usuarioBloc.sincronizarUsuarioFirebase(usuario);

    final  _consumoDiarioBloc  =  BlocProvider.getBloc<ConsumoDiarioBloc>();
    await _consumoDiarioBloc.carregarConsumo();

    final  _historicoBloc  =  BlocProvider.getBloc<HistoricoBloc>();
    await _historicoBloc.carregarHistorico();

    final _notificacaoBloc =  BlocProvider.getBloc<NotificationBloc>();
    await _notificacaoBloc.init();

    //Só mostra mensagem quando usuario recebe lembretes...
    if(_preferenciasBloc.preferenciasStream.value.recebeLembretes) {
      await _notificacaoBloc.subscribe();
    }
    }
  }

  @override
  void dispose() {
    AcessoController.close();
    super.dispose();
  }
}
