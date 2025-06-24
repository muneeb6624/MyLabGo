import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/report_card.dart';

class TrackBookingScreen extends StatelessWidget {
  final String labId;
  final String orderId;
  final String bookingType;

  const TrackBookingScreen({
    super.key,
    required this.labId,
    required this.orderId,
    required this.bookingType,
  });

  @override
  Widget build(BuildContext context) {
    final orderDocRef = FirebaseFirestore.instance
        .collection('LabData')
        .doc(labId)
        .collection('Orders')
        .doc(orderId);

    final reportCollection = FirebaseFirestore.instance
        .collection('LabData')
        .doc(labId)
        .collection('Reports');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Booking'),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: orderDocRef.snapshots(),
        builder: (context, orderSnap) {
          if (orderSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!orderSnap.hasData || !orderSnap.data!.exists) {
            return const Center(child: Text("❌ Booking not found."));
          }

          final orderData = orderSnap.data!.data() as Map<String, dynamic>;
          final status = orderData['status'] ?? 'pending';
          final fetchedBookingType = orderData['bookingType'] ?? 'visit';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fetchedBookingType == 'home') ...[
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("🚗 Rider is arriving soon...",
                      style: TextStyle(fontSize: 18)),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text("🩺 Current Status: $status",
                    style: const TextStyle(fontSize: 18)),
              ),

              if (status == 'completed') ...[
                StreamBuilder<QuerySnapshot>(
                  stream: reportCollection
                      .where('orderId', isEqualTo: orderId)
                      .snapshots(),
                  builder: (context, reportSnap) {
                    if (reportSnap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("⏳ Waiting for your report to be uploaded...",
                            style: TextStyle(fontSize: 16)),
                      );
                    }

                    if (reportSnap.hasError) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("⚠️ Error fetching report.",
                            style: TextStyle(fontSize: 16)),
                      );
                    }

                    if (!reportSnap.hasData || reportSnap.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("⏳ Report not available yet.",
                            style: TextStyle(fontSize: 16)),
                      );
                    }

                    final report = reportSnap.data!.docs.first.data()
                        as Map<String, dynamic>;

                    return ReportCard(
                      createdAt: (report['createdAt'] as Timestamp).toDate(),
                      reportUrl: report['reportUrl'],
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
