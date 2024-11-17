import 'package:flutter/material.dart';

class BlinkingLogoPage extends StatefulWidget {
  const BlinkingLogoPage({super.key});

  @override
  _BlinkingLogoPageState createState() => _BlinkingLogoPageState();
}

class _BlinkingLogoPageState extends State<BlinkingLogoPage> {
  // A variable to control the opacity
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  // This method will control the blinking by changing opacity
  void _startBlinking() {
    // Create a loop that changes the opacity every second
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacity = _opacity == 1.0 ? 0.0 : 1.0; // Toggle opacity
      });
      _startBlinking(); // Keep blinking
    });
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
