import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditContactScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> contact;
  const EditContactScreen({
    super.key,
    required this.docId,
    required this.contact,
  });

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController nameController;
  late TextEditingController companyController;
  late TextEditingController jobTitleController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController linkedinController;
  late TextEditingController websiteController;
  late TextEditingController locationController;
  late TextEditingController notesController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.contact;
    nameController = TextEditingController(text: c['full_name']);
    companyController = TextEditingController(text: c['company']);
    jobTitleController = TextEditingController(text: c['job_title']);
    emailController = TextEditingController(text: c['email']);
    phoneController = TextEditingController(text: c['phone']);
    linkedinController = TextEditingController(text: c['linkedin']);
    websiteController = TextEditingController(text: c['website']);
    locationController = TextEditingController(text: c['location']);
    notesController = TextEditingController(text: c['comment']);
  }

  Future<void> _saveContact() async {
    setState(() => isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('contacts')
          .doc(widget.docId)
          .update({
            'full_name': nameController.text.trim(),
            'company': companyController.text.trim(),
            'job_title': jobTitleController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
            'linkedin': linkedinController.text.trim(),
            'website': websiteController.text.trim(),
            'location': locationController.text.trim(),
            'comment': notesController.text.trim(),
            'updated_at': Timestamp.now(),
          });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact updated successfully!')),
        );
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> _deleteContact() async {
    try {
      await FirebaseFirestore.instance
          .collection('contacts')
          .doc(widget.docId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact deleted successfully.')),
        );
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF011829), Color(0xFF000A12)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/back_image.png'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------- Header ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _roundIcon(
                      context,
                      Icons.arrow_back_ios,
                      () => Navigator.pop(context),
                    ),
                    const Text(
                      "Edit Contact",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: isSaving ? null : _saveContact,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          isSaving ? "Saving..." : "Save",
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ---------- Avatar ----------
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9C27B0), Color(0xFF00BCD4)],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(contact['full_name']),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _sectionHeader("Basic Information"),
                const SizedBox(height: 10),
                _inputField(Icons.person, "Full Name", nameController),
                _inputField(
                  Icons.home_work_outlined,
                  "Company",
                  companyController,
                ),
                _inputField(
                  Icons.badge_outlined,
                  "Job Title",
                  jobTitleController,
                ),

                const SizedBox(height: 16),
                _sectionHeader("Contact Information"),
                const SizedBox(height: 10),
                _inputField(Icons.email_outlined, "Email", emailController),
                _inputField(Icons.phone_outlined, "Phone", phoneController),
                _inputField(Icons.link, "LinkedIn", linkedinController),
                _inputField(Icons.language, "Website", websiteController),
                _inputField(
                  Icons.location_on_outlined,
                  "Location",
                  locationController,
                ),

                const SizedBox(height: 16),
                _sectionHeader("Your Memory"),
                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.pinkAccent.withOpacity(0.4),
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: TextField(
                    controller: notesController,
                    maxLines: 6,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter memory notes here...",
                      hintStyle: TextStyle(color: Colors.white38),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                _sectionHeader("Danger Zone"),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _deleteContact,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.5),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "🗑 Delete Contact",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundIcon(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        const Icon(Icons.circle, color: Colors.cyanAccent, size: 10),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _inputField(
    IconData icon,
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white54, size: 18),
          labelStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return parts.first[0].toUpperCase() + parts.last[0].toUpperCase();
    } else {
      return parts.first[0].toUpperCase();
    }
  }
}
