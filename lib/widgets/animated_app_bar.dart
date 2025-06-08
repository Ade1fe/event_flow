import 'package:flutter/material.dart';

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;

  const AnimatedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  _AnimatedAppBarState createState() => _AnimatedAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: AppBar(
              title: Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: widget.centerTitle,
              backgroundColor:
                  widget.backgroundColor ??
                  Theme.of(context).colorScheme.primary,
              elevation: widget.elevation,
              leading: widget.leading,
              actions: widget.actions,
            ),
          ),
        );
      },
    );
  }
}
