import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:my_task_flutter/screens/Home/contact_details_screen.dart';
import 'package:my_task_flutter/widgets/colors.dart';

class AllContactsScreen extends StatefulWidget {
  const AllContactsScreen({super.key});

  @override
  State<AllContactsScreen> createState() => _AllContactsScreenState();
}

class _AllContactsScreenState extends State<AllContactsScreen> {
  Stream<QuerySnapshot> getContactsStream() {
    return FirebaseFirestore.instance
        .collection('contacts')
        .orderBy('full_name')
        .snapshots();
  }

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0F2C), Color(0xFF041B33)],
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
          child: StreamBuilder<QuerySnapshot>(
            stream: getContactsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.cyan),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No contacts found",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              final total = docs.length;

              // Recent: created within last 14 days
              final recent = docs.where((d) {
                final ts = d['created_at'] as Timestamp?;
                if (ts == null) return false;
                return DateTime.now().difference(ts.toDate()).inDays <= 14;
              }).length;

              // Unique companies
              final companies = docs.map((d) => d['company']).toSet().length;

              // Group contacts alphabetically
              Map<String, List<QueryDocumentSnapshot>> grouped = {};
              for (var doc in docs) {
                final name = (doc['full_name'] ?? '').toString();
                if (name.isEmpty) continue;
                final letter = name[0].toUpperCase();
                grouped.putIfAbsent(letter, () => []).add(doc);
              }

              final sortedKeys = grouped.keys.toList()..sort();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------- HEADER ----------
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
                        const Text(
                          "All Contacts",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  // ---------- STATS ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          "TOTAL",
                          total.toString(),
                          Colors.cyanAccent,
                        ),
                        _buildStatCard(
                          "RECENT",
                          recent.toString(),
                          Colors.pinkAccent,
                        ),
                        _buildStatCard(
                          "COMPANIES",
                          companies.toString(),
                          Colors.amberAccent,
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),

                  // ---------- CONTACTS LIST ----------
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: sortedKeys.length,
                      itemBuilder: (context, index) {
                        String letter = sortedKeys[index];
                        List<QueryDocumentSnapshot> list = grouped[letter]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 8,
                              ),
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...list.map((doc) {
                              final docId = doc.id;
                              final data = doc.data() as Map<String, dynamic>;
                              final name = data['full_name'] ?? '';
                              final title = data['job_title'] ?? '';
                              final company = data['company'] ?? '';
                              final email = data['email'] ?? '';
                              final location = data['location'] ?? '';
                              final comment = data['comment'] ?? '';
                              final createdAt =
                                  data['created_at'] as Timestamp?;
                              final daysAgo = createdAt == null
                                  ? "Unknown"
                                  : "${DateTime.now().difference(createdAt.toDate()).inDays} Days";

                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => ContactDetailScreen(
                                      contact: data,
                                      docId: docId,
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.cyanAccent.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 26,
                                              backgroundColor: const Color(
                                                0xFF00BCD4,
                                              ).withOpacity(0.5),
                                              child: Text(
                                                getInitials(name),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const Gap(12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    title,
                                                    style: const TextStyle(
                                                      color: Colors.cyanAccent,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Text(
                                                    company,
                                                    style: const TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.teal.withOpacity(
                                                  0.3,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                daysAgo,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(12),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.email_outlined,
                                              color: Colors.white60,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                email,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.white60,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                location,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Gap(12),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.pinkAccent
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.pinkAccent
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "💡 Memory Notes",
                                                style: TextStyle(
                                                  color: Colors.pinkAccent,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const Gap(4),
                                              Text(
                                                comment,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                  height: 1.3,
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
                            }),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
