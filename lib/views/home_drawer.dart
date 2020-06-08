import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/blocs/acesso_bloc.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/components/water_slider.dart';
import 'package:waterreminder/config/config_cores.dart';
import 'package:waterreminder/config/config_rotas.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(110),
                  child: FadeInImage.assetNetwork(
                    image: _usuarioBloc.usuarioStream.value.urlFoto,
                    placeholder: "images/user_placeholder.png",
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                _usuarioBloc.usuarioStream.value.nome,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: Theme.of(context).textTheme.headline.copyWith(
                      fontWeight: FontWeight.normal,
                      color: ConfigCores.preto,
                    ),
              ),
              Container(
                height: 30,
              ),
              Text(
                "META DIÁRIA",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline.copyWith(
                      fontWeight: FontWeight.normal,
                      color: ConfigCores.preto,
                    ),
              ),
              WaterSlider(
                min: 1000,
                max: 5000,
                divisions: 40,
                onChanged: (vl) {},
              ),
              Container(
                height: 30,
              ),
              Text(
                "LEMBRETES",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline.copyWith(
                      fontWeight: FontWeight.normal,
                      color: ConfigCores.preto,
                    ),
              ),
              Container(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 2),
                child: Switch(
                  value: true,
                  inactiveThumbColor: ConfigCores.azulEscuro,
                  inactiveTrackColor: ConfigCores.azulClaro,
                  activeTrackColor: ConfigCores.azulEscuro,
                  onChanged: (vl) {},
                ),
              ),
              Container(
                height: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    InkWell(
                      onTap: _sair,
                      child: Container(
                        child: Text(
                          "SAIR",
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.title.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConfigCores.azulClaro,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sair() async {
    final _acessoBloc = BlocProvider.getBloc<AcessoBloc>();
    await _acessoBloc.logout();
    Navigator.of(context).pushReplacementNamed(ConfigRotas.BOAS_VINDAS);
  }
}
