import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:momentum/services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_clean/services/theme_service.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';

class ProfessionalAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showProfile;
  final bool showNotifications;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;
  final bool isTransparent;
  final Widget? flexibleSpace;
  final double height;
  final bool showSubtitle;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool showBackButton;
  final bool showShadow;
  final BorderRadius? borderRadius;

  // Increased default height to prevent overflow (from kToolbarHeight + 30 to kToolbarHeight + 50)
  const ProfessionalAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showProfile = true,
    this.showNotifications = true,
    this.onProfileTap,
    this.onNotificationTap,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 2,
    this.isTransparent = false,
    this.flexibleSpace,
    this.height = kToolbarHeight + 70,
    this.showSubtitle = true,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.showBackButton = true,
    this.showShadow = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final hasLeading =
        leading != null || (Navigator.of(context).canPop() && showBackButton);

    final shouldCenterTitle = hasLeading ? centerTitle : false;

    SystemChrome.setSystemUIOverlayStyle(
      isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isTransparent
            ? Colors.transparent
            : backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius,
        boxShadow: showShadow && elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .05),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Stack(
            children: [
              if (flexibleSpace != null) Positioned.fill(child: flexibleSpace!),
              Row(
                children: [
                  if (leading != null)
                    leading!
                  else if (Navigator.of(context).canPop() && showBackButton)
                    _buildBackButton(context),
                  if (hasLeading) const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: shouldCenterTitle
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style:
                              titleStyle ??
                              TextStyle(
                                color: isTransparent
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.15,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (showSubtitle &&
                            (subtitle != null ||
                                title == 'Home' ||
                                title == 'My Tasks'))
                          subtitle != null
                              ? Text(
                                  subtitle!,
                                  style:
                                      subtitleStyle ??
                                      TextStyle(
                                        color: isTransparent
                                            ? Colors.white.withValues(alpha: .8)
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: .6),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                )
                              : Consumer<TaskProvider>(
                                  builder: (context, taskProvider, child) {
                                    final pendingCount =
                                        taskProvider.pendingTasks;
                                    final overdueCount =
                                        taskProvider.overdueTasks.length;

                                    if (pendingCount == 0 &&
                                        overdueCount == 0) {
                                      return Text(
                                        'All caught up! 🎉',
                                        style:
                                            subtitleStyle ??
                                            TextStyle(
                                              color: isTransparent
                                                  ? Colors.white.withOpacity(
                                                      0.8,
                                                    )
                                                  : Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      );
                                    }
                                    return Text(
                                      overdueCount > 0
                                          ? '$overdueCount overdue, $pendingCount pending'
                                          : '$pendingCount tasks pending',
                                      style:
                                          subtitleStyle ??
                                          TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: overdueCount > 0
                                                ? Colors.red
                                                : (isDark
                                                      ? Colors.white
                                                      : Colors.black),
                                          ),
                                    );
                                  },
                                ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            themeProvider.toggleTheme();
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              isDark
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                              color: isTransparent
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.onSurface,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (showNotifications)
                        Consumer<TaskProvider>(
                          builder: (context, taskProvider, child) {
                            final overdueCount =
                                taskProvider.overdueTasks.length;

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap:
                                    onNotificationTap ??
                                    () {
                                      HapticFeedback.lightImpact();
                                      _showNotificationsBottomSheet(
                                        context,
                                        taskProvider,
                                      );
                                    },
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Icon(
                                            Icons.notifications_outlined,
                                            color: isTransparent
                                                ? Colors.white
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                            size: 20,
                                          ),
                                        ),
                                        if (overdueCount > 0)
                                          Positioned(
                                            right: -1,
                                            top: -1,
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: isTransparent
                                                      ? Colors.white
                                                      : Theme.of(
                                                          context,
                                                        ).colorScheme.surface,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  overdueCount > 99
                                                      ? '99+'
                                                      : overdueCount.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(width: 4),
                      if (actions != null) ...actions!,
                      if (showProfile)
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  if (onProfileTap != null) {
                                    onProfileTap!();
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 4),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isTransparent
                                          ? ThemeService.primaryVariantColor
                                          : ThemeService.primaryVariantColor,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: .05,
                                        ),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: isDark
                                        ? ThemeService.primaryVariantColor
                                        : ThemeService.primaryVariantColor,
                                    child:
                                        authProvider.userProfile?.photoUrl !=
                                            null
                                        ? ClipOval(
                                            child: Image.network(
                                              authProvider
                                                  .userProfile!
                                                  .photoUrl!,
                                              width: 32,
                                              height: 32,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Text(
                                                      authProvider
                                                              .userProfile
                                                              ?.initials ??
                                                          'U',
                                                      style: TextStyle(
                                                        color: isDark
                                                            ? Colors.white
                                                            : Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          )
                                        : Text(
                                            authProvider
                                                    .userProfile
                                                    ?.initials ??
                                                'U',
                                            style: TextStyle(
                                              color: isTransparent
                                                  ? Colors.white
                                                  : Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationsBottomSheet(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: .6)
                  : Colors.black.withValues(alpha: .15),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 16),
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: .2),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          taskProvider.overdueTasks.isEmpty
                              ? 'All up to date'
                              : '${taskProvider.overdueTasks.length} overdue tasks',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: .6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface.withValues(alpha: .05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: colorScheme.onSurface.withValues(alpha: .7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.onSurface.withValues(alpha: .05),
                    colorScheme.onSurface.withValues(alpha: .1),
                    colorScheme.onSurface.withValues(alpha: .05),
                  ],
                ),
              ),
            ),

            // Notifications list
            Expanded(
              child: taskProvider.overdueTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary.withValues(alpha: .1),
                                  colorScheme.primary.withValues(alpha: .05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.primary.withValues(
                                  alpha: .2,
                                ),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 56,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'All caught up! 🎉',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'You have no pending notifications.\nGreat job staying on top of things!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: .6,
                              ),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                      itemCount: taskProvider.overdueTasks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = taskProvider.overdueTasks[index];
                        return _buildSwipeableTaskCard(
                          context,
                          task,
                          taskProvider,
                          theme,
                          colorScheme,
                          isDark,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeableTaskCard(
    BuildContext context,
    dynamic task,
    TaskProvider taskProvider,
    ThemeData theme,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Dismissible(
      key: Key(task.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.withValues(alpha: .8), Colors.green],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt_rounded, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              'Complete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();

        // Show a quick confirmation with animation
        final result = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: .1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.task_alt_rounded,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mark as Complete?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"${task.title}"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: .7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: .6,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Complete',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );

        return result ?? false;
      },
      onDismissed: (direction) {
        HapticFeedback.lightImpact();
        taskProvider.toggleTaskCompletion(task);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.task_alt_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Task completed! 🎉',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          ),
        );

        // Close notification sheet if no more overdue tasks
        if (taskProvider.overdueTasks.isEmpty) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.error.withValues(alpha: .2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: .2)
                  : colorScheme.shadow.withValues(alpha: .08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Show task details or navigate to task
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.error.withValues(alpha: .15),
                          colorScheme.error.withValues(alpha: .1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.error.withValues(alpha: .3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.error.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Overdue: ${task.dueDateFormatted}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Swipe hint
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.swipe_left_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Swipe',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isTransparent
                ? Colors.white.withValues(alpha: .2)
                : Theme.of(context).colorScheme.surface,
            border: Border.all(
              color: isTransparent
                  ? Colors.white.withValues(alpha: .1)
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: .1),
              width: 1,
            ),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          width: 36,
          height: 36,
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 18,
              color: isTransparent
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
