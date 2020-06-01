import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/components/app_background.dart';

class Home extends StatelessWidget {
  final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(child: Text("Olá ${_usuarioBloc.usuarioStream.value.nome}")),
        ),
      ),
    );
  }
}
