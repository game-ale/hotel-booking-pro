import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploader extends StatefulWidget {
  final void Function(String url) onImageUploaded;
  const ImageUploader({super.key, required this.onImageUploaded});

  @override
  State<ImageUploader> createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  File? _imageFile;
  bool _uploading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => _imageFile = File(picked.path));
    await _uploadImage();
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    setState(() => _uploading = true);

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('hotel_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(_imageFile!);
      final url = await storageRef.getDownloadURL();
      widget.onImageUploaded(url);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Image uploaded successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _imageFile == null
            ? const Icon(Icons.image, size: 100, color: Colors.grey)
            : Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _uploading ? null : _pickImage,
          icon: const Icon(Icons.upload),
          label: Text(_uploading ? "Uploading..." : "Upload Image"),
        ),
      ],
    );
  }
}
