import 'package:flutter/material.dart';

class CustomBookingButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  // For order selection screen props (optional)
  final String? testName;
  final String? labId;
  final String? testId;
  final bool? canBeDoneFromHome;
  final String? estimatedTime;

  const CustomBookingButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.testName,
    this.labId,
    this.testId,
    this.canBeDoneFromHome,
    this.estimatedTime,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: Colors.cyan,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
    );
  }
}
