import 'package:chat_app/presentation/pages/splash/splash_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/app_image.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(splashControllerProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              AppImages.appLogo,
              height: 180,
              width: 180,
              fit: BoxFit.fill,
            ),

            const CircularProgressIndicator(strokeWidth: .5,),
          ],
        ),
      ),
    );
  }
}