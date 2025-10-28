import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/locale_provider.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return Switch(
      value: locale.languageCode == 'bn',
      onChanged: (isEn) {
        ref.read(localeProvider.notifier).changeLanguage(isEn ? 'bn' : 'en');
      },
      inactiveThumbColor: Colors.pink.shade300,
      inactiveTrackColor: Colors.white,
      activeColor: Colors.white,
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (!states.contains(MaterialState.selected)) {
            return Colors.pink.shade100;
          }
          return Colors.transparent;
        },
      ),
    );
  }
}
