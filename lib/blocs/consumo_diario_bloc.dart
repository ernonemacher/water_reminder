import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:waterreminder/blocs/notification_bloc.dart';
import 'package:waterreminder/blocs/preferencias_bloc.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/model/consumo_diario.dart';

class ConsumoDiarioBloc extends BlocBase {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final _consumoDiarioController = BehaviorSubject<ConsumoDiario>();

  ValueStream<ConsumoDiario> get stream => _consumoDiarioController.stream;

  Future<void> carregarConsumo() async {
    final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();

    Query query = _database
        .reference()
        .child("consumoDiario")
        .orderByChild("usuario")
        .equalTo(_usuarioBloc.usuarioStream.value.key);
    final snapshot = await query.once();
    if (snapshot.value != null) {
      final map = Map.from(snapshot.value);
      final keysList = List.from(map.keys);

      for (String key in keysList) {
        final consumoMap = Map<String, dynamic>.from(map[key]);
        final consumoDiario = ConsumoDiario.fromJson(key, consumoMap);
        if (_isFromToday(consumoDiario.dia)) {
          _consumoDiarioController.sink.add(consumoDiario);
          break;
        }
      }
    }
  }

  void adicionarConsumo(int quantidade) async {
    final _usuarioBloc = BlocProvider.getBloc<UsuarioBloc>();
    final _preferenciasBloc = BlocProvider.getBloc<PreferenciasBloc>();
    final _preferencias = _preferenciasBloc.preferenciasStream.value;

    ConsumoDiario consumoDiario = stream.value ??
        ConsumoDiario(
          usuario: _usuarioBloc.usuarioStream.value.key,
          metaDiaria: _preferencias.metaDiaria,
          dia: DateTime.now(),
        );

    consumoDiario.consumo += quantidade;
    await _salvarConsumo(consumoDiario);

    if (_preferencias.recebeLembretes && consumoDiario.atingiuMeta) {
      final _notificacaoBloc = BlocProvider.getBloc<NotificationBloc>();
      await _notificacaoBloc.cancelCurrentDay();
    }
  }

  Future<void> _salvarConsumo(ConsumoDiario consumoDiario) async {
    if (consumoDiario.key == null) {
      consumoDiario = await _inserirConsumo(consumoDiario);
    } else {
      await _atualizarConsumo(consumoDiario);
    }

    _consumoDiarioController.sink.add(consumoDiario);
  }

  Future<ConsumoDiario> _inserirConsumo(ConsumoDiario consumoDiario) async {
    final reference = _database.reference().child("consumoDiario").push();
    await reference.set(consumoDiario.toJson());

    consumoDiario.key = reference.key;
    return consumoDiario;
  }

  Future<void> _atualizarConsumo(ConsumoDiario consumo) async {
    await _database
        .reference()
        .child("consumoDiario")
        .child(consumo.key)
        .set(consumo.toJson());
  }

  Future<void> ajustarMeta(int meta) async {
    final ultimoConsumo = _consumoDiarioController.stream.value;
    final hoje = DateTime.now();

    if (ultimoConsumo != null && _isFromToday(ultimoConsumo.dia)) {
      ultimoConsumo.metaDiaria = meta;
      await _salvarConsumo(ultimoConsumo);
    }
  }

  bool _isFromToday(DateTime date) {
    final hoje = DateTime.now();
    return date.day == hoje.day &&
        date.month == hoje.month &&
        date.year == hoje.year;
  }

  @override
  void dispose() {
    super.dispose();
    _consumoDiarioController.close();
  }
}
