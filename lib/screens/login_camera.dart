import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FaceLoginPage extends StatefulWidget {
  const FaceLoginPage({super.key});
  @override State<FaceLoginPage> createState() => _FaceLoginPageState();
}

class _FaceLoginPageState extends State<FaceLoginPage> {
  late CameraController _cameraController;
  late FaceDetector _faceDetector;
  final bool _detecting = false;
  XFile? _captured;

  @override
  void initState() {
    super.initState();
    _init();
    _faceDetector = FaceDetector(options: FaceDetectorOptions());
  }
  Future<void> _init() async {
    final cams = await availableCameras();
    _cameraController = CameraController(cams.first, ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() {});
  }

  Future<void> _captureAndLogin() async {
    final file = await _cameraController.takePicture();
    final faces = await _faceDetector.processImage(InputImage.fromFilePath(file.path));
    if (faces.isEmpty) {
      return _showMsg('No face detected');
    }
    _attemptMatch(file.path);
  }

  Future<void> _attemptMatch(String path) async {
    final users = await FirebaseFirestore.instance.collection('FaceUsers').get();
    for (var doc in users.docs) {
      final url = doc['photoUrl'] as String;
      final same = url.contains('image-auth'); // crude match — placeholder
      if (same) {
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }
    }
    _showMsg('No matching user');
  }

  void _showMsg(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override void dispose() {
    _cameraController.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override Widget build(BuildContext c) {
    if (!_cameraController.value.isInitialized) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(title: const Text('Face Login')),
      body: Column(children: [
        Expanded(child: CameraPreview(_cameraController)),
        ElevatedButton(onPressed: _captureAndLogin, child: const Text('Login')),
      ]),
    );
  }
}
