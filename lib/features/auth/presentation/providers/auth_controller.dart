import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/features/auth/domain/entities/user.dart';
import 'package:daily_news/features/auth/presentation/providers/auth_providers.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(
  AuthController.new,
);

final isLoggedInProvider = Provider<bool>(
  (ref) => ref.watch(authControllerProvider).value != null,
);

class AuthController extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() => ref.read(getCurrentUserProvider).call();

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(loginUserProvider).call(email: email, password: password),
    );
  }

  Future<void> logout() async {
    await ref.read(logoutUserProvider).call();
    state = const AsyncData(null);
  }
}
