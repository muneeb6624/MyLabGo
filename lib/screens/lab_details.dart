// filepath: lab_details_screen.dart

import 'package:flutter/material.dart';
import '../widgets/custom_tests_card.dart'; // Update this with actual path

class TestData {
  final String name;
  final double price;
  final String duration;
  final String description;

  TestData({
    required this.name,
    required this.price,
    required this.duration,
    required this.description,
  });
}

class LabDetailsScreen extends StatelessWidget {
  final String labName;
  final String? labImageUrl;
  final String location;
  final double rating;
  final String about;
  final String openingHours;
  final String contactNumber;
  final String email;

  // NEW: Sample test data
  final List<TestData> availableTests = [
    TestData(
      name: 'Blood Test',
      price: 50.0,
      duration: '30 mins',
      description: 'Comprehensive blood panel',
    ),
    TestData(
      name: 'X-Ray',
      price: 70.0,
      duration: '20 mins',
      description: 'Chest and bone imaging',
    ),
    TestData(
      name: 'MRI Scan',
      price: 300.0,
      duration: '1 hour',
      description: 'Full body MRI scan',
    ),
    TestData(
      name: 'Covid-19 PCR',
      price: 25.0,
      duration: '15 mins',
      description: 'RT-PCR for Covid-19',
    ),
    TestData(
      name: 'Thyroid Test',
      price: 40.0,
      duration: '25 mins',
      description: 'TSH, T3, T4 levels',
    ),
  ];

  LabDetailsScreen({
    Key? key,
    required this.labName,
    this.labImageUrl,
    required this.location,
    required this.rating,
    required this.about,
    required this.openingHours,
    required this.contactNumber,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(labName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            if (labImageUrl != null)
              Center(
                child: Image.network(
                  labImageUrl!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Location',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(location),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Rating',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(rating.toString()),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'About the Lab',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(about),
            const SizedBox(height: 16),

            const Text(
              'Opening Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20),
                const SizedBox(width: 8),
                Text(openingHours),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'Contact Info',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 20),
                const SizedBox(width: 8),
                Text(contactNumber),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email, size: 20),
                const SizedBox(width: 8),
                Text(email),
              ],
            ),
            const SizedBox(height: 24),

            // NEW: Available Tests Section
            const Text(
              'Available Tests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 12),
            ...availableTests.map((test) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CustomTestsCard(
                    testName: test.name,
                    price: test.price,
                    duration: test.duration,
                    description: test.description,
                    onBook: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${test.name} booked!')),
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
