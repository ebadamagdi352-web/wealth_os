import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';

/// The top of the dashboard: a quiet subtitle above a title.
///
/// The title dropped from `headlineMedium` to `headlineSmall` in Task 013 — 28pt
/// to 21pt. At 28 it was competing with the net-worth figure for attention, and
/// only one thing on a screen may be the loudest. The hero number wins that
/// contest by design; the page title is a caption to it.
///
/// No avatar, no notification bell, no settings cog. Each would be a control that
/// does nothing — and a dead affordance is worse than an absent one. A user who
/// taps a bell and gets silence learns the app is broken; a user who never sees a
/// bell learns nothing at all.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.gapV4,
        // Weight comes from the type scale now — `headlineSmall` carries w600 —
        // rather than from a `copyWith` repeated in six widget files.
        Text(
          title,
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
