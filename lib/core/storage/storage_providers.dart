import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:daily_news/core/storage/local_storage.dart';

final sessionBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box<dynamic>(StorageBoxes.session),
);

final favoritesBoxProvider = Provider<Box<dynamic>>(
  (ref) => Hive.box<dynamic>(StorageBoxes.favorites),
);
