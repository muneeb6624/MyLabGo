import 'package:flutter/material.dart';
import '../widgets/custom-lab-card.dart';

// Lab model (You can move this to a separate file if needed)
class Lab {
  final String labName;
  final String location;
  final double rating;

  Lab({
    required this.labName,
    required this.location,
    required this.rating,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  // 👇 Sample lab data
  final List<Lab> _labs = [
    Lab(labName: 'HealthCheck Diagnostics', location: 'New York, NY', rating: 4.5),
    Lab(labName: 'Wellness Lab', location: 'Los Angeles, CA', rating: 4.7),
    Lab(labName: 'Precision Path Lab', location: 'Chicago, IL', rating: 4.3),
    Lab(labName: 'LifeLabs', location: 'Houston, TX', rating: 4.6),
    Lab(labName: 'MediLab Experts', location: 'Phoenix, AZ', rating: 4.4),
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
            // 🔍 Search Bar
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

            // 👋 Welcome Text
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

            // 🧪 Available Labs Section
            const Text(
              'Available Labs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 10),

            // 📋 List of Lab Cards (Dynamic)
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
                    onViewTests: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Viewing Tests for ${lab.labName}')),
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
