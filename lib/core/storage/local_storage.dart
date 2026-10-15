import 'package:hive_ce_flutter/hive_ce_flutter.dart';

abstract final class StorageBoxes {
  static const session = 'session_box';
}

abstract final class LocalStorage {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(StorageBoxes.session);
  }
}
