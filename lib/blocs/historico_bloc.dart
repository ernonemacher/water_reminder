import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/model/analise_consumo.dart';
import 'package:waterreminder/model/consumo_diario.dart';

class HistoricoBloc extends BlocBase {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  StreamSubscription _subscriptionAdd;
  StreamSubscription _subscriptionEdit;

  List<ConsumoDiario> _historico = [];
  final _historicoController = BehaviorSubject<List<ConsumoDiario>>();

  ValueStream<List<ConsumoDiario>> get historicoStream =>
      _historicoController.stream;

  void setupHistorico(List<ConsumoDiario> historico) {
    _historico = historico;
  }

  Future<void> carregarHistorico() async {
    final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();
    final usuarioKey = _usuarioBloc.usuarioStream.value.key;

    Query query = _database
        .reference()
        .child("consumoDiario")
        .orderByChild("usuario")
        .equalTo(usuarioKey);

    _subscriptionAdd = query.onChildAdded.listen(_consumoDiarioAdicionado);
    _subscriptionEdit = query.onChildChanged.listen(_consumoDiarioEditado);
  }

  Future<void> _consumoDiarioAdicionado(Event event) async {
    final consumoDiario = _consumoFromEvent(event);

    _historico.add(consumoDiario);

    _ordenarLista();

    _historicoController.sink.add(_historico);
  }

  Future<void> _consumoDiarioEditado(Event event) async {
    final consumoDiario = _consumoFromEvent(event);

    _historico = _historico.map((consumo) {
      if (consumo.key == consumoDiario.key) {
        consumo.metaDiaria = consumoDiario.metaDiaria;
        consumo.consumo = consumoDiario.consumo;
      }

      return consumo;
    }).toList();
    _ordenarLista();

    _historicoController.sink.add(_historico);
  }

  ConsumoDiario _consumoFromEvent(Event event) {
    final key = event.snapshot.key;
    final consumoMap = Map<String, dynamic>.from(event.snapshot.value);
    final consumoDiario = ConsumoDiario.fromJson(key, consumoMap);
    return consumoDiario;
  }

  void _ordenarLista() {
    _historico.sort((a, b) => b.dia.compareTo(a.dia));
  }

  AnaliseConsumo diasConsecutivos() {
    final analiseConsumo = AnaliseConsumo();
    int faltas = 0;
    ConsumoDiario ultimoConsumo = ConsumoDiario(dia: DateTime.now());

    for (ConsumoDiario consumo in _historico) {
      if (faltas > 1) {
        break;
      }
      // Se atingiu meta no dia
      if (analiseConsumo.hasDiasConsecutivos && faltas > 0) {
        break;
      }
      int diferencaDias = _diferencaEmDias(ultimoConsumo.dia, consumo.dia);
      if (consumo.atingiuMeta) {
        if (diferencaDias <= 1) {
          analiseConsumo.incrementarSequenciaAtual();

          // Dia atual
          bool isToday = _diferencaEmDias(consumo.dia, DateTime.now()) == 0;
          if (isToday) {
            analiseConsumo.incrementarDiasConsecutivos();
          } else {
            // Só incrementa dias consecutivos se ele ja foi incializado
            if (analiseConsumo.hasDiasConsecutivos) {
              analiseConsumo.incrementarDiasConsecutivos();
            }
          }
        } else {
          faltas++;
        }
      } else {
        faltas += diferencaDias > 0 ? diferencaDias : 1;
      }

      ultimoConsumo = consumo;
    }
    return analiseConsumo;
  }

  int _diferencaEmDias(DateTime base, DateTime validar) {
    DateTime baseZerada = DateTime(base.year, base.month, base.day);
    DateTime validarZerado = DateTime(validar.year, validar.month, validar.day);

    return baseZerada.difference(validarZerado).inDays;
  }

  @override
  void dispose() {
    _historicoController.close();
    _subscriptionAdd?.cancel();
    _subscriptionEdit?.cancel();
    super.dispose();
  }
}
