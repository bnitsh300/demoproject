import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_task_flutter/screens/Home/all_contact_screen.dart';
import 'package:my_task_flutter/screens/Home/create_contact_screen.dart';
import 'package:my_task_flutter/screens/Auth/login_screen.dart';
import 'package:my_task_flutter/widgets/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = -1;

  final LinearGradient gradient = const LinearGradient(
    colors: [Color(0xFFEC008C), primarycolor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Future<void> _logout() async {
    final box = GetStorage(); // access GetStorage instance

    // Clear all saved data
    await box.erase();

    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Navigate to Login Screen
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: primarycolor),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.white70),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Ask about your contacts...',
                        labelStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.mic, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "My Contacts",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.to(() => const AllContactsScreen());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primarycolor),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.group, color: primarycolor),
                        SizedBox(width: 10),
                        Text("CONTACTS", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Add Contacts",
              style: TextStyle(color: whitecolor, fontSize: 16),
            ),
            const SizedBox(height: 15),

            _buildSelectableButton(0, Icons.camera_alt_outlined, "TAKE PHOTO"),
            const SizedBox(height: 15),
            _buildSelectableButton(1, Icons.qr_code, "QR Code"),
            const SizedBox(height: 15),
            _buildSelectableButton(2, Icons.upload, "Upload"),
            const SizedBox(height: 15),
            _buildSelectableButton(3, Icons.edit, "Add Manually"),

            const Spacer(),

            Center(
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.9),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableButton(int index, IconData icon, String text) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          if (index == 3) Get.to(() => const CreateContactScreen());
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 100,
        decoration: BoxDecoration(
          gradient: isSelected ? gradient : null,
          color: isSelected ? null : Colors.black54,
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
