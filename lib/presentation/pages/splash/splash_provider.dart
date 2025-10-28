import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/routes/route_path.dart';
import '../../../core/routes/routes.dart';

final splashControllerProvider = Provider<SplashController>((ref) {
  return SplashController(ref);
});

class SplashController {
  final Ref ref;
  SplashController(this.ref) {
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;
      final router = ref.read(goRouterProvider);

      if (user != null) {
        router.go(RoutePaths.chatScreen);
      } else {
        router.go(RoutePaths.login);
      }
    });
  }
}
