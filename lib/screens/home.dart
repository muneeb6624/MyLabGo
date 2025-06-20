import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom-lab-card.dart';
import 'tests_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  Future<Map<String, dynamic>?> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance.collection('UserData').doc(uid).get();
    return doc.data();
  }

  Future<List<Map<String, dynamic>>> getLabs() async {
    final snapshot = await FirebaseFirestore.instance.collection('LabData').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyLabGo'),
        backgroundColor: Colors.cyan,
        actions: [
          FutureBuilder<Map<String, dynamic>?>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(child: CircularProgressIndicator(color: Colors.white)),
                );
              }

              final userData = snapshot.data!;
              final name = userData['name'] ?? 'User';
              final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : 'U';

              return Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      firstLetter,
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search labs/test...',
                prefixIcon: const Icon(Icons.search, color: Colors.cyan),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to MyLabGo!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.cyan),
            ),
            const SizedBox(height: 10),
            const Text(
              'Find the best labs near you for your medical needs.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Labs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan),
            ),
            const SizedBox(height: 10),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: getLabs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final labs = snapshot.data ?? [];

                if (labs.isEmpty) {
                  return const Center(child: Text('No labs available at the moment.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: labs.length,
                  itemBuilder: (context, index) {
                    final lab = labs[index];
                    final name = lab['labName'] ?? 'Unnamed Lab';
                    final location = lab['locationString'] ?? 'Location not provided';
                    final description = lab['description'] ?? 'No description available';
                    final image = lab['imgUrl'] ?? '';
                    final rating = lab['rating'] ?? 'NA';
                    final email = lab['email'] ?? 'N/A';
                    final contact = lab['userName'] ?? 'N/A'; // fallback

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: CustomLabCard(
                        labName: name,
                        location: location,
                        rating: rating is double ? rating : 0.0,
                        about: description,
                        openingHours: 'Mon - Sun: 9 AM - 9 PM',
                        contactNumber: contact,
                        email: email,
                        imageUrl: image,
                        availableTests: [], // implement tests fetch later
                        onViewTests: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestsScreen(
                                labName: name,
                                tests: const [], // implement with test data
                              ),
                            ),
                          );
                        },
                        onBookNow: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Booking $name...')),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
