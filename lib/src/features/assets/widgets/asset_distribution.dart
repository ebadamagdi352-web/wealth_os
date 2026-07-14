import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';
import 'package:wealth_os/src/features/assets/models/asset_summary.dart';

/// How the portfolio divides, as a plain percentage list.
///
/// ## No chart, on purpose — and no bar either
///
/// The brief says *simple percentage list only, no charts*. I have read that
/// strictly: there is not even a `LinearProgressIndicator` bar in here, though the
/// dashboard's asset summary uses them. A bar encodes a value in a length — it is
/// the smallest possible chart — and "no charts yet" reads to me as "the number,
/// in text, and nothing that plots it". When the charts task comes, this is where
/// a donut or a treemap lands.
///
/// ## Every share is computed from the values
///
/// Not one percentage is passed in. A percentage supplied alongside an amount is a
/// second source of truth for one fact, and the day someone edits a value and
/// forgets the percentage, the list quietly stops adding up. Computed, it cannot.
///
/// ## ⚠️ The shares assume one currency
///
/// A share is `value / total`, and `total` is the plain sum of every value. That
/// is only meaningful if the values are in the **same currency** — which, for this
/// mock, they are (all EGP). The moment an asset is denominated in USD, this sum
/// adds EGP to USD and every percentage becomes fiction, exactly as the accounts
/// grand-total would have (TASK_014 §4). When assets go multi-currency this needs
/// an FX conversion and a reference currency, not a bare `fold`.
class AssetDistribution extends StatelessWidget {
  const AssetDistribution({
    required this.title,
    required this.assets,
    super.key,
  });

  final String title;
  final List<AssetSummary> assets;

  static final NumberFormat _percent = NumberFormat.decimalPercentPattern(
    locale: 'en',
    decimalDigits: 1,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Brightness brightness = theme.brightness;
    final bool isDark = brightness == Brightness.dark;

    final double total = assets.fold<double>(
      0,
      (double sum, AssetSummary asset) => sum + asset.value,
    );

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
          AppSpacing.gapV16,
          for (int i = 0; i < assets.length; i++) ...<Widget>[
            if (i > 0) AppSpacing.gapV12,
            _DistributionRow(
              name: assets[i].name,
              // Computed once, here. Guarded: a zero total is a real state — a
              // user with no assets — and dividing by it yields NaN, which renders
              // as a blank row.
              percentText: _percent.format(
                total > 0 ? assets[i].value / total : 0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DistributionRow extends StatelessWidget {
  const _DistributionRow({
    required this.name,
    required this.percentText,
  });

  final String name;
  final String percentText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Row(
      children: <Widget>[
        Text(name, style: theme.textTheme.bodyLarge),
        // The dotted leader — "Gold ...... 42%" — is typography, not a plot. It
        // ties a name to its number across a gap without encoding the value in a
        // length the way a bar would.
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: CustomPaint(
              painter: _DottedLeaderPainter(color: colors.outlineVariant),
              child: const SizedBox(height: 1),
            ),
          ),
        ),
        Text(
          percentText,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
      ],
    );
  }
}

/// Paints a single row of evenly spaced dots along its width.
///
/// A leader line, the kind that runs between an entry and its page number in a
/// printed table of contents. Deliberately the humblest thing that fills the gap:
/// no value is encoded in it, so it is not a chart by any reading of the rule.
class _DottedLeaderPainter extends CustomPainter {
  const _DottedLeaderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const double dotRadius = 1;
    const double gap = 5;
    final Paint paint = Paint()..color = color;

    double x = 0;
    final double y = size.height / 2;
    while (x <= size.width) {
      canvas.drawCircle(Offset(x, y), dotRadius, paint);
      x += gap;
    }
  }

  @override
  bool shouldRepaint(_DottedLeaderPainter oldDelegate) =>
      oldDelegate.color != color;
}
