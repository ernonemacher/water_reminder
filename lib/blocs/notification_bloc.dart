import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:waterreminder/api/local_notification_api.dart';

import 'consumo_diario_bloc.dart';

class NotificationBloc extends BlocBase {
  final _localNotificationApi = LocalNotificationApi();

  Future<void> init() async {
    bool result = await _localNotificationApi.init(_onTap);
    if (!result) {
      throw Exception(
          "Não foi possível  inicializar  as configuracoes de notificacoes");
    }
  }

  Future<void> _onTap(String data) {
    print("Abriu a  NOTIfication");
  }

  Future<void> teste() async {
    await _localNotificationApi.show(); 
  }

  Future<void> subscribe() async {
    final _consumoDiarioBloc = BlocProvider.getBloc<ConsumoDiarioBloc>();
    final _consumoAtual = _consumoDiarioBloc.stream.value;

    DateTime date = DateTime.now();

    bool _atingiuMetaHoje = _consumoAtual?.dia?.day == date.day &&
        _consumoAtual?.atingiuMeta == true;

    if (_atingiuMetaHoje) {
      await cancelCurrentDay();
      date = date.add(Duration(days: 1));
    }
    await _localNotificationApi.subscribeNext7Days(date);
    print("Notificacoes agendas para os proximos 7 dias");
  }

  Future<void> cancelAll() async {
    await _localNotificationApi.cancelAll();
    print("All notifications disable");
  }

    Future<void> cancelCurrentDay() async {
    await _localNotificationApi.cancelCurrentDay();
    print("Today notification disable");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
