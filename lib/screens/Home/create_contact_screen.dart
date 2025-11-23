import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_task_flutter/widgets/Buttons/custom_gradient_button.dart';
import 'package:my_task_flutter/widgets/colors.dart';
import 'package:my_task_flutter/widgets/custom_textfield.dart';
import 'package:my_task_flutter/widgets/text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateContactScreen extends StatefulWidget {
  const CreateContactScreen({super.key});

  @override
  State<CreateContactScreen> createState() => _CreateContactScreenState();
}

class _CreateContactScreenState extends State<CreateContactScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = "";

  // Controllers
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final jobTitleController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final websiteController = TextEditingController();
  final locationController = TextEditingController();
  final commentController = TextEditingController();

  bool isLoading = false;

  final LinearGradient gradient = const LinearGradient(
    colors: [Color(0xFFEC008C), Color(0xFF00BCD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _speech = stt.SpeechToText();
  }

  // ---------- SPEECH TO TEXT ----------
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _spokenText = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // ---------- VALIDATION HELPERS ----------
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    const emailRegex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    if (!RegExp(emailRegex).hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Phone number is required';
    const phoneRegex = r'^[0-9+\-\s()]{7,15}$';
    if (!RegExp(phoneRegex).hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? validateWebsite(String? value) {
    if (value == null || value.trim().isEmpty) return 'Website is required';

    return null;
  }

  // ---------- FIREBASE SAVE ----------
  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('contacts').add({
        'full_name': nameController.text.trim(),
        'company': companyController.text.trim(),
        'job_title': jobTitleController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'website': websiteController.text.trim(),
        'location': locationController.text.trim(),
        'comment': commentController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      });

      // Clear form after saving
      nameController.clear();
      companyController.clear();
      jobTitleController.clear();
      emailController.clear();
      phoneController.clear();
      websiteController.clear();
      locationController.clear();
      commentController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Contact saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Failed to save: $e')));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // -------- APP BAR --------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Create Contact",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // -------- TAB BAR --------
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white24),
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFF03FFFF).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  tabs: const [
                    Tab(text: "Voice Input"),
                    Tab(text: "Type Details"),
                  ],
                ),
              ),

              // -------- TAB CONTENT --------
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // ---------- VOICE INPUT ----------
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          const Text(
                            "Speak contact details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Say something like: “John Smith from TechCorp, CTO, email is john@techcorp.com, phone is 555-123-4567”',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: primarycolor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          GestureDetector(
                            onTap: _listen,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: _isListening ? 110 : 90,
                              width: _isListening ? 110 : 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: gradient,
                                boxShadow: _isListening
                                    ? [
                                        BoxShadow(
                                          color: Colors.cyanAccent.withOpacity(
                                            0.6,
                                          ),
                                          blurRadius: 15,
                                          spreadRadius: 5,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: const Icon(
                                Icons.mic,
                                size: 45,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Tap to start speaking contact details",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Speak clearly and include name, company, title, and contact information",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 30),

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.pinkAccent.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              _spokenText.isEmpty
                                  ? "Example:\nJohn Smith from VentureConnect Partners, Senior Investment Manager. Email: john@ventureconnect.com, Phone: +1 310 555 8923, Website: ventureconnect.com, Location: San Francisco."
                                  : _spokenText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 20,
                            ),
                            child: CustomGradientButton(
                              text: 'Save',
                              onPressed: () {
                                if (_spokenText.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '❌ Please speak something first.',
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '✅ Voice data captured successfully!',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ---------- TYPED INPUT ----------
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(text: 'Full Name'),
                              ),
                              Gap(10),
                              CustomTextField(
                                controller: nameController,
                                hintText: "Enter your full name",
                                primaryColor: primarycolor,
                                validator: (v) =>
                                    validateRequired(v, "Full Name"),
                              ),
                              Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(text: 'Company'),
                              ),
                              Gap(10),
                              CustomTextField(
                                controller: companyController,
                                hintText: "Enter your company name",
                                primaryColor: primarycolor,
                                validator: (v) =>
                                    validateRequired(v, "Company"),
                              ),
                              Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(text: 'Job Title'),
                              ),
                              Gap(10),
                              CustomTextField(
                                controller: jobTitleController,
                                hintText: "Enter your job title",
                                primaryColor: primarycolor,
                                validator: (v) =>
                                    validateRequired(v, "Job Title"),
                              ),
                              Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(text: 'Email'),
                              ),
                              Gap(10),
                              CustomTextField(
                                controller: emailController,
                                hintText: "Enter your email",
                                primaryColor: primarycolor,
                                validator: validateEmail,
                              ),
                              Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(text: 'Phone'),
                              ),
                              Gap(10),
                              CustomTextField(
                                controller: phoneController,
                                hintText: "Enter your phone",
                                primaryColor: primarycolor,
                                validator: validatePhone,
                              ),
                              Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(text: 'Website'),
                              ),
                              Gap(10),
                              CustomTextField(
                                controller: websiteController,
                                hintText: "Enter your website",
                                primaryColor: primarycolor,
                                validator: validateWebsite,
                              ),
                              Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(text: 'Location'),
                              ),
                              Gap(10),
                              CustomTextField(
                                controller: locationController,
                                hintText: "Enter your location",
                                primaryColor: primarycolor,
                                validator: (v) =>
                                    validateRequired(v, "Location"),
                              ),
                              Gap(20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomText(text: 'Comment'),
                              ),
                              Gap(10),
                              CustomTextField(
                                controller: commentController,
                                hintText: "Enter your comment",
                                primaryColor: primarycolor,
                                validator: (v) =>
                                    validateRequired(v, "Comment"),
                              ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 20,
                                ),
                                child: CustomGradientButton(
                                  text: isLoading ? 'Saving...' : 'Save',
                                  onPressed: saveData,
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
            ],
          ),
        ),
      ),
    );
  }
}
