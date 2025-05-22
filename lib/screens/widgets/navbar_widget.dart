import 'package:flutter/material.dart';
import 'package:event_flow/theme/theme.dart'; // Import your theme file

class NavbarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const NavbarWidget({
    super.key,
    this.selectedIndex = 0,
    required this.onItemSelected,
  });

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.onBackground.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.receipt_outlined, 'Home'),
          _buildNavItem(1, Icons.grid_view_outlined, 'Attendees'),
          _buildNavItem(2, Icons.help_outline, 'QR'),
          _buildNavItem(3, Icons.favorite_border, 'Events'),
          _buildNavItem(4, Icons.person_outline, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = widget.selectedIndex == index;
    return InkWell(
      onTap: () => widget.onItemSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:
                isSelected
                    ? AppColors.primary
                    : AppColors.onBackground.withValues(alpha: .5),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.getStyle(
              fontSize: 12,
              color:
                  isSelected
                      ? AppColors.primary
                      : AppColors.onBackground.withValues(alpha: .5),
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
