import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/blocs/acesso_bloc.dart';
import 'package:waterreminder/blocs/consumo_diario_bloc.dart';
import 'package:waterreminder/blocs/notification_bloc.dart';
import 'package:waterreminder/blocs/preferencias_bloc.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/components/water_slider.dart';
import 'package:waterreminder/config/config_cores.dart';
import 'package:waterreminder/config/config_rotas.dart';
import 'package:waterreminder/model/preferencias.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();
  final _preferenciasBloc = BlocProvider.getBloc<PreferenciasBloc>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: StreamBuilder<Preferencias>(
              stream: _preferenciasBloc.preferenciasStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation(
                        ConfigCores.azulClaro,
                      ),
                    ),
                  );
                }
                final preferencias = snapshot.data;

                return Column(
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
                      value: preferencias.metaDiaria,
                      min: 1000,
                      max: 5000,
                      divisions: 40,
                      onChanged: (vl) async {
                        await _onChangedMeta(preferencias, vl);
                      },
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
                    GestureDetector(
                      onLongPress: _testNotification,
                                          child: Container(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width / 2),
                        child: Switch(
                          value: preferencias.recebeLembretes,
                          inactiveThumbColor: ConfigCores.azulEscuro,
                          inactiveTrackColor: ConfigCores.azulClaro,
                          activeTrackColor: ConfigCores.azulEscuro,
                          onChanged: (vl) async {
                            await _onChangedLembretes(preferencias, vl);
                          },
                        ),
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
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: _sair,
                                child: Container(
                                  child: Text(
                                    "SAIR",
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: ConfigCores.azulClaro,
                                        ),
                                  ),
                                ),
                              ),
                              if (_isLoading)
                                Container(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        ConfigCores.azulEscuro),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  Future<void> _testNotification() async {
    final _notificacaoBloc = BlocProvider.getBloc<NotificationBloc>();
    await _notificacaoBloc.teste();
  }

  Future<void> _onChangedMeta(Preferencias preferencias, int vl) async {
    setState(() {
      _isLoading = true;
    });
    preferencias.metaDiaria = vl;
    await _preferenciasBloc.atualizarPreferencias(preferencias);

    final _consumoDiarioBloc = BlocProvider.getBloc<ConsumoDiarioBloc>();
    await _consumoDiarioBloc.ajustarMeta(vl);

    await _subscribe(preferencias);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onChangedLembretes(Preferencias preferencias, bool vl) async {
    setState(() {
      _isLoading = true;
    });

    preferencias.recebeLembretes = vl;
    await _preferenciasBloc.atualizarPreferencias(preferencias);
    
    await _subscribe(preferencias, orCancel: true);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _subscribe(Preferencias preferencias,
      {bool orCancel: false}) async {
    final _notificacaoBloc = BlocProvider.getBloc<NotificationBloc>();

    if (preferencias.recebeLembretes) {
      await _notificacaoBloc.subscribe();
    } else {
      if (orCancel) {
        await _notificacaoBloc.cancelAll();
      }
    }
  }

  Future<void> _sair() async {
    final _acessoBloc = BlocProvider.getBloc<AcessoBloc>();
    await _acessoBloc.logout();
    Navigator.of(context).pushReplacementNamed(ConfigRotas.BOAS_VINDAS);
  }
}
