import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final List<Color>? gradientColors;
  final bool centerTitle;
  final double elevation;
  final Widget? flexibleSpace;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.gradientColors,
    this.centerTitle = true,
    this.elevation = 0,
    this.flexibleSpace,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ??
        [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
        ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: elevation,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: leading,
        actions: actions,
        flexibleSpace: flexibleSpace,
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
