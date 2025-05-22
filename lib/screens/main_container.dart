import 'package:event_flow/screens/homepage/home_page.dart';
import 'package:event_flow/screens/event/event_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:event_flow/screens/widgets/navbar_widget.dart';
import 'package:event_flow/theme/theme.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  // Content for each tab with themed styling
  List<Widget> get _screenContents => [
    HomePage(),
    EventDetailPage(eventId: '12345'),
    Center(child: Text('Commision Screen', style: AppTextStyles.headline1)),
    Center(child: Text('Ris Screen', style: AppTextStyles.headline1)),
    Center(child: Text('Nostiudes Screen', style: AppTextStyles.headline1)),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Main Content Area
            Expanded(child: _screenContents[_selectedIndex]),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: NavbarWidget(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
