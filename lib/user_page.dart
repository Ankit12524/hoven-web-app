import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:basic_hoven_website/firebase_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _reviewFormKey = GlobalKey<FormState>();
  final _queryFormKey = GlobalKey<FormState>();
  bool _isSubmitted = false;
  bool _isSubmitting = false;
  int _coolDown = 0;
  Timer? _timer;
  late final FirebaseData _firestore = FirebaseData();


  String _reviewerName = '';
  String _reviewText = '';
  int _rating = 0;

  String _queryName = '';
  String _queryEmail = '';
  String _queryMessage = '';

  Uint8List? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
        _selectedImage = await pickedFile.readAsBytes();
        setState(() {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coming Soon Banner
            _buildComingSoonBanner(),
            const SizedBox(height: 24),

            // Review Section
            _buildQuerySection(),
            const SizedBox(height: 32),

            // Query/Contact Form Section
            _buildReviewSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }



  Widget _buildComingSoonBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.celebration, size: 40),
          const SizedBox(height: 8),
          Text(
            'Online Ordering & Login Feature Coming Soon!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re working hard to bring you a seamless shopping experience. Stay tuned for updates!',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share Your Experience',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'We value your feedback! Let us know how we\'re doing.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Form(
          key: _reviewFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _reviewerName = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              // Star Rating
              _buildStarRating(),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Suggestion or Review',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please share your experience';
                  }
                  return null;
                },
                onSaved: (value) {
                  _reviewText = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitted || _isSubmitting ? null : _submitReview,
                  child: _isSubmitted ? Text("Wait $_coolDown seconds") : _isSubmitting ? const CircularProgressIndicator() : const Text('Send Review'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStarRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
              icon: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 32,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildQuerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get in Touch',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Have order-related question or special requests? Send us a message. Get a Response in minutes',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Form(
          key: _queryFormKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _queryName = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Number';
                  }
                  if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Please enter a valid Number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _queryEmail = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Query or Message',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
                onSaved: (value) {
                  _queryMessage = value ?? '';
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: _selectedImage == null ? ElevatedButton.icon(
                  icon: Icon(Icons.add_photo_alternate),
                  onPressed:   _pickImage,
                  label : const Text('Add Image'),
                ) : ElevatedButton.icon(
                  icon: Icon(Icons.hide_image_outlined),
                  label : const Text('Remove Image'),
                  onPressed: () {setState(() {
                    _selectedImage = null;
                  });} ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitted || _isSubmitting ? null : _submitQuery,
                  child: _isSubmitted ? Text("Wait $_coolDown seconds") : _isSubmitting ? const CircularProgressIndicator() : const Text('Send Message'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitReview() async {
    if (_reviewFormKey.currentState!.validate() && _rating > 0) {




      _reviewFormKey.currentState!.save();

      setState(() {
        _isSubmitting = true;
      });

      await _firestore.addReview({
        'name': _reviewerName,
        'review': _reviewText,
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thank You!'),
          content: Text('Thanks for your review, $_reviewerName! Your feedback helps us improve.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      // Reset form
      _reviewFormKey.currentState!.reset();
      setState(() {
        _rating = 0;
        _isSubmitting = false;
      });

      setState(() {
        _isSubmitted = true;
        _coolDown = 60;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_coolDown == 0) {
          _timer!.cancel();
          setState(() {
            _isSubmitted = false;
          });
        } else {
          setState(() {
            _coolDown--;
          });
        }
      });

    } else if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
    }
  }

  void _submitQuery() async {
    if (_queryFormKey.currentState!.validate()) {

      setState(() {
        _isSubmitting = true;
      });

      _queryFormKey.currentState!.save();

      await _firestore.addQuery({
        'name': _queryName,
        'contact': _queryEmail,
        'message': _queryMessage,
        'timestamp': FieldValue.serverTimestamp(),
        'image': _selectedImage,
        'isRead' : false
      });


      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Message Sent!'),
          content: const Text('Thank you for reaching out. We\'ll get back to you soon.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      // Reset form
      _queryFormKey.currentState!.reset();
      _selectedImage = null;
      _isSubmitting = false;
      setState(() {
        _isSubmitted = true;
        _coolDown = 60;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_coolDown == 0) {
          _timer!.cancel();
          setState(() {
            _isSubmitted = false;
          });
        } else {
          setState(() {
            _coolDown--;
          });
        }
      });

    }
  }
}