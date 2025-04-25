// lib/widgets/custom_lab_card.dart

import 'package:flutter/material.dart';
import '../screens/lab_details.dart';

class CustomLabCard extends StatelessWidget {
  final String labName;
  final String location;
  final double rating;
  final String about;
  final String openingHours;
  final String contactNumber;
  final String email;
  final List<TestData> availableTests; // ✅ New field
  final VoidCallback onViewTests;
  final VoidCallback onBookNow;

  const CustomLabCard({
    super.key,
    required this.labName,
    required this.location,
    required this.rating,
    required this.about,
    required this.openingHours,
    required this.contactNumber,
    required this.email,
    required this.availableTests, // ✅ Required parameter
    required this.onViewTests,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            Text(location, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(rating.toStringAsFixed(1)),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              about,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(openingHours),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(contactNumber),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.email, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(email),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: onViewTests,
                  child: const Text('View Tests'),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LabDetailsScreen(
                          labName: labName,
                          labImageUrl: 'https://media.istockphoto.com/id/493302504/photo/testing-substances.jpg?s=612x612&w=0&k=20&c=zxRr8On95eALl__Ff06rasZZt6oOud8gGH0_8GFRTH8=',
                          location: location,
                          rating: rating,
                          about: about,
                          openingHours: openingHours,
                          contactNumber: contactNumber,
                          email: email,
                          availableTests: availableTests, // ✅ Fix: pass it here
                        ),
                      ),
                    );
                  },
                  child: const Text('Lab Details'),
                ),

                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.cyan,
                    side: const BorderSide(color: Colors.cyan),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: onBookNow,
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
