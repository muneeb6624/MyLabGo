import 'package:flutter/material.dart';
import '../widgets/custom-lab-card.dart';
import 'tests_screen.dart';
import '../screens/lab_details.dart';

// Lab model
class Lab {
  final String labName;
  final String location;
  final double rating;
  final List<TestData> tests;

  Lab({
    required this.labName,
    required this.location,
    required this.rating,
    required this.tests,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Lab> _labs = [
    Lab(
      labName: 'HealthCheck Diagnostics',
      location: 'New York, NY',
      rating: 4.5,
      tests: [
        TestData(
          name: 'Blood Test',
          price: 49.99,
          duration: '1 day',
          description: 'Comprehensive blood panel',
        ),
        TestData(
          name: 'COVID-19 PCR',
          price: 99.00,
          duration: '6 hours',
          description: 'Reliable COVID-19 testing',
        ),
      ],
    ),
    // Add more labs here if needed
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyLabGo'),
        backgroundColor: Colors.cyan,
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Find the best labs near you for your medical needs.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'Available Labs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 10),

            // 📋 Lab cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _labs.length,
              itemBuilder: (context, index) {
                final lab = _labs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: CustomLabCard(
                    labName: lab.labName,
                    location: lab.location,
                    rating: lab.rating,
                    about: 'We offer top-notch diagnostic services for all your health needs.',
                    openingHours: 'Mon - Fri: 9:00 AM - 5:00 PM',
                    contactNumber: '+1-800-123-4567',
                    email: 'info@${lab.labName.toLowerCase().replaceAll(" ", "")}.com',

                    // 👇 Pass the required 'availableTests' argument
                    availableTests: lab.tests,

                    onViewTests: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestsScreen(
                            labName: lab.labName,
                            tests: lab.tests, // 👈 actual test data per lab
                          ),
                        ),
                      );
                    },
                    onBookNow: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking ${lab.labName}')),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
