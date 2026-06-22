import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addReview(Map<String,dynamic> review) async {
    await _firestore.collection('reviews').add(review);


  }

  Future<void> addQuery(Map<String,dynamic> query) async {
    if (query['image'] != null) {
      final imageBytes = query['image'] as Uint8List;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('queries/$fileName');
      await ref.putData(imageBytes);

      // Save only the path, not the URL
      query['imagePath'] = 'queries/$fileName';
      query.remove('image'); // remove raw image bytes
    }

    await _firestore.collection('queries').add(query);
  }

}