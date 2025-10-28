import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/service/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final loginControllerProvider =
StateNotifierProvider<LoginController, AsyncValue<User?>>((ref) {
  final authService = ref.read(authServiceProvider);
  return LoginController(authService);
});

class LoginController extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;
  LoginController(this._authService) : super(const AsyncValue.data(null));
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(credential.user);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e.message ?? "Login failed", StackTrace.current);
    } catch (e) {
      state = AsyncValue.error("Login failed", StackTrace.current);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(credential.user);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e.message ?? "Signup failed", StackTrace.current);
    } catch (e) {
      state = AsyncValue.error("Signup failed", StackTrace.current);
    }
  }


  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error("Google login failed", StackTrace.current);
    }
  }



  void signOut() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }
}
