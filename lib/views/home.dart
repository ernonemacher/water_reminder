import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/components/app_background.dart';
import 'package:waterreminder/components/tab_bar_navigator.dart';
import 'package:waterreminder/config/config_cores.dart';
import 'package:waterreminder/views/home_drawer.dart';
import 'package:waterreminder/views/tabs/historico.dart';
import 'package:waterreminder/views/tabs/registro.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(_tabListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _tabController.addListener(_tabListener);
  }

  void _onChangedPage(int nextPage) {
    setState(() {
      _tabController.index = nextPage;
    });
  }

  void _tabListener() {
    setState(() {});
  }

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
        bottom: TabBarNavigator(
          onChangedPage: _onChangedPage,
          currentPage: _tabController.index,
        ),
      ),
      extendBodyBehindAppBar: true,
      drawer: HomeDrawer(),
      body: AppBackground(
        child: SafeArea(
            child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Registro(),
            Historico(),
          ],
        )),
      ),
    );
  }
}
