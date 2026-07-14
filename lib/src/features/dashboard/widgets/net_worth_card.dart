import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_colors.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';

/// The hero figure: total net worth.
///
/// ## Task 013 — from mint to ink
///
/// This card previously sat on `primaryContainer`, which was a bright mint. Mint
/// is a *fresh* colour: it belongs on a fitness tracker or a savings challenge.
/// Under someone's net worth the emotional register is simply wrong.
///
/// It is now deep ink with light type — the visual language of a metal card. The
/// contrast against a near-white page is what makes one number feel like *the*
/// number, and it does that without needing to be any larger.
///
/// One number, given room to breathe. This is the only thing a user opens the app
/// to see, and a card that competes with it — a sparkline, a percentage badge, a
/// "vs last month" chip — makes it harder to read, not richer.
///
/// It shows no change indicator, deliberately. The mock data contains no
/// historical figure, so any percentage here would be invented — and an invented
/// number in a finance product is not a placeholder, it is a lie with a decimal
/// point.
class NetWorthCard extends StatelessWidget {
  const NetWorthCard({
    required this.label,
    required this.amount,
    required this.currencyCode,
    super.key,
  });

  /// e.g. "Total Net Worth".
  final String label;

  /// The figure, in [currencyCode].
  final double amount;

  /// ISO 4217 code, e.g. `EGP`.
  final String currencyCode;

  /// Grouping separators, no decimals.
  ///
  /// Money is never formatted by string interpolation. `'$amount'` would render
  /// `1245300.0` — which is both wrong and, in a wealth product, alarming.
  static final NumberFormat _format = NumberFormat.decimalPattern('en');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Brightness brightness = theme.brightness;

    final Color surface = AppColors.heroSurface(brightness);
    final Color onSurface = AppColors.onHeroSurface(brightness);
    final Color onSurfaceMuted = AppColors.onHeroSurfaceMuted(brightness);

    return Container(
      width: double.infinity,
      padding: AppSpacing.heroAll,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: AppRadius.borderHero,
        boxShadow: AppShadows.hero(brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: onSurfaceMuted,
            ),
          ),
          AppSpacing.gapV12,
          // The currency code sits on its own baseline, smaller than the figure.
          // Rendering "EGP 1,245,300" as one uniform string makes the eye read
          // the code first; separating them lets the number lead.
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                currencyCode,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: onSurfaceMuted,
                ),
              ),
              AppSpacing.gapH8,
              // FittedBox, not a smaller font: a large balance on a small phone
              // scales down to fit rather than wrapping onto a second line or
              // overflowing. A net-worth figure that has been cut in half by a
              // line break is not a cosmetic problem.
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    _format.format(amount),
                    maxLines: 1,
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: onSurface,
                      fontFeatures: AppTypography.tabularFigures,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
