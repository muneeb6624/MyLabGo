// lib/widgets/custom_tests_card.dart

import 'package:flutter/material.dart';
import '../screens/test_details.dart';

class CustomTestsCard extends StatelessWidget {
  final String labId;
  final String testId;
  final String testName;
  final double price;
  final int duration;
  final String? description;
  final bool canBeDoneFromHome;
  final VoidCallback? onBook; // Optional callback for book button

  const CustomTestsCard({
    super.key,
    required this.labId,
    required this.testId,
    required this.testName,
    required this.price,
    required this.duration,
    required this.description,
    required this.canBeDoneFromHome,
    this.onBook, // optional
  });

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestDetailsScreen(
          testName: testName,
          price: price,
          duration: '$duration minutes',
          description: description ?? '',
          labId: labId,
          testId: testId,
          canBeDoneFromHome: canBeDoneFromHome,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              testName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.grey),
                const SizedBox(width: 5),
                Text('Rs. ${price.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.grey),
                const SizedBox(width: 5),
                Text('$duration minutes'),
              ],
            ),
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.description, color: Colors.grey),
                  const SizedBox(width: 5),
                  Expanded(child: Text(description!)),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _navigateToDetails(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  icon: const Icon(Icons.info_outline),
                  label: const Text("Test Details", style: TextStyle(color: Colors.white), ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onBook ??
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TestDetailsScreen(
                              testName: testName,
                              price: price,
                              duration: '$duration minutes',
                              description: description ?? '',
                              labId: labId,
                              testId: testId,
                              canBeDoneFromHome: canBeDoneFromHome,
                            ),
                          ),
                        );
                      },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  icon: const Icon(Icons.check),
                  label: const Text("Book", style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
