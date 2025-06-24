import 'package:flutter/material.dart';
import 'package:mylab_go/screens/user_profile.dart';
import 'package:mylab_go/screens/home.dart';
import 'package:mylab_go/screens/reports.dart';
import 'package:mylab_go/screens/track_booking_screen.dart';

class CustomDrawer extends StatelessWidget {
  final void Function(String page) onNavigate;

  const CustomDrawer({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.cyan),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("MyLabGo", style: TextStyle(color: Colors.white, fontSize: 24)),
                SizedBox(height: 8),
                Text("Navigation", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => onNavigate("home"),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () => onNavigate("profile"),
          ),
          ListTile(
            leading: const Icon(Icons.file_copy),
            title: const Text("Reports"),
            onTap: () => onNavigate("reports"),
          ),
          ListTile(
            leading: const Icon(Icons.track_changes),
            title: const Text("Track Booking"),
            onTap: () => onNavigate("track_booking"),
          ),
        ],
      ),
    );
  }
}
