// lib/screens/reports.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/report_card.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final userId = FirebaseAuth.instance.currentUser?.uid;
    // final reportsQuery = FirebaseFirestore.instance
    //     .collectionGroup('Reports')
    //     .where('userId', isEqualTo: userId)
    //     .orderBy('createdAt', descending: true);

final userId = FirebaseAuth.instance.currentUser?.uid;
final reportsQuery = FirebaseFirestore.instance
    .collection('UserData')
    .doc(userId)
    .collection('Reports')
    .orderBy('createdAt', descending: true);


    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reports"),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reportsQuery.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text("No reports available."));
          }

          return ListView(
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ReportCard(
                createdAt: (data['createdAt'] as Timestamp).toDate(),
                reportUrl: data['reportUrl'],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
