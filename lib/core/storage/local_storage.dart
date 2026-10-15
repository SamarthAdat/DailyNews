import 'package:hive_ce_flutter/hive_ce_flutter.dart';

abstract final class StorageBoxes {
  static const session = 'session_box';
  static const favorites = 'favorites_box';
  static const search = 'search_box';
}

abstract final class LocalStorage {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<dynamic>(StorageBoxes.session),
      Hive.openBox<dynamic>(StorageBoxes.favorites),
      Hive.openBox<dynamic>(StorageBoxes.search),
    ]);
  }
}
