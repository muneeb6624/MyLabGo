// filepath: lib/models/test_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TestData {
  final String testId;
  final String name;
  final double price;
  final int duration;
  final String description;
  final bool homeOrder;

  TestData({
    required this.testId,
    required this.name,
    required this.price,
    required this.duration,
    required this.description,
    required this.homeOrder,
  });

 factory TestData.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return TestData(
    testId: doc.id, // this is the test_id to be passed to testscreen and lab-details
    name: data['testName'] ?? 'Unknown',
    price: (data['price'] ?? 0).toDouble(),
    duration: data['estimatedTime'] ?? 0,
    description: data['description'] ?? '',
    homeOrder: data['homeOrder'] ?? false,
  );
}
}
