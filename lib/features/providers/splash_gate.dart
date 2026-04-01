// import 'package:flutter/material.dart';
// import '../pages/splash_screen.dart';
//
// class SplashGate extends StatefulWidget {
//   final Widget child;
//
//   const SplashGate({super.key, required this.child});
//
//   @override
//   State<SplashGate> createState() => _SplashGateState();
// }
//
// class _SplashGateState extends State<SplashGate> {
//   bool showSplash = true;
//
//   @override
//   Widget build(BuildContext context) {
//     if (showSplash) {
//       return SplashScreen(
//         nextPage: widget.child, // 👈 PASS HOME HERE
//         onFinished: () {
//           setState(() => showSplash = false);
//         },
//       );
//     }
//
//     return widget.child;
//   }
// }
