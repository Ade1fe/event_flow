import 'package:event_flow/screens/event/event_management_screen.dart';
import 'package:event_flow/screens/event/event_detail_page.dart';
import 'package:event_flow/screens/main_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder:
          (BuildContext context, GoRouterState state) => const MainContainer(),
    ),
    // Event management route with parameters
    GoRoute(
      path: '/event/:eventId',
      name: 'event_management',
      builder: (BuildContext context, GoRouterState state) {
        // Extract parameters from the state
        final eventId = state.pathParameters['eventId'] ?? '';
        final eventName = state.uri.queryParameters['eventName'] ?? 'Event';

        return EventManagementScreen(eventId: eventId, eventName: eventName);
      },
    ),
    GoRoute(
      path: '/event/:eventId',
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']!;
        return EventDetailPage(eventId: eventId);
      },
    ),
    // GoRoute(
    //   path: '/event-management/:eventId/:eventName',
    //   name: 'eventManagement',
    //   builder: (context, state) {
    //     final eventId = state.pathParameters['eventId']!;
    //     final eventName = state.pathParameters['eventName']!;
    //     return EventManagementScreen(eventId: eventId, eventName: eventName);
    //   },
    // ),
  ],
);
