import 'package:flutter/material.dart';
import 'package:event_flow/theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Flow'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome 👋', style: AppTextStyles.headline1),
            const SizedBox(height: 12),
            Text(
              'Plan, manage, and track your events seamlessly.',
              style: AppTextStyles.bodyText1,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create Event Clicked')),
                );
              },
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}
