import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/app/app.dart';
import 'package:daily_news/core/storage/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  runApp(ProviderScope(retry: (_, _) => null, child: const DailyNewsApp()));
}
