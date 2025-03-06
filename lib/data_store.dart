import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

/*
分两个box。第一个box只存所有的会话信息，第二个box存每个会话的聊天记录。
* 会话信息包括会话id，会话title，
* */
class DataStore {

  final String _sessionBoxName = 'session';
  final String _messageBoxName = 'message';

  Box? _sessionBox;
  Box? _messageBox;

  static DataStore? _instance;

  static DataStore get instance {
    _instance ??= DataStore._internal();
    return _instance!;
  }

  Future<void> initialize() async {
    await Hive.initFlutter();
    _sessionBox = await Hive.openBox(_sessionBoxName);
    _messageBox = await Hive.openBox(_messageBoxName);
  }

  DataStore._internal() {

  }

  List<dynamic> getAllSession() {
    final box = _sessionBox ?? Hive.box(_sessionBoxName);
    return box.values.toList();
  }

  void addSession(Map<String, dynamic> session) {
    final box = _sessionBox ?? Hive.box(_sessionBoxName);;
    box.add(session);
  }

}