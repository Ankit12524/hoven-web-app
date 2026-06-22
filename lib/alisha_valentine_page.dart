import 'dart:math';
import 'package:flutter/material.dart';

class AlishaValentinePage extends StatefulWidget {
  const AlishaValentinePage({super.key});

  @override
  State<AlishaValentinePage> createState() => _AlishaValentinePageState();
}

class _AlishaValentinePageState extends State<AlishaValentinePage> {
  // State variables
  bool _isAccepted = false; // Has she said yes?
  bool _showYesButton = false; // Is the Yes button visible yet?
  int _noAttempts = 0; // How many times has she tried to click No?

  // Position for the running "No" button
  double _noLeft = 0.0;
  double _noTop = 0.0;

  // To initialize position on first build
  bool _firstBuild = true;

  final Random _random = Random();

  @override
  Widget build(BuildContext context) {
    // Get screen size to calculate boundaries
    final size = MediaQuery.of(context).size;

    // Center the button initially
    if (_firstBuild) {
      _noLeft = size.width / 2 - 50; // Center horizontal roughly
      _noTop = size.height / 2 + 50; // Slightly below center
      _firstBuild = false;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Lavender Blush (light pink)
      body: Stack(
        children: [
          // Background decorations (Plants & Hearts)
          Positioned(
            top: -50,
            left: -50,
            child: Icon(Icons.local_florist, size: 200, color: Colors.green.withOpacity(0.1)),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Icon(Icons.favorite, size: 200, color: Colors.pink.withOpacity(0.1)),
          ),

          // Main Content
          Center(
            child: _isAccepted
                ? _buildSuccessMessage()
                : _buildQuestionInterface(size),
          ),

          // The Running "No" Button (Only shows if not accepted)
          if (!_isAccepted)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              left: _noLeft,
              top: _noTop,
              child: MouseRegion(
                onEnter: (_) => _moveNoButton(size), // For Web (Hover)
                child: GestureDetector(
                  onTap: () => _moveNoButton(size), // For Mobile (Tap)
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(2, 2))
                      ],
                    ),
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 1. The Question Interface
  Widget _buildQuestionInterface(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Cute Header Image (Cat + Heart)
        const Icon(Icons.pets, size: 80, color: Colors.brown),
        const SizedBox(height: 10),
        const Icon(Icons.favorite, size: 40, color: Colors.red),
        const SizedBox(height: 30),

        // The Question
        const Text(
          "Will you be my Valentine?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent,
            fontFamily: 'Cursive', // Ensure you have a nice font or remove this line
          ),
        ),

        const SizedBox(height: 20),

        // Hint text while she chases the button
        Text(
          _noAttempts < 5
              ? "Answer carefully... 😉"
              : "Okay, okay! You win! 👇",
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),

        const SizedBox(height: 40),

        // The "Yes" Button (Hidden initially)
        AnimatedOpacity(
          opacity: _showYesButton ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: IgnorePointer(
            ignoring: !_showYesButton, // Disable click when invisible
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isAccepted = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 10,
              ),
              child: const Text(
                "YES! 💖",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        // Spacer to push the "No" button area down visually
        const SizedBox(height: 100),
      ],
    );
  }

  // 2. The Success Message (Personalized)
  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.pink.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite, color: Colors.pink, size: 60),
          const SizedBox(height: 20),
          const Text(
            "Happy Valentine's Day! 🌹",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          const SizedBox(height: 20),
          const Text(
            "You are cuter than all the cats in the world! 🐱\n"
                "You bloom brighter than your favorite plants! 🌿\n"
                "And you're more essential to me than lip balm! 💄",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 30),
          const Text(
            "Love you, Alisha! ❤️",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
          ),
        ],
      ),
    );
  }

  // Logic to move the "No" button
  void _moveNoButton(Size size) {
    setState(() {
      _noAttempts++;

      // Unlock Yes button after 5 tries
      if (_noAttempts >= 5) {
        _showYesButton = true;
      }

      // Generate random position
      // We use 0.1 to 0.9 to keep it away from "Deep Corners"
      double minWidth = size.width * 0.1;
      double maxWidth = size.width * 0.8;
      double minHeight = size.height * 0.1;
      double maxHeight = size.height * 0.8;

      _noLeft = minWidth + _random.nextDouble() * (maxWidth - minWidth);
      _noTop = minHeight + _random.nextDouble() * (maxHeight - minHeight);
    });
  }
}