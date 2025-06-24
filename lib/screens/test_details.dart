import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mylab_go/screens/order-screen/orderscreen.dart'; // update path if needed


class TestDetailsScreen extends StatelessWidget {
  final String testName;
  final double price;
  final String duration;
  final String description;
  final String labId;
  final String testId;
  final bool canBeDoneFromHome;

  const TestDetailsScreen({
    super.key,
    required this.testName,
    required this.price,
    required this.duration,
    required this.description,
    required this.labId,
    required this.testId,
    required this.canBeDoneFromHome,
  });

  void _launchMap() async {
    const dummyLat = 24.8607;
    const dummyLng = 67.0011;
    const url = 'https://www.google.com/maps/search/?api=1&query=$dummyLat,$dummyLng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint("Could not launch map");
    }
  }
void _goToBooking(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => OrderScreen(
        testName: testName,
        labId: labId, 
        testId: testId, 
        canBeDoneFromHome: true, // or false based on logic
        estimatedTime: duration,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(testName),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              testName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.cyan),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  duration,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description.isNotEmpty ? description : "No description available.",
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _launchMap,
                  icon: const Icon(Icons.map),
                  label: const Text('See Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _goToBooking(context),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Book Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

