import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/custom-lab-card.dart';
import 'tests_screen.dart';

import './lab_details.dart';

class Lab {
  final String labName;
  final String locationString;
  final String email;
  final String about;
  final double rating;
  final List<TestData> tests;
  final double latitude;
  final double longitude;
  final String imgUrl;
  final String docId;
  final double distanceKm;

  Lab({
    required this.labName,
    required this.locationString,
    required this.email,
    required this.about,
    required this.rating,
    required this.tests,
    required this.latitude,
    required this.longitude,
    required this.imgUrl,
    required this.docId,
    required this.distanceKm,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Lab> _allLabs = [];
  List<Lab> _filteredLabs = [];
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    _loadLabs();
  }

  Future<void> _loadLabs() async {
    try {
      // 👇👇 MOCK LOCATION for web/Chrome
      _userPosition = Position(
        latitude: 35.6895, // Tokyo
        longitude: 139.6917,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 1.0,
        headingAccuracy: 1.0,
      );

      // ✅ THIS is the real logic — uncomment this on Android/iOS real device
      // _userPosition = await Geolocator.getCurrentPosition();

      final snapshot = await FirebaseFirestore.instance.collection('LabData').get();

      List<Lab> labs = [];

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final latLng = data['location'];
        if (latLng == null) continue;

        final double labLat = latLng.latitude ?? 0.0;
        final double labLng = latLng.longitude ?? 0.0;

        final distance = _calculateDistance(
          _userPosition!.latitude,
          _userPosition!.longitude,
          labLat,
          labLng,
        );

        labs.add(
          Lab(
            docId: doc.id,
            labName: data['labName'] ?? 'N/A',
            locationString: data['locationString'] ?? 'N/A',
            email: data['email'] ?? 'N/A',
            about: data['description'] ?? 'N/A',
            rating: 4.0, // Static for now
            tests: [],   // Will be added later
            latitude: labLat,
            longitude: labLng,
            imgUrl: data['imgUrl'] ?? '',
            distanceKm: distance,
          ),
        );
      }

      labs.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

      setState(() {
        _allLabs = labs;
        _filteredLabs = labs;
      });
    } catch (e) {
      debugPrint('❌ Error loading labs: $e');
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth radius in km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  void _filterLabs(String query) {
    if (query.isEmpty) {
      setState(() => _filteredLabs = _allLabs);
      return;
    }

    final lower = query.toLowerCase();
    final filtered = _allLabs.where((lab) {
      return lab.labName.toLowerCase().contains(lower) ||
          lab.email.toLowerCase().contains(lower) ||
          lab.locationString.toLowerCase().contains(lower);
    }).toList();

    setState(() => _filteredLabs = filtered);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final doc = await FirebaseFirestore.instance.collection('UserData').doc(uid).get();
    return doc.data();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyLabGo'),
        backgroundColor: Colors.cyan,
        actions: [
          FutureBuilder<Map<String, dynamic>?>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              final user = snapshot.data!;
              final name = user['name'] ?? 'User';
              final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
              return Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              );
            },
          )
        ],
      ),
      body: _userPosition == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _filterLabs,
                    decoration: InputDecoration(
                      hintText: 'Search labs/test...',
                      prefixIcon: const Icon(Icons.search, color: Colors.cyan),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Available Labs',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_filteredLabs.isEmpty)
                    const Text("No labs found 😢"),
                  ..._filteredLabs.map((lab) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: CustomLabCard(
                        labName: lab.labName,
                        location: lab.locationString,
                        rating: lab.rating,
                        about: lab.about,
                        openingHours: 'N/A',
                        contactNumber: 'N/A',
                        email: lab.email,
                        availableTests: lab.tests,
                        imageUrl: lab.imgUrl,
                        onViewTests: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestsScreen(
                                labName: lab.labName,
                                tests: lab.tests,
                              ),
                            ),
                          );
                        },
                        onBookNow: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Booking ${lab.labName}')),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
