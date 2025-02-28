import 'package:hive_flutter/adapters.dart';

/*
分两个box。第一个box只存所有的会话信息，第二个box存每个会话的聊天记录。
* 会话信息包括会话id，会话title，
* */
class DataStore {
  static final DataStore _instance = DataStore._internal();

  factory DataStore() {
    return _instance;
  }

  DataStore._internal() {
    final box = Hive.box('session');
  }


}