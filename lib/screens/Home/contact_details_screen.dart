import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:my_task_flutter/screens/Home/edit_contact_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailScreen extends StatelessWidget {
  final dynamic docId;
  final Map<String, dynamic> contact;
  const ContactDetailScreen({
    super.key,
    required this.contact,
    required this.docId,
  });

  String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return parts.first[0].toUpperCase() + parts.last[0].toUpperCase();
    } else {
      return parts.first[0].toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = contact['full_name'] ?? '';
    final title = contact['job_title'] ?? '';
    final company = contact['company'] ?? '';
    final email = contact['email'] ?? '';
    final phone = contact['phone'] ?? '';
    final linkedin = contact['linkedin'] ?? '';
    final website = contact['website'] ?? '';
    final location = contact['location'] ?? '';
    final comment = contact['comment'] ?? '';
    final timestamp = contact['created_at'];
    final dateStr = timestamp != null
        ? DateFormat("MMM d, yyyy").format(timestamp.toDate())
        : "Unknown";

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                // ---------- HEADER ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _roundIcon(
                      context,
                      Icons.arrow_back_ios,
                      () => Navigator.pop(context),
                    ),
                    _roundIcon(context, Icons.edit, () {
                      Get.to(
                        () => EditContactScreen(docId: docId, contact: contact),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),

                // ---------- AVATAR ----------
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
                        getInitials(name),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ---------- BASIC INFO ----------
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 15,
                  ),
                ),
                Text(
                  company,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.cyanAccent.withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    "Added $dateStr",
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ---------- ACTION ICONS ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _circleButton(
                      Icons.email_outlined,
                      "Email",
                      () => _launchUrl("mailto:$email"),
                    ),
                    _circleButton(
                      Icons.phone_outlined,
                      "Call",
                      () => _launchUrl("tel:$phone"),
                    ),
                    _circleButton(
                      Icons.message_outlined,
                      "Message",
                      () => _launchUrl("sms:$phone"),
                    ),
                    _circleButton(
                      Icons.language,
                      "Website",
                      () => _launchUrl("https://$website"),
                    ),
                    _circleButton(
                      Icons.link,
                      "LinkedIn",
                      () => _launchUrl(linkedin),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ---------- CONTACT INFORMATION ----------
                _sectionHeader("Contact Information"),
                const SizedBox(height: 10),

                _infoRow(Icons.email_outlined, "EMAIL", email, "Copy", () {}),
                _infoRow(
                  Icons.phone_outlined,
                  "PHONE",
                  phone,
                  "Call",
                  () => _launchUrl("tel:$phone"),
                ),
                _infoRow(
                  Icons.link,
                  "LinkedIn",
                  linkedin,
                  "Visit",
                  () => _launchUrl(linkedin),
                ),
                _infoRow(
                  Icons.home_outlined,
                  "WEBSITE",
                  website,
                  "Visit",
                  () => _launchUrl("https://$website"),
                ),
                _infoRow(
                  Icons.location_on_outlined,
                  "LOCATION",
                  location,
                  "Map",
                  () => _launchUrl(
                    "https://www.google.com/maps/search/?api=1&query=$location",
                  ),
                ),

                const SizedBox(height: 25),

                // ---------- MEMORY / NOTES ----------
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "🔴 Personal Notes",
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Icon(Icons.edit, color: Colors.pinkAccent, size: 18),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        comment,
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.4,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Recorded $dateStr",
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
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

  Widget _circleButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white30),
              color: Colors.white.withOpacity(0.05),
            ),
            child: Icon(icon, color: Colors.white70, size: 22),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }

  Widget _infoRow(
    IconData icon,
    String label,
    String value,
    String actionText,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.white60, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                actionText,
                style: const TextStyle(color: Colors.cyanAccent, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Row(
      children: [
        const Icon(Icons.circle, color: Colors.cyanAccent, size: 10),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
