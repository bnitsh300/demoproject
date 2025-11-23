import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_task_flutter/screens/Auth/login_screen.dart';
import 'package:my_task_flutter/screens/Home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), checkLoginStatus);
    super.initState();
  }

  void checkLoginStatus() {
    final isLoggedIn = box.read('isLoggedIn') ?? false;
    print('Login Status: $isLoggedIn');
    if (isLoggedIn) {
      Get.offAll(() => const HomeScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Splash.png', fit: BoxFit.cover),
          Center(
            child: Image.asset('assets/images/splash_logo.png', width: 200),
          ),
        ],
      ),
    );
  }
}
