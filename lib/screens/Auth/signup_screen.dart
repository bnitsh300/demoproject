import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_task_flutter/screens/Auth/login_screen.dart';
import 'package:my_task_flutter/widgets/Buttons/custom_gradient_button.dart';
import 'package:my_task_flutter/widgets/Buttons/image_text_container.dart';
import 'package:my_task_flutter/widgets/colors.dart';
import 'package:my_task_flutter/widgets/custom_textfield.dart';
import 'package:my_task_flutter/widgets/text.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isCheck = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // ✅ Confirm Password Validation
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Get.offAll(() => const LoginScreen());
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email format';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password should be at least 6 characters';
        } else {
          errorMessage = 'Signup failed: ${e.message}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
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
                    'GET STARTED',
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
                    hintText: "Create password",
                    primaryColor: primarycolor,
                    isPassword: true,
                    validator: _validatePassword,
                  ),
                  const Gap(10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(text: 'Confirm Password'),
                  ),
                  const Gap(10),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: "Confirm password",
                    primaryColor: primarycolor,
                    isPassword: true,
                    validator: _validateConfirmPassword,
                  ),
                  const Gap(30),

                  CustomGradientButton(
                    text: 'Create Account',
                    onPressed: _signUp,
                  ),
                  const Gap(30),

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
                        'or sign up with',
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

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      children: [
                        const TextSpan(
                          text: 'By signing up, you agree to our ',
                        ),
                        TextSpan(
                          text: 'Terms ',
                          style: TextStyle(
                            color: primarycolor,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Terms clicked')),
                              );
                            },
                        ),
                        const TextSpan(text: 'and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: primarycolor,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Privacy Policy clicked'),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),

                  RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: primarycolor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.off(() => const LoginScreen());
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
