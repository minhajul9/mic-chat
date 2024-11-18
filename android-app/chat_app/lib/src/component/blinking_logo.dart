import 'package:flutter/material.dart';

class BlinkingLogoPage extends StatefulWidget {
  const BlinkingLogoPage({super.key});

  @override
  _BlinkingLogoPageState createState() => _BlinkingLogoPageState();
}

class _BlinkingLogoPageState extends State<BlinkingLogoPage> {
  // A variable to control the opacity
  double _opacity = 1.0;
  bool _isBlinking = true;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  // This method will control the blinking by changing opacity
  void _startBlinking() async {
    while (_isBlinking) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        _opacity = _opacity == 1.0 ? 0.0 : 1.0; // Toggle opacity
      });
    }
  }

  @override
  void dispose() {
    _isBlinking = false; // Stop blinking when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 250,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 1000), // Adjust duration for speed
            child: Image.asset('assets/images/logo.png'), // Your logo image
          ),
        ),
      ),
    );
  }
}
