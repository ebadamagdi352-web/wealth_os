import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';

/// The top of the dashboard: a quiet subtitle above a large title.
///
/// No avatar, no notification bell, no settings cog. Every one of those would be
/// a control that does nothing — and a dead affordance is worse than an absent
/// one. A user who taps a bell and gets silence learns the app is broken; a user
/// who never sees a bell learns nothing at all.
///
/// The strings arrive as parameters rather than being written here. See the note
/// on `DashboardCopy` in `dashboard_page.dart`.
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
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
