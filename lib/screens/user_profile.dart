import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  bool _loading = true;
  bool _saving = false;

  String name = '';
  String email = '';
  String gender = '';
  String age = '';
  String role = '';
  DateTime? createdAt;

  late final String uid;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    uid = user.uid;
    final docRef = _db.collection('UserData').doc(uid);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      final data = docSnap.data()!;
      setState(() {
        name = data['name'] ?? '';
        email = data['email'] ?? '';
        gender = data['gender'] ?? '';
        age = data['age'] ?? '';
        role = data['role'] ?? '';
        createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data not found')),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await _db.collection('UserData').doc(uid).update({
        'name': name,
        'email': email,
        'gender': gender,
        'age': age,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profile updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to update profile: $e')),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.cyan,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      label: 'Name',
                      value: name,
                      onChanged: (val) => name = val,
                    ),
                    _buildTextField(
                      label: 'Email',
                      value: email,
                      onChanged: (val) => email = val,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      label: 'Age',
                      value: age,
                      onChanged: (val) => age = val,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      label: 'Gender',
                      value: gender,
                      onChanged: (val) => gender = val,
                    ),
                    const SizedBox(height: 12),
                    if (role.isNotEmpty)
                      Text('Role: $role', style: const TextStyle(fontSize: 16)),
                    if (createdAt != null)
                      Text('Joined: ${createdAt!.toLocal().toString().split('.')[0]}',
                          style: const TextStyle(color: Colors.grey)),

                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _saving ? null : _saveChanges,
                      icon: const Icon(Icons.save),
                      label: _saving
                          ? const Text('Saving...')
                          : const Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required void Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (val) =>
            (val == null || val.trim().isEmpty) ? 'Required field' : null,
      ),
    );
  }
}
