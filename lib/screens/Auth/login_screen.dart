import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_task_flutter/screens/Auth/signup_screen.dart';
import 'package:my_task_flutter/screens/Home/home_screen.dart';
import 'package:my_task_flutter/widgets/Buttons/custom_gradient_button.dart';
import 'package:my_task_flutter/widgets/Buttons/image_text_container.dart';
import 'package:my_task_flutter/widgets/colors.dart';
import 'package:my_task_flutter/widgets/custom_textfield.dart';
import 'package:my_task_flutter/widgets/text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isCheck = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final box = GetStorage();
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (isCheck) {
          box.write('isLoggedIn', true);
          box.write('email', _emailController.text.trim());
        } else {
          box.write('isLoggedIn', false);
          box.remove('email');
        }

        Get.offAll(() => const HomeScreen());
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'user-not-found') {
          message = 'No user found with this email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        } else {
          message = e.message ?? 'Login failed. Try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back_image.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Image.asset(
                      'assets/images/splash_logo.png',
                      width: 150,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    'TOTAL RECALL',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primarycolor,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 4.0,
                          color: primarycolor.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Never forget a memory',
                    style: TextStyle(
                      fontSize: 16,
                      color: greycolor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    'WELCOME BACK',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: whitecolor,
                    ),
                  ),
                  const Gap(30),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(text: 'Email'),
                  ),
                  const Gap(10),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Enter your email",
                    primaryColor: primarycolor,
                    validator: _validateEmail,
                  ),

                  const Gap(10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(text: 'Password'),
                  ),
                  const Gap(10),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: "Enter your password",
                    primaryColor: primarycolor,
                    isPassword: true,
                    validator: _validatePassword,
                  ),

                  const Gap(10),

                  Row(
                    children: [
                      Checkbox(
                        activeColor: primarycolor,
                        value: isCheck,
                        onChanged: (value) {
                          setState(() {
                            isCheck = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          color: whitecolor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: whitecolor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  CustomGradientButton(
                    text: 'Sign In',
                    onPressed: _onLoginPressed,
                  ),

                  const Gap(30),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: primarycolor.withOpacity(0.4),
                          thickness: 1,
                          endIndent: 10,
                        ),
                      ),
                      Text(
                        'or',
                        style: TextStyle(
                          color: greycolor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: primarycolor.withOpacity(0.4),
                          thickness: 1,
                          indent: 10,
                        ),
                      ),
                    ],
                  ),

                  const Gap(20),

                  // Google / Apple
                  ImageTextContainer(
                    imagePath: 'assets/images/google.png',
                    text: 'Sign in with Google',
                  ),
                  const Gap(20),
                  ImageTextContainer(
                    imagePath: 'assets/images/apple.png',
                    text: 'Sign in with Apple',
                  ),

                  const Gap(20),

                  // Sign Up Text
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: primarycolor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => const SignUpScreen());
                            },
                        ),
                      ],
                    ),
                  ),

                  const Gap(30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
