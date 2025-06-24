import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/custom_tests_card.dart';
import '../models/test_data.dart';
// import '../widgets/buttons/custom_booking_button.dart';

class LabDetailsScreen extends StatefulWidget {
  final String labId;
  final String labName;
  final String? labImageUrl;
  final String location;
  final double rating;
  final String about;
  final String openingHours;
  final String contactNumber;
  final String email;
  final double latitude;
  final double longitude;

  const LabDetailsScreen({
    super.key,
    required this.labId,
    required this.labName,
    this.labImageUrl,
    required this.location,
    required this.rating,
    required this.about,
    required this.openingHours,
    required this.contactNumber,
    required this.email,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<LabDetailsScreen> createState() => _LabDetailsScreenState();
}

class _LabDetailsScreenState extends State<LabDetailsScreen> {
  List<TestData> _testList = [];
  List<Map<String, dynamic>> _feedbackList = [];
  double _userRating = 3.0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTests();
    _fetchFeedback();
  }

  Future<void> _fetchTests() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('LabData')
        .doc(widget.labId)
        .collection('Tests')
        .get();

    setState(() {
      _testList = snapshot.docs
          .map((doc) => TestData.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> _fetchFeedback() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('LabData')
        .doc(widget.labId)
        .collection('Feedback')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _feedbackList = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _submitFeedback() async {
    if (_reviewController.text.trim().isEmpty && _userRating == 0) return;

    await FirebaseFirestore.instance
        .collection('LabData')
        .doc(widget.labId)
        .collection('Feedback')
        .add({
      'rating': _userRating,
      'review': _reviewController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    _reviewController.clear();
    _userRating = 3.0;
    _fetchFeedback();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback submitted!')),
    );
  }

  double _calculateAverageRating() {
    if (_feedbackList.isEmpty) return widget.rating;

    final ratings = _feedbackList
        .map((e) => (e['rating'] ?? 0).toDouble())
        .where((r) => r > 0)
        .toList();

    if (ratings.isEmpty) return widget.rating;

    final total = ratings.reduce((a, b) => a + b);
    return (total / ratings.length);
  }

  @override
  Widget build(BuildContext context) {
    final avgRating = _calculateAverageRating();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.labName),
        backgroundColor: Colors.cyan,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Go to Location'),
        icon: const Icon(Icons.location_on),
        backgroundColor: Colors.cyan,
        onPressed: () {
          final url =
              'https://www.google.com/maps/search/?api=1&query=${widget.latitude},${widget.longitude}';
          launchUrl(Uri.parse(url));
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labImageUrl != null)
              Center(
                child: Image.network(widget.labImageUrl!, height: 200),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Rating: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                RatingBarIndicator(
                  rating: avgRating,
                  itemCount: 5,
                  itemSize: 24,
                  unratedColor: Colors.grey[300],
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.cyan),
                ),
                const SizedBox(width: 8),
                Text(avgRating.toStringAsFixed(1)),
              ],
            ),
            const SizedBox(height: 12),

            _tableRow('Location', widget.location),
            _tableRow('Opening Hours', widget.openingHours),
            _tableRow('Contact', widget.contactNumber),
            _tableRow('Email', widget.email),
            const SizedBox(height: 16),

            const Text('About the Lab', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.about),
            const SizedBox(height: 16),

            const Text('Tests Offered', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan)),
            const SizedBox(height: 10),
            if (_testList.isEmpty)
              const Text("No tests listed."),
            ..._testList.map((test) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomTestsCard(
                labId: widget.labId,
                testId: test.testId,
                testName: test.name,
                price: test.price,
                duration: test.duration,
                description: test.description,
                canBeDoneFromHome: test.homeOrder,
                onBook: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${test.name} booked!')),
                  );
                },
              ),
            )),

            const Divider(height: 30, thickness: 1),

            const Text('Give Your Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: _userRating,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.cyan),
              onRatingUpdate: (rating) => setState(() => _userRating = rating),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reviewController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Write a review...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text("Submit Feedback", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: _submitFeedback,
            ),

            const Divider(height: 30, thickness: 1),
            const Text('User Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (_feedbackList.isEmpty)
              const Text("No reviews yet."),
            ..._feedbackList.map((feedback) {
              final rating = (feedback['rating'] ?? 0).toDouble();
              final review = feedback['review'] ?? '';
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.cyan),
                  title: Text('Rating: ${rating.toStringAsFixed(1)}'),
                  subtitle: review.isNotEmpty ? Text(review) : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
