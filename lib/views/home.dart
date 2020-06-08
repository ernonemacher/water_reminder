import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/components/app_background.dart';
import 'package:waterreminder/config/config_cores.dart';
import 'package:waterreminder/views/home_drawer.dart';

class Home extends StatelessWidget {
  final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                size: 30,
                color: ConfigCores.branco,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      drawer: HomeDrawer(),
      body: AppBackground(
        child: SafeArea(
          child: Center(
              child: Text("Olá ${_usuarioBloc.usuarioStream.value.nome}")),
        ),
      ),
    );
  }
}
