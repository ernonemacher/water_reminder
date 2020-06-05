import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/blocs/acesso_bloc.dart';
import 'package:waterreminder/components/splash.dart';
import 'package:waterreminder/config/config_cores.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _bloc = BlocProvider.getBloc<AcessoBloc>();

  @override
  Widget build(BuildContext context) {
    return Splash(
      image: Image.asset("images/unnamed.png"),
      photoSize: 90,
      backgroundColor: Colors.white,
      loadingText: Text(
        "Carregando dados de acesso...",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body1.copyWith(
              color: ConfigCores.azulClaro,
            ),
      ),
      loaderColor: ConfigCores.azulClaro,
      navigateAfterFuture: _bloc.validaAcesso,
    );
  }
}
