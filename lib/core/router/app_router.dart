// lib/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/pages/home_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/projects',
        name: 'projects',
        builder: (context, state) => const HomeScreen(initialSection: 'projects'),
      ),
      GoRoute(
        path: '/about',
        name: 'about',
        builder: (context, state) => const HomeScreen(initialSection: 'about'),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const HomeScreen(initialSection: 'contact'),
      ),
    ],
  );
}