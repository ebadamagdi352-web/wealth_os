import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/features/transactions/models/transaction_summary.dart';
import 'package:wealth_os/src/features/transactions/widgets/transaction_amount.dart';

/// One transaction.
///
/// Icon, title, category, date, amount, currency — in that reading order, because
/// that is the order the questions arrive in: *what was it, what kind, when, how
/// much.*
class TransactionCard extends StatelessWidget {
  const TransactionCard({required this.transaction, super.key});

  final TransactionSummary transaction;

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
        // Shadow in light, border in dark — never both. A black shadow on a
        // near-black surface is invisible, so dark mode separates by edge.
        boxShadow: AppShadows.card(brightness),
        border: isDark ? Border.all(color: colors.outlineVariant) : null,
      ),
      child: Row(
        children: <Widget>[
          _CategoryIcon(category: transaction.category),
          AppSpacing.gapH12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                AppSpacing.gapV4,
                // Category and date share a line, separated by a middle dot. Two
                // stacked lines of grey caption under every title would make the
                // card twice as tall to say half as much.
                Text(
                  '${transaction.category.displayLabel} '
                  '${TransactionCardCopy.separator} '
                  '${TransactionDateLabel.of(transaction.occurredAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapH8,
          Flexible(
            child: TransactionAmount(
              amount: transaction.amount,
              currencyCode: transaction.currencyCode,
              kind: transaction.kind,
            ),
          ),
        ],
      ),
    );
  }
}

/// Turns a timestamp into the label a human wants.
///
/// ## Why the model stores a `DateTime` and not the word "Yesterday"
///
/// A stored label is frozen the moment it is written. Tomorrow it still says
/// "Yesterday", and it is wrong — and it is wrong *silently*, because nothing
/// throws and no test notices that a string is stale.
///
/// The date is data. The label is a rendering of it against the current clock, and
/// it is recomputed on every build.
abstract final class TransactionDateLabel {
  /// Below this many days old, a weekday name is friendlier than a date.
  static const int _weekdayWindow = 7;

  static final DateFormat _weekday = DateFormat.EEEE('en');
  static final DateFormat _fullDate = DateFormat.yMMMd('en');

  /// The label for [occurredAt], relative to now.
  static String of(DateTime occurredAt, {DateTime? now}) {
    final DateTime reference = now ?? DateTime.now();

    // Compared at day granularity, not by elapsed hours. "23 hours ago" can be
    // yesterday or today depending on the time of day, and a user thinks in
    // calendar days, not in durations.
    final DateTime today =
        DateTime(reference.year, reference.month, reference.day);
    final DateTime day =
        DateTime(occurredAt.year, occurredAt.month, occurredAt.day);

    final int daysAgo = today.difference(day).inDays;

    if (daysAgo == 0) {
      return TransactionCardCopy.today;
    }
    if (daysAgo == 1) {
      return TransactionCardCopy.yesterday;
    }
    if (daysAgo > 1 && daysAgo < _weekdayWindow) {
      return _weekday.format(occurredAt);
    }
    return _fullDate.format(occurredAt);
  }
}

/// Resolves a [TransactionCategory.iconKey] to a Material icon.
///
/// The indirection is what keeps `transaction_summary.dart` free of Flutter. A
/// model carrying an `IconData` cannot be unit-tested without a widget binding, and
/// cannot be serialised without a custom converter.
abstract final class TransactionIcons {
  static const Map<String, IconData> _icons = <String, IconData>{
    'income': Icons.payments_outlined,
    'investment': Icons.diamond_outlined,
    'utilities': Icons.bolt_outlined,
    'groceries': Icons.shopping_cart_outlined,
    'transfer': Icons.swap_horiz,
  };

  /// Fallback for a key with no mapping.
  ///
  /// A missing icon must not crash the screen. The fallback is visually obvious, so
  /// an unmapped key gets noticed rather than silently tolerated.
  static const IconData fallback = Icons.receipt_long_outlined;

  static IconData forKey(String iconKey) => _icons[iconKey] ?? fallback;
}

/// The tinted icon chip.
class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category});

  final TransactionCategory category;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: AppRadius.borderMd,
      ),
      child: Icon(
        TransactionIcons.forKey(category.iconKey),
        size: 20,
        color: colors.onSurfaceVariant,
      ),
    );
  }
}

/// Copy owned by the transaction card.
///
/// Not localized — see `TransactionsCopy` in `transactions_page.dart` for the full
/// note. It lives here rather than in the page because the card is the only thing
/// that renders it, and threading four strings down through two widgets to reach
/// one `Text` is worse than the rule it would be honouring.
abstract final class TransactionCardCopy {
  static const String today = 'Today';
  static const String yesterday = 'Yesterday';

  /// U+00B7 MIDDLE DOT. Not a hyphen, not a bullet, not a slash — it is the
  /// typographic separator for exactly this job, and it does not read as a minus
  /// sign sitting next to an amount.
  static const String separator = '\u00B7';
}
