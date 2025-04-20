// filepath: lib/widgets/custom_tests_card.dart
import 'package:flutter/material.dart';

class CustomTestsCard extends StatelessWidget {
  final String testName;
  final double price;
  final String duration;
  final String? description;
  final VoidCallback onBook;

  const CustomTestsCard({
    Key? key,
    required this.testName,
    required this.price,
    required this.duration,
    this.description,
    required this.onBook,
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
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.description, color: Colors.grey),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      description!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Book'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
