import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/buttons/custom_booking_button.dart';
import '../track_booking_screen.dart';

class OrderScreen extends StatefulWidget {
  final String testName;
  final String labId;
  final String testId;
  final bool canBeDoneFromHome;
  final String estimatedTime;

  const OrderScreen({
    super.key,
    required this.testName,
    required this.labId,
    required this.testId,
    required this.canBeDoneFromHome,
    required this.estimatedTime,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? _selectedMethod;
  String? _paymentMethod;
  bool _isSubmitting = false;

  void _proceedToConfirmation(String method) {
    setState(() => _selectedMethod = method);
  }

  Future<void> _confirmBooking() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnack("❌ You must be logged in");
      setState(() => _isSubmitting = false);
      return;
    }

    if (_paymentMethod == null) {
      _showSnack("❌ Please select a payment method");
      setState(() => _isSubmitting = false);
      return;
    }

    if (widget.labId.isEmpty || widget.testId.isEmpty) {
      _showSnack("❌ Invalid lab or test ID");
      setState(() => _isSubmitting = false);
      return;
    }

    try {
      final now = DateTime.now();
      final firestore = FirebaseFirestore.instance;

      final labPath = "LabData/${widget.labId}";
      final testPath = "$labPath/Tests/${widget.testId}";
      final userPath = "UserData/${user.uid}";

      final orderRef = firestore.collection("$labPath/Orders").doc(); // auto-id
      
      await orderRef.set({
        "user_id": firestore.doc(userPath),
        // Ensure test_id is the actual Firestore document reference, not an index
        "test_id": firestore.collection("$labPath/Tests").doc(widget.testId),
        "labid": firestore.doc(labPath),
        "data-time": Timestamp.fromDate(now),
        "paymentMethod": _paymentMethod,
        "bookingType": _selectedMethod,
        "status": "pending",
        "acceptance": false,
      });

      _showSnack("✅ Booking submitted successfully");
      if (mounted) {
        Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => TrackBookingScreen(
      labId: widget.labId,
      orderId: orderRef.id, // pass the auto-generated ID
      bookingType: _selectedMethod!,
    ),
  ),
);

      }
    } catch (e) {
      _showSnack("❌ Booking failed: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final fromHome = widget.canBeDoneFromHome;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Test"),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _selectedMethod == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select how you'd like to proceed:",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  if (fromHome)
                    CustomBookingButton(
                      label: "Get test done from home",
                      testName: widget.testName,
                      labId: widget.labId,
                      testId: widget.testId,
                      canBeDoneFromHome: widget.canBeDoneFromHome,
                      estimatedTime: widget.estimatedTime,
                      onTap: () => _proceedToConfirmation("home"),
                    ),
                  const SizedBox(height: 10),
                  CustomBookingButton(
                    label: "Visit lab (Est. Time: ${widget.estimatedTime})",
                    testName: widget.testName,
                    labId: widget.labId,
                    testId: widget.testId,
                    canBeDoneFromHome: widget.canBeDoneFromHome,
                    estimatedTime: widget.estimatedTime,
                    onTap: () => _proceedToConfirmation("visit"),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Confirm Booking",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text("🧪 Test: ${widget.testName}"),
                  Text("📍 Lab ID: ${widget.labId}"),
                  Text("⏰ Estimated Time: ${widget.estimatedTime}"),
                  const SizedBox(height: 20),
                  const Text(
                    "Select Payment Method:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RadioListTile(
                    value: "easypaisa",
                    groupValue: _paymentMethod,
                    title: const Text("Easypaisa"),
                    onChanged: _selectedMethod == "home"
                        ? (val) =>
                            setState(() => _paymentMethod = val as String?)
                        : null,
                  ),
                  RadioListTile(
                    value: "cash",
                    groupValue: _paymentMethod,
                    title: const Text("Cash on Delivery"),
                    onChanged: (val) =>
                        setState(() => _paymentMethod = val),
                  ),
                  const SizedBox(height: 20),
                  CustomBookingButton(
                    label: _isSubmitting ? "Booking..." : "Confirm Booking",
                    testName: widget.testName,
                    labId: widget.labId,
                    testId: widget.testId,
                    canBeDoneFromHome: widget.canBeDoneFromHome,
                    estimatedTime: widget.estimatedTime,
                    onTap: _confirmBooking,
                    isLoading: _isSubmitting,
                  ),
                ],
              ),
      ),
    );
  }
}
