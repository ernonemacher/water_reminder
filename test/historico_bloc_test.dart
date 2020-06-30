import 'package:flutter_test/flutter_test.dart';
import 'package:waterreminder/blocs/historico_bloc.dart';
import 'package:waterreminder/model/consumo_diario.dart';

//  TDD Test Driven Development
final _hoje = DateTime.now();
DateTime _buildDate(int menosDias) {
  return _hoje.add(Duration(days: -menosDias));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HistoricoBloc _historicoBloc;
  setUp(() {
    _historicoBloc = HistoricoBloc();
  });
  setUpAll(() {
    _historicoBloc?.setupHistorico([]);
  });
  test("Deve retornar 0 dias consecutivos e 3 dias em sequência", () {
    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(0), metaDiaria: 1000, consumo: 500),
      ConsumoDiario(dia: _buildDate(1), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(2), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(3), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(4), metaDiaria: 1000, consumo: 400),
      ConsumoDiario(dia: _buildDate(5), metaDiaria: 1000, consumo: 1200),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 0);
    expect(analiseConsumo.sequenciaAtual, 3);
  });
  test("Deve retornar 4 dias consecutivos e 4 dias em sequência", () {
    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(0), metaDiaria: 1000, consumo: 1000),
      ConsumoDiario(dia: _buildDate(1), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(2), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(3), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(4), metaDiaria: 1000, consumo: 400),
      ConsumoDiario(dia: _buildDate(5), metaDiaria: 1000, consumo: 1200),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 4);
    expect(analiseConsumo.sequenciaAtual, 4);
  });
  test("Deve retornar 0 dias consecutivos e 0 dias em sequência", () {
    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(0), metaDiaria: 1000, consumo: 400),
      ConsumoDiario(dia: _buildDate(1), metaDiaria: 1000, consumo: 999),
      ConsumoDiario(dia: _buildDate(2), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(3), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(4), metaDiaria: 1000, consumo: 400),
      ConsumoDiario(dia: _buildDate(5), metaDiaria: 1000, consumo: 1200),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 0);
    expect(analiseConsumo.sequenciaAtual, 0);
  });
  test("Deve retornar 1 dias consecutivos e 1 dias em sequência", () {
    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(0), metaDiaria: 1000, consumo: 1000),
      ConsumoDiario(dia: _buildDate(1), metaDiaria: 1000, consumo: 999),
      ConsumoDiario(dia: _buildDate(2), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(3), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(4), metaDiaria: 1000, consumo: 400),
      ConsumoDiario(dia: _buildDate(5), metaDiaria: 1000, consumo: 1200),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 1);
    expect(analiseConsumo.sequenciaAtual, 1);
  });
  test("Deve retornar 0 dias consecutivos e 1 dias em sequência", () {
    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(0), metaDiaria: 1000, consumo: 999),
      ConsumoDiario(dia: _buildDate(1), metaDiaria: 1000, consumo: 1000),
      ConsumoDiario(dia: _buildDate(2), metaDiaria: 1000, consumo: 0),
      ConsumoDiario(dia: _buildDate(3), metaDiaria: 1000, consumo: 1200),
      ConsumoDiario(dia: _buildDate(4), metaDiaria: 1000, consumo: 400),
      ConsumoDiario(dia: _buildDate(5), metaDiaria: 1000, consumo: 1200),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 0);
    expect(analiseConsumo.sequenciaAtual, 1);
  });
  test(
      "Deve retornar 0 dias consecutivos e 0 dias em sequência em dias alternados",
      () {
    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(2), metaDiaria: 1000, consumo: 999),
      ConsumoDiario(dia: _buildDate(3), metaDiaria: 1000, consumo: 1000),
      ConsumoDiario(dia: _buildDate(4), metaDiaria: 1000, consumo: 999),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 0);
    expect(analiseConsumo.sequenciaAtual, 0);
  });
  test(
      "Deve retornar 1 dias consecutivos e 1 dias em sequência em dias alternados",
      () {
    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(0), metaDiaria: 1000, consumo: 2000),
      ConsumoDiario(dia: _buildDate(2), metaDiaria: 1000, consumo: 999),
      ConsumoDiario(dia: _buildDate(3), metaDiaria: 1000, consumo: 1000),
      ConsumoDiario(dia: _buildDate(4), metaDiaria: 1000, consumo: 999),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 1);
    expect(analiseConsumo.sequenciaAtual, 1);
  });
  test(
      "Deve retornar 0 dias consecutivos e 2 dias em sequência em dias alternados",
      () {
    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(1), metaDiaria: 1000, consumo: 2000),
      ConsumoDiario(dia: _buildDate(2), metaDiaria: 1000, consumo: 1000),
      ConsumoDiario(dia: _buildDate(4), metaDiaria: 1000, consumo: 999),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 0);
    expect(analiseConsumo.sequenciaAtual, 2);
  });
  test(
      "Deve retornar 0 dias consecutivos e 0 dias em sequência em dias alternados",
      () {
    DateTime date = _buildDate(2);
    date = date.add(Duration(hours: 1));

    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(0), metaDiaria: 1000, consumo: 100),
      ConsumoDiario(dia: date, metaDiaria: 1000, consumo: 1000),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 0);
    expect(analiseConsumo.sequenciaAtual, 0);
  });
    test(
      "Deve retornar 1 dias consecutivos e 1 dias em sequência em dias alternados",
      () {
    _historicoBloc.setupHistorico([
      ConsumoDiario(dia: _buildDate(0), metaDiaria: 1000, consumo: 1000),
      ConsumoDiario(dia: _buildDate(2), metaDiaria: 1000, consumo: 1000),
    ]);
    final analiseConsumo = _historicoBloc.diasConsecutivos();
    expect(analiseConsumo.diasConsecutivos, 1);
    expect(analiseConsumo.sequenciaAtual, 1);
  });
}
