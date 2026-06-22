import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

/// Dummy Analytics Tracker - Replace print statements with FirebaseAnalytics
class AnalyticsTracker {
  static void logEvent(String name, [Map<String, dynamic>? parameters]) {
    debugPrint('Analytics Event: $name | Params: $parameters');
    // FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);
  }
}

class OnlyForHarshitaExperience extends StatefulWidget {
  const OnlyForHarshitaExperience({super.key});

  @override
  State<OnlyForHarshitaExperience> createState() =>
      _OnlyForHarshitaExperienceState();
}

class _OnlyForHarshitaExperienceState extends State<OnlyForHarshitaExperience>
    with TickerProviderStateMixin {

  // --- State Variables ---
  int _currentPage = 0;
  bool _isMusicPlaying = false;

  // Final Screen States
  int _noPressCount = 0;
  double _noOffsetX = 0;
  double _noOffsetY = 0;
  bool _isYesPressed = false;
  bool _isUnblockedPressed = false;
  final TextEditingController _msgController = TextEditingController(
    text: "Hey, I read your page.",
  );

  // Audio
  late AudioPlayer _bgmPlayer;
  late AudioPlayer _sfxPlayer;
  final String _targetPhoneNumber = "91XXXXXXXXXX"; // <-- Replace with your number

  // Timers/Tracking
  DateTime? _pageStartTime;

  @override
  void initState() {
    super.initState();
    _bgmPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();

    AnalyticsTracker.logEvent('page_opened');
    _pageStartTime = DateTime.now();
  }

  @override
  void dispose() {
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    _msgController.dispose();
    super.dispose();
  }

  // --- Actions ---

  void _playSound() async {
    // Replace with your actual asset path, e.g., 'sounds/page_turn.mp3'
    // await _sfxPlayer.play(AssetSource('sounds/soft_click.mp3'));
  }

  void _toggleMusic() async {
    setState(() => _isMusicPlaying = !_isMusicPlaying);
    if (_isMusicPlaying) {
      // await _bgmPlayer.play(AssetSource('sounds/soft_bgm.mp3'));
      // await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    } else {
      await _bgmPlayer.pause();
    }
    AnalyticsTracker.logEvent('music_toggled', {'playing': _isMusicPlaying});
  }

  void _nextPage() {
    if (_currentPage < 5) {
      _playSound();
      _trackReadingTime();
      setState(() => _currentPage++);
      AnalyticsTracker.logEvent('page_turned', {'page': _currentPage});
    }
  }

  void _trackReadingTime() {
    if (_pageStartTime != null) {
      final timeSpent = DateTime.now().difference(_pageStartTime!).inSeconds;
      AnalyticsTracker.logEvent('time_on_page', {
        'page': _currentPage,
        'seconds': timeSpent,
      });
      _pageStartTime = DateTime.now();
    }
  }

  void _moveNoButton() {
    if (_noPressCount >= 5) return;

    _playSound();
    setState(() {
      _noPressCount++;
      // Move within a 120px radius randomly
      _noOffsetX = (Random().nextDouble() * 240) - 120;
      _noOffsetY = (Random().nextDouble() * 160) - 80;
    });

    AnalyticsTracker.logEvent('no_button_interaction', {'count': _noPressCount});
  }

  void _launchWhatsApp(String message) async {
    final encodedMsg = Uri.encodeComponent(message);
    final url = Uri.parse('https://wa.me/$_targetPhoneNumber?text=$encodedMsg');

    AnalyticsTracker.logEvent('whatsapp_launched');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // --- UI Builders ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0ECE1), // Warm soft background
      body: MouseRegion(
        onHover: (event) {
          // Track occasional cursor movement (debouncing handled in real analytics)
          if (Random().nextInt(100) == 1) {
            AnalyticsTracker.logEvent('cursor_movement_active');
          }
        },
        child: Stack(
          children: [
            // 1. Animated Particles Background
            const Positioned.fill(child: ParticleBackground()),

            // 2. Audio Toggle
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(
                  _isMusicPlaying ? Icons.music_note : Icons.music_off,
                  color: Colors.brown.withOpacity(0.6),
                ),
                onPressed: _toggleMusic,
              ),
            ),

            // 3. Main Content
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _currentPage < 5
                    ? _buildNotebook()
                    : _buildFinalInteraction(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotebook() {
    return GestureDetector(
      key: const ValueKey('notebook'),
      onTap: _nextPage,
      child: Container(
        width: 600,
        height: 600,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFBF7), // Cream paper texture
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _buildPageContent(_currentPage),
              ),
            ),
            // Bottom Indicator
            Text(
              "${_currentPage + 1}/5",
              style: GoogleFonts.kalam(
                fontSize: 16,
                color: Colors.brown.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return _buildTextPage(
          "Hi Harshita",
          "This is the last message I will ever send you. You can close this page at any moment and I will completely respect your decision.",
          isTitle: true,
        );
      case 1:
        return _buildTextPage(
          "Explain:",
          "I asked your age.\nI thought 19 and 27 was too much.\nI blocked you because I felt it would be wrong to continue.\nThat decision was immature.",
        );
      case 2:
        return _buildTextPage(
          "Explain:",
          "Later I regretted disappearing.\nFinding your number was a mistake.\nI understand if that made you uncomfortable.\nMy intentions were always respectful.",
        );
      case 3:
        return Column(
          key: const ValueKey('page3'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Light humor:",
              style: GoogleFonts.kalam(fontSize: 22, color: Colors.brown.shade400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "I've learned two things:\n1. Brownie cups are your favorite.\n2. My communication skills were definitely not.",
              style: GoogleFonts.kalam(fontSize: 26, color: const Color(0xFF3E3A35)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Cute Brownie Illustration / Emoji
            const Text("🧁", style: TextStyle(fontSize: 60)),
          ],
        );
      case 4:
        return _buildTextPage(
          "",
          "If you still don't want to talk, I understand completely.\nBut if you'd be willing to have one conversation with me someday, I'd genuinely appreciate the chance.",
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextPage(String title, String body, {bool isTitle = false}) {
    return Column(
      key: ValueKey(title + body),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: GoogleFonts.kalam(
              fontSize: isTitle ? 42 : 22,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              color: isTitle ? const Color(0xFF3E3A35) : Colors.brown.shade400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
        Text(
          body,
          style: GoogleFonts.kalam(
            fontSize: 26,
            height: 1.4,
            color: const Color(0xFF3E3A35),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFinalInteraction() {
    return Container(
      key: const ValueKey('final_interaction'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Would you be open to talking sometime?",
            style: GoogleFonts.kalam(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3E3A35),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),

          if (!_isYesPressed && _noPressCount < 5)
            SizedBox(
              width: 350,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // YES Button
                  Positioned(
                    left: 40,
                    child: _buildButton("Yes, maybe.", () {
                      _playSound();
                      setState(() => _isYesPressed = true);
                      AnalyticsTracker.logEvent('pressed_yes');
                    }),
                  ),
                  // NO Button (Animated)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutBack,
                    left: 200 + _noOffsetX,
                    top: 75 + _noOffsetY,
                    child: MouseRegion(
                      onEnter: (_) => _moveNoButton(),
                      child: GestureDetector(
                        onTap: _moveNoButton,
                        child: _buildButton("I'd rather not.", () {}, isNo: true),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (_noPressCount >= 5) ...[
            Text(
              "Thank you for reading.\nI wish you happiness and great brownie cups forever.",
              style: GoogleFonts.kalam(fontSize: 28, color: const Color(0xFF3E3A35)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildButton("Okay Okay!", () {
              AnalyticsTracker.logEvent('pressed_okay_okay');
              // Optional: Redirect or close page
            }),
          ],

          if (_isYesPressed) ...[
            Text(
              "I knew you would say yes.",
              style: GoogleFonts.kalam(fontSize: 28, color: Colors.green.shade700),
            ),
            const SizedBox(height: 20),

            if (!_isUnblockedPressed) ...[
              Text(
                "Care to unblock me on whatsapp?\nI have made it easy for you.\nAfter unblocking, come back here and press unblocked.",
                style: GoogleFonts.kalam(fontSize: 22, color: const Color(0xFF3E3A35)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildButton("Unblocked", () {
                _playSound();
                setState(() => _isUnblockedPressed = true);
                AnalyticsTracker.logEvent('pressed_unblocked');
              }),
            ] else ...[
              Text(
                "Message me on WhatsApp?",
                style: GoogleFonts.kalam(fontSize: 26, color: const Color(0xFF3E3A35)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _msgController,
                  style: GoogleFonts.kalam(fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.brown.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.brown),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildButton("Send", () {
                _launchWhatsApp(_msgController.text);
              }),
            ]
          ]
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, {bool isNo = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isNo ? const Color(0xFFF4ECE6) : const Color(0xFF3E3A35),
        foregroundColor: isNo ? const Color(0xFF3E3A35) : const Color(0xFFFDFBF7),
        elevation: isNo ? 0 : 4,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isNo ? BorderSide(color: Colors.brown.shade200) : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.kalam(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// --- Particles Engine ---

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    for (int i = 0; i < 30; i++) {
      _particles.add(Particle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in _particles) {
          p.update();
        }
        return CustomPaint(
          painter: ParticlePainter(_particles),
        );
      },
    );
  }
}

class Particle {
  double x = Random().nextDouble() * 2000;
  double y = Random().nextDouble() * 1000;
  double speed = Random().nextDouble() * 0.5 + 0.1;
  double radius = Random().nextDouble() * 3 + 1;
  double alpha = Random().nextDouble() * 0.5 + 0.1;

  void update() {
    y -= speed;
    x += sin(y * 0.01) * 0.5; // Slight drifting
    if (y < 0) {
      y = 1000;
      x = Random().nextDouble() * 2000;
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(p.alpha)
        ..style = PaintingStyle.fill;
      // Wrap coordinates around screen dynamically
      double drawX = p.x % size.width;
      double drawY = p.y % size.height;
      canvas.drawCircle(Offset(drawX, drawY), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}