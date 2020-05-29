import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rxdart/rxdart.dart';

class AcessoBloc extends BlocBase {
  final AcessoController = BehaviorSubject<FacebookLoginStatus>();

  ValueStream<FacebookLoginStatus> get AcessoStream => AcessoController.stream;

  Future<FacebookLoginStatus> login() async {
    final facebookLogin = FacebookLogin();

    //  TODO: REMOVER
    await facebookLogin.logOut();

    final result = await facebookLogin.logIn([]);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
