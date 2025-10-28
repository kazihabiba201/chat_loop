import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_image.dart';
import '../../../core/routes/routes.dart';
import 'login_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      next.whenOrNull(data: (user) {
        if (user != null) {
          context.go(RoutePaths.chatScreen);
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.appLogo,
                      height: 120,
                      width: 120,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      isLogin ? "Welcome Back to Chatloop" : "Join Chatloop 💬",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.center,
                      isLogin
                          ? "Stay connected, \nkeep the conversation looping."
                          : "Connect, share, and chat endlessly with friends.",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          if (( _emailController.text.isNotEmpty || _passwordController.text.isNotEmpty )
                              && loginState.hasError)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                loginState.error.toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),

                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (isLogin) {
                                  ref.read(loginControllerProvider.notifier).loginWithEmail(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                } else {
                                  ref.read(loginControllerProvider.notifier).signUp(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.deepPurple.shade200,
                            ),
                            child: Text(
                              isLogin ? "Login" : "Sign Up",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          TextButton(
                            onPressed: () => setState(() => isLogin = !isLogin),
                            child: Text(isLogin
                                ? "Don’t have an account? Sign Up"
                                : "Already have an account? Login"),
                          ),

                          const SizedBox(height: 10),

                          ElevatedButton.icon(
                            onPressed: () {
                              ref.read(loginControllerProvider.notifier).loginWithGoogle();
                            },
                            icon: Image.asset(
                              AppImages.googleLogo,
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                            ),
                            label: const Text("Continue with Google"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),

                          if (loginState.isLoading)
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}