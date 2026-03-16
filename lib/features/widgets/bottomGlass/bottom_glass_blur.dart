import 'dart:ui';

import 'package:flutter/material.dart';

class BottomGlassBlur extends StatelessWidget {
  const BottomGlassBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            height: 60, // Adjust height to your preference
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.0), // Fades from transparent
                  Colors.white.withOpacity(0.4), // To a light frosted white
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: Colors.black.withOpacity(0.05), // Subtle line at the top
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}