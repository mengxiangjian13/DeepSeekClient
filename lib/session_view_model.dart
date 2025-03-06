import 'package:deepseek_client/data_store.dart';
import 'package:deepseek_client/message_model.dart';
import 'package:flutter/material.dart';

class SessionViewModel extends ChangeNotifier {

  List<SessionModel> sessions = [];
  int currentMaxSessionId = 0;

  SessionViewModel() {
    List<dynamic> data = DataStore.instance.getAllSession();
    for (var session in data) {
      SessionModel model = SessionModel.fromJson(session);
      sessions.add(model);
      if (model.sessionId > currentMaxSessionId) {
        currentMaxSessionId = model.sessionId;
      }
    }
  }

  int get sessionCount => sessions.length;

  SessionModel _getSession(int index) {
    if (index < 0 || index >= sessions.length) {
      throw Exception('Invalid index');
    }
    return sessions[index];
  }

  String sessionTitle(int index) {
    return _getSession(index).title;
  }

  void addSession(String title) {
    currentMaxSessionId += 1;
    SessionModel session = SessionModel(
      sessionId: currentMaxSessionId,
      title: title,
    );
    sessions.insert(0, session);
    DataStore.instance.addSession(session.toJson());
    notifyListeners();
  }
}