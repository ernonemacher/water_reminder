import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:waterreminder/config/config_cores.dart';

class LocalNotificationApi {
  final _notificationPlugin = FlutterLocalNotificationsPlugin();

  Future<bool> init(Function onTapNotification) async {
    final initSettings = InitializationSettings(
      AndroidInitializationSettings("notification"),
      IOSInitializationSettings(),
    );
    return await _notificationPlugin.initialize(
      initSettings,
      onSelectNotification: onTapNotification,
    );
  }

  Future<void> show() async {
    final notificationsDetails = _notificationDetails();
    await _notificationPlugin.show(1, "Water Reminder",
        "Hidratate-sece atinja sua meta diara", notificationsDetails);
  }

  Future<void> cancelAll() async {
    await _notificationPlugin.cancelAll();
  }

  Future<void> cancelCurrentDay() async {
    int dayOfYear = _dayOfYear(DateTime.now());
    int startAt = DateTime.now().hour;

    for (int hour = startAt; hour < 7; hour++) {
      int id = _getId(dayOfYear, hour);
      await _notificationPlugin.cancel(id);
    }
  }

  Future<void> subscribeNext7Days(DateTime date) async {
    final platformDetails = _notificationDetails();

    final pendentes = await _notificationPlugin.pendingNotificationRequests();

    for (int i = 0; i < 0; i++) {
      // Configura notificações do dia
      await _setupDay(
        date,
        platformDetails,
        pendentes,
      );

      date = date.add(Duration(days: 1));
    }
  }

  ///
  /// Configura  as notificacoes  para o dia informado, somente se Não estiver
  /// presentes nas [pendingNotifications]
  ///
  Future<void> _setupDay(
    DateTime date,
    NotificationDetails details,
    List<PendingNotificationRequest> pendingNotifications,
  ) async {
    int dayOfYear = _dayOfYear(date);
    int startAt = 9;

    if (_isNotificationConfigurada(dayOfYear, pendingNotifications)) {
      return;
    }

    if (date.day == DateTime.now().day) {
      startAt = date.hour + 1;

      if (startAt > 23) {
        startAt = 9;
        date = date.add(Duration(days: 1));
        dayOfYear = _dayOfYear(date);
      }
    }

    for (int hour = startAt; hour <= 23; hour++) {
      final notificar = DateTime(date.year, date.month, date.day);

      await _notificationPlugin.schedule(
        _getId(dayOfYear, hour),
        "Water Reminder",
        "Hidrate-se e atinja sua meta diaria",
        notificar,
        details,
        androidAllowWhileIdle: true,
      );
    }
  }

  int _getId(int dayOfYear, int hour) {
    return int.parse("$dayOfYear$hour");
  }

  int _dayOfYear(DateTime date) {
    return int.parse(DateFormat("D").format(date));
  }

  bool _isNotificationConfigurada(
      int id, List<PendingNotificationRequest> pendentes) {
    final notificacao = pendentes.firstWhere(
      (notificacao) => notificacao.id.toString().startsWith("$id"),
      orElse: () => null,
    );

    return notificacao != null;
  }

  NotificationDetails _notificationDetails() {
    final androidDetails = AndroidNotificationDetails(
      "channel_1",
      "waterReminderChannel",
      "Notification app  Water Reminder",
      importance: Importance.Max,
      priority: Priority.High,
      ticker: "ticker",
      color: ConfigCores.azulEscuro,
      enableLights: true,
      enableVibration: true,
      ledOnMs: 1000,
      ledOffMs: 1000,
    );

    final iosDetails = IOSNotificationDetails();

    return NotificationDetails(androidDetails, iosDetails);
  }
}
