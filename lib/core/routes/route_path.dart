import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/presentation/pages/chat/chat_page.dart';
import 'package:chat_app/presentation/pages/login/login_page.dart';
import 'package:chat_app/presentation/pages/splash/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RoutePaths.chatScreen,
        builder: (context, state) => const ChatPage(),
      ),
    ],
  );
});