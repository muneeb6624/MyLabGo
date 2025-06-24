// lib/screens/tests_screen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_tests_card.dart';
import '../models/test_data.dart';

class TestsScreen extends StatelessWidget {
  final String labName;
  final String labId;
  final List<TestData> tests;

  const TestsScreen({
    super.key,
    required this.labName,
    required this.labId,
    required this.tests,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Tests in $labName'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Tests in $labName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tests.isEmpty
                  ? const Center(
                      child: Text(
                        'No tests available.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tests.length,
                      itemBuilder: (context, index) {
                        final test = tests[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: CustomTestsCard(
                            testName: test.name,
                            price: test.price,
                            duration: test.duration,
                            description: test.description,
                            canBeDoneFromHome: test.homeOrder,
                            labId: labId,
                            testId: test.testId,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
