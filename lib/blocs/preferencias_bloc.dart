import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:waterreminder/model/preferencias.dart';

class PreferenciasBloc extends BlocBase {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final _preferenciasController = BehaviorSubject<Preferencias>();
  StreamSubscription _subscriptionAdd;
  StreamSubscription _subscriptionEdit;

  ValueStream<Preferencias> get preferenciasStream =>
      _preferenciasController.stream;

  Future<void> sincronizarPreferencias(String keyUsuario) async {
    Query query = _database
        .reference()
        .child("preferencias")
        .orderByChild("usuario")
        .equalTo(keyUsuario);

    _subscriptionAdd = query.onChildAdded.listen(_listerPreferencias);
    _subscriptionEdit = query.onChildChanged.listen(_listerPreferencias);

    final snapshot = await query.once();
    if (snapshot.value == null) {
      await inserirPreferencias(Preferencias(usuario: keyUsuario));
    }
  }

  Future<Preferencias> inserirPreferencias(Preferencias preferencias) async {
    final reference = _database.reference().child("preferencias").push();
    await reference.set(preferencias.toJson());
    preferencias.key = reference.key;
    return preferencias;
  }

  Future<void> atualizarPreferencias(Preferencias preferencias) async {
    await _database
        .reference()
        .child("preferencias")
        .child(preferencias.key)
        .set(preferencias.toJson());
  }

  Future<void> _listerPreferencias(Event event) async {
    if (event.snapshot.value != null) {
      final preferencias = Preferencias.fromSnapshot(event.snapshot);
      _preferenciasController.sink.add(preferencias);
    }
  }

  @override
  void dispose() {
    _preferenciasController.close();
    _subscriptionAdd.cancel();
    _subscriptionEdit.cancel();
    super.dispose();
  }
}
