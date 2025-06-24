// lib/widgets/report_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';


class ReportCard extends StatelessWidget {
  final DateTime createdAt;
  final String reportUrl;

  const ReportCard({
    super.key,
    required this.createdAt,
    required this.reportUrl,
  });


void openReportUrl(String url) async {
  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // ✅ opens in browser or PDF viewer
    );
  } else {
    // fallback error
    debugPrint('Could not launch $url');
  }
}


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("📄 Report Available", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("🕒 Uploaded: ${createdAt.toLocal()}"),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Download Report"),
              onPressed: () => openReportUrl(reportUrl),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
            ),
          ],
        ),
      ),
    );
  }
}
