import 'package:flutter/material.dart';
import 'package:robinbank_app/components/auth_button.dart';
import 'package:robinbank_app/components/auth_text_field.dart';
import 'package:robinbank_app/services/auth_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<StatefulWidget> createState() => SignInState();
}

class SignInState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void signIn() {
    authService.signInUser(
        context: context,
        email: emailController.text,
        password: passwordController.text);
  }

  void signInGoogle() {}

  void signInApple() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [UIColours.blue, UIColours.white],
            stops: [0, 1],
            begin: AlignmentDirectional(0.87, -1),
            end: AlignmentDirectional(-0.87, 1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'RobinBank',
              style: UIText.brand.copyWith(color: UIColours.white),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                    color: UIColours.background2,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                        child: Text(
                          'Welcome Back',
                          style: UIText.heading,
                        ),
                      ),
                      AuthTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      AuthTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      AuthButton(
                        text: 'Sign In',
                        onPressed: signIn,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                        child: Text(
                          'Or sign in with',
                          style: UIText.xsmall,
                        ),
                      ),
                      AuthButton(
                        text: 'Continue with Google',
                        onPressed: signInGoogle,
                      ),
                      AuthButton(
                        text: 'Continue with Apple',
                        onPressed: signInApple,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?  ',
                              style: UIText.xsmall,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/signuppage');
                              },
                              child: Text(
                                'Sign up here',
                                style: UIText.xsmall
                                    .copyWith(color: UIColours.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
