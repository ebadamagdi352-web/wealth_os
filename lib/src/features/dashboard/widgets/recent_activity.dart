import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_colors.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';

/// One entry in the [RecentActivity] list.
class ActivityEntry extends Equatable {
  const ActivityEntry({
    required this.title,
    required this.amount,
    required this.timeLabel,
    required this.icon,
  });

  final String title;

  /// Signed. Positive is money in, negative is money out.
  ///
  /// A signed number rather than an amount plus an `isIncome` flag. Two fields can
  /// contradict each other — `amount: -50, isIncome: true` is representable — and
  /// one cannot.
  final double amount;

  /// e.g. "Today", "Yesterday".
  final String timeLabel;

  final IconData icon;

  bool get isCredit => amount >= 0;

  @override
  List<Object?> get props => <Object?>[title, amount, timeLabel, icon];
}

/// The most recent movements on the account.
///
/// ## Sign, not just colour
///
/// Every amount carries an explicit `+` or `−`. The colour is a second, redundant
/// signal — never the only one.
///
/// Roughly one man in twelve has red-green colour deficiency. A ledger that
/// distinguishes income from expense *solely* by green and red is unreadable to
/// them, and they will not report it as a bug; they will simply misread their own
/// money. The sign is what makes the row correct. The colour just makes it fast.
class RecentActivity extends StatelessWidget {
  const RecentActivity({
    required this.title,
    required this.entries,
    required this.currencyCode,
    super.key,
  });

  final String title;
  final List<ActivityEntry> entries;
  final String currencyCode;

  static final NumberFormat _format = NumberFormat.decimalPattern('en');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Brightness brightness = theme.brightness;
    final bool isDark = brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.cardAll,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderCard,
        boxShadow: AppShadows.card(brightness),
        border: isDark ? Border.all(color: colors.outlineVariant) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: theme.textTheme.titleMedium),
          AppSpacing.gapV4,
          for (int i = 0; i < entries.length; i++) ...<Widget>[
            if (i > 0)
              Divider(color: colors.outlineVariant, height: 1, thickness: 1),
            _ActivityRow(
              entry: entries[i],
              currencyCode: currencyCode,
              format: _format,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.entry,
    required this.currencyCode,
    required this.format,
  });

  final ActivityEntry entry;
  final String currencyCode;
  final NumberFormat format;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    final Color amountColor = _semanticColor(
      theme.brightness,
      isCredit: entry.isCredit,
    );

    // U+2212 MINUS SIGN, not the hyphen on the keyboard. A hyphen is narrower
    // than a plus sign, so a column of amounts written with one fails to align —
    // and misaligned money is the fastest way to look untrustworthy.
    final String sign = entry.isCredit ? '+' : '\u2212';
    final String formatted = format.format(entry.amount.abs());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: AppRadius.borderSm,
            ),
            child: Icon(
              entry.icon,
              size: 18,
              color: colors.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.title,
                  style: theme.textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  entry.timeLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapH8,
          Text(
            '$sign $currencyCode $formatted',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: amountColor,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }

  /// Resolves the gain/loss colour for the active brightness.
  ///
  /// These live in [AppColors] as plain constants rather than in the
  /// `ColorScheme`, because Material has no role meaning "this number went up".
  /// The correct long-term home is a `ThemeExtension`, which would let a widget
  /// read `Theme.of(context).extension<AppSemanticColors>()!.gain` with no
  /// branching. Until that exists, the branch lives here, in one place, rather
  /// than at every call site.
  static Color _semanticColor(Brightness brightness, {required bool isCredit}) {
    final bool isDark = brightness == Brightness.dark;
    if (isCredit) {
      return isDark ? AppColors.darkGain : AppColors.lightGain;
    }
    return isDark ? AppColors.darkLoss : AppColors.lightLoss;
  }
}
