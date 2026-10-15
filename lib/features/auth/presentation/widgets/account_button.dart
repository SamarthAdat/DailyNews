import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/features/auth/presentation/providers/auth_controller.dart';
import 'package:daily_news/features/auth/presentation/widgets/account_sheet.dart';

class AccountButton extends ConsumerWidget {
  const AccountButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => AccountSheet.show(context),
        child: CircleAvatar(
          radius: 17,
          backgroundColor: colors.primaryContainer,
          child: Text(
            user.initials,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: colors.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
