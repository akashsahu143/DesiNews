
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:desishot_app/models/content.dart';
import 'package:desishot_app/services/firestore_service.dart';

class UploadContentScreen extends StatefulWidget {
  @override
  _UploadContentScreenState createState() => _UploadContentScreenState();
}

class _UploadContentScreenState extends State<UploadContentScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;
  ContentType? _contentType;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _pickMedia(ImageSource source, ContentType type) async {
    final XFile? file = await _picker.pickMedia();
    setState(() {
      _pickedFile = file;
      _contentType = type;
    });
  }

  Future<void> _uploadContent() async {
    if (_pickedFile == null || _contentType == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a file, choose a type, and enter a title.')));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef = FirebaseStorage.instance.ref().child("${_contentType == ContentType.video ? 'videos' : 'memes'}/$fileName");
      final UploadTask uploadTask = storageRef.putFile(File(_pickedFile!.path));
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not logged in.')));
        setState(() {
          _isUploading = false;
        });
        return;
      }

      final Content newContent = Content(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: currentUser.uid,
        url: downloadUrl,
        type: _contentType!,
        title: _titleController.text,
        description: _descriptionController.text,
        timestamp: Timestamp.now(),
        approved: false, // Content needs admin approval
      );

      await _firestoreService.saveContent(newContent);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Content uploaded successfully! Awaiting admin approval.')));
      setState(() {
        _pickedFile = null;
        _contentType = null;
        _titleController.clear();
        _descriptionController.clear();
        _isUploading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload content: $e')));
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Content'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_pickedFile != null)
              _contentType == ContentType.video
                  ? Container(
                      height: 200,
                      child: Center(child: Icon(Icons.video_file, size: 100)),
                    ) // Placeholder for video
                  : Image.file(File(_pickedFile!.path), height: 200),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _pickMedia(ImageSource.gallery, ContentType.video),
              icon: Icon(Icons.video_library),
              label: Text('Pick Video'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _pickMedia(ImageSource.gallery, ContentType.meme),
              icon: Icon(Icons.image),
              label: Text('Pick Meme'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            _isUploading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _uploadContent,
                    child: Text('Upload'),
                  ),
          ],
        ),
      ),
    );
  }
}


