import 'package:flutter/material.dart';
import 'package:robinbank_app/components/auth_button.dart';
import 'package:robinbank_app/components/auth_text_field.dart';
import 'package:robinbank_app/services/auth_service.dart';
import 'package:robinbank_app/ui/ui_colours.dart';
import 'package:robinbank_app/ui/ui_text.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final AuthService authService = AuthService();

  void signUp() {
    authService.signUpUser(
        context: context,
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text);
  }

  void signUpGoogle() {}

  void signUpApple() {}

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
                    color: UIColours.darkBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(
                          0,
                          2,
                        ),
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
                          'Get Started',
                          style: UIText.heading,
                        ),
                      ),
                      AuthTextField(
                        controller: nameController,
                        hintText: 'Name',
                        obscureText: false,
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
                        text: 'Sign Up',
                        onPressed: signUp,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
                        child: Text(
                          'Or sign up with',
                          style: UIText.xsmall,
                        ),
                      ),
                      AuthButton(
                        text: 'Continue with Google',
                        onPressed: signUpGoogle,
                      ),
                      AuthButton(
                        text: 'Continue with Apple',
                        onPressed: signUpApple,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?  ',
                              style: UIText.xsmall,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/signinpage');
                              },
                              child: Text(
                                'Sign in here',
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
