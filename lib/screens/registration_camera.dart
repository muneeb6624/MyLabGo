import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cloudinary_service.dart';

class FaceRegisterPage extends StatefulWidget {
  const FaceRegisterPage({super.key});
  @override
  State<FaceRegisterPage> createState() => _FaceRegisterPageState();
}

class _FaceRegisterPageState extends State<FaceRegisterPage> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  bool _detecting = false;
  XFile? _captured;
  final _name = TextEditingController();
  final _age = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initCamera();
    _faceDetector = FaceDetector(options: FaceDetectorOptions());
  }

  Future<void> _initCamera() async {
    final cams = await availableCameras();
    if (cams.isNotEmpty) {
      _cameraController = CameraController(cams.first, ResolutionPreset.medium);
      await _cameraController!.initialize();
      if (mounted) setState(() {});
    }
  }

  Future<void> _capture() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _cameraController!.value.isTakingPicture) {
      return;
    }
    final file = await _cameraController!.takePicture();
    _captured = file;
    await _analyze(file);
    setState(() {});
  }

  Future<void> _analyze(XFile file) async {
    final inputImage = InputImage.fromFilePath(file.path);
    if (_detecting) return;
    _detecting = true;
    final faces = await _faceDetector.processImage(inputImage);
    _detecting = false;

    if (faces.isEmpty) {
      _showMsg('No face detected — try again');
      _captured = null;
      setState(() {});
      return;
    }
    _showForm();
  }

  void _showForm() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter your Name & Age'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: _name, decoration: const InputDecoration(hintText: 'Name')),
          TextField(controller: _age, decoration: const InputDecoration(hintText: 'Age'), keyboardType: TextInputType.number),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () {
            Navigator.pop(context);
            _saveUser();
          }, child: const Text('Submit')),
        ],
      ),
    );
  }

  void _showMsg(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _saveUser() async {
    if (_captured == null || _name.text.trim().isEmpty || _age.text.trim().isEmpty) {
      _showMsg('Complete all fields');
      return;
    }
    final url = await uploadImageToCloudinary(_captured!.path);
    await FirebaseFirestore.instance.collection('FaceUsers').add({
      'name': _name.text.trim(),
      'age': int.parse(_age.text.trim()),
      'photoUrl': url,
      'createdAt': FieldValue.serverTimestamp(),
    });
    _showMsg('Registration done—proceed to login');
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    _name.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Face Register')),
      body: Column(children: [
        Expanded(child: CameraPreview(_cameraController!)),
        if (_captured != null) const Text('Ready to register', style: TextStyle(color: Colors.green)),
        ElevatedButton(onPressed: _capture, child: const Text('Capture')),
      ]),
    );
  }
}
