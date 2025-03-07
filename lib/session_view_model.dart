import 'package:deepseek_client/data_store.dart';
import 'package:deepseek_client/message_model.dart';
import 'package:flutter/material.dart';

class SessionViewModel extends ChangeNotifier {

  List<SessionModel> sessions = [];
  int currentMaxSessionId = 0;
  int currentSessionId = 0;

  SessionViewModel() {
    List<dynamic> data = DataStore.instance.getAllSession();
    for (var session in data) {
      SessionModel model = SessionModel.fromJson(session);
      sessions.add(model);
      if (model.sessionId > currentMaxSessionId) {
        currentMaxSessionId = model.sessionId;
      }
    }
    // 根据更新时间排序
    sessions.sort((a, b) => b.modifyTimestamp.compareTo(a.modifyTimestamp));
    currentSessionId = sessions.isNotEmpty ? sessions[0].sessionId : 0;
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

  void prepareNewSession() {
    currentSessionId = 0;
    notifyListeners();
  }

  void createNewSession(String title) {
    currentMaxSessionId += 1;
    DateTime now = DateTime.now();
    now.millisecondsSinceEpoch;
    SessionModel session = SessionModel(
      sessionId: currentMaxSessionId,
      title: title,
      modifyTimestamp: now.millisecondsSinceEpoch,
    );
    sessions.insert(0, session);
    DataStore.instance.addSession(session.toJson());
    currentSessionId = currentMaxSessionId;
    notifyListeners();
  }

  void changeCurrentSession(int index) {
    currentSessionId = _getSession(index).sessionId;
    notifyListeners();
  }
}