import 'package:flutter/material.dart';
import '../screens/lab_details.dart';
import '../screens/tests_screen.dart';


class CustomLabCard extends StatelessWidget {
  final String labName;
  final String? labImageUrl;
  final String location;
  final double rating;
  final String about;
  final String openingHours;
  final String contactNumber;
  final String email;
  final VoidCallback onViewTests;
  final VoidCallback onBookNow;

  const CustomLabCard({
    Key? key,
    required this.labName,
    this.labImageUrl,
    required this.location,
    required this.rating,
    required this.about,
    required this.openingHours,
    required this.contactNumber,
    required this.email,
    required this.onViewTests,
    required this.onBookNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 5),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LabDetailsScreen(
                          labName: labName,
                          labImageUrl: labImageUrl,
                          location: location,
                          rating: rating,
                          about: about,
                          openingHours: openingHours,
                          contactNumber: contactNumber,
                          email: email,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                  ),
                  child: const Text('View Lab'),
                ),
                ElevatedButton(
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => TestsScreen(
                      labName: labName,
                      tests: [], // Pass the appropriate list of TestData here
                    ),
                    ),
                  );
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  ),
                  child: const Text('Tests'),
                ),
                ElevatedButton(
                  onPressed: onBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
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
