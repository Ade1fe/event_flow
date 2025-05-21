import 'package:event_flow/screens/homepage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    ),
    // Add more routes here as needed
    // Example:
    // GoRoute(
    //   path: '/create',
    //   name: 'create_event',
    //   builder: (BuildContext context, GoRouterState state) => const CreateEventPage(),
    // ),
  ],
);

// to call it in your widget
// context.go('/'); // for home
// context.go('/create'); // for a create event page
