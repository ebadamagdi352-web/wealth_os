import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_colors.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';
import 'package:wealth_os/src/features/assets/models/asset_summary.dart';
import 'package:wealth_os/src/features/assets/widgets/asset_distribution.dart';
import 'package:wealth_os/src/features/assets/widgets/assets_list.dart';
import 'package:wealth_os/src/features/assets/widgets/empty_assets.dart';
import 'package:wealth_os/src/localization/generated/app_localizations.dart';

/// Every string the assets screen renders.
///
/// Same confession as every feature before it: the ARB files hold four keys, none
/// of them these, and localization has been out of scope for nine consecutive
/// tasks. One class per feature keeps the eventual migration to one file and one
/// deletion.
///
/// * **This class is UI chrome.** It must become ARB keys.
/// * **Asset names are data.** "Gold", "Real Estate" — in a real app the user
///   names these, in their own language, and they must *never* be translated.
abstract final class AssetsCopy {
  static const String subtitle = 'What you own';
  static const String title = 'Assets';

  static const String totalLabel = 'Total assets';
  static const String distributionTitle = 'Distribution';

  static const String emptyTitle = 'No assets yet';
  static const String emptyDescription =
      'Add gold, stocks, property or anything else you own to track its value '
      'and see how your wealth is spread.';
  static const String emptyAction = 'Add asset';
}

/// The assets screen.
///
/// Presentation only. No repository, no provider, no persistence, no network, no
/// CRUD. The four assets below are constants in this file, passed down as
/// parameters — every widget beneath is a pure function of its arguments, which is
/// what will let them be reused unchanged when the data becomes real.
class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key});

  /// Matches the dashboard, accounts and transactions, so the screens do not
  /// disagree about how wide a page is.
  static const double _maxContentWidth = 720;

  // ---------------------------------------------------------------------
  // MOCK DATA
  //
  // `performance` is a **fraction**: 0.082 == +8.2%. All four are EGP, which is
  // the single fact that makes the total and the distribution honest — see the
  // note on `_TotalCard` and TASK_017_REPORT.md.
  //
  // Cash carries 0.0: it does not appreciate, so flat is correct, and it is the
  // one asset that exercises the neutral/grey path.
  // ---------------------------------------------------------------------
  static const List<AssetSummary> _mockAssets = <AssetSummary>[
    AssetSummary(
      id: 'ast_gold',
      name: 'Gold',
      value: 520000,
      performance: 0.082, // +8.2%
      currencyCode: 'EGP',
      iconKey: 'gold',
    ),
    AssetSummary(
      id: 'ast_stocks',
      name: 'Stocks',
      value: 340000,
      performance: 0.125, // +12.5%
      currencyCode: 'EGP',
      iconKey: 'stocks',
    ),
    AssetSummary(
      id: 'ast_cash',
      name: 'Cash',
      value: 120000,
      performance: 0, // 0%
      currencyCode: 'EGP',
      iconKey: 'cash',
    ),
    AssetSummary(
      id: 'ast_real_estate',
      name: 'Real Estate',
      value: 265300,
      performance: 0.048, // +4.8%
      currencyCode: 'EGP',
      iconKey: 'real_estate',
    ),
  ];

  /// What the empty state's button does.
  ///
  /// There is no add-asset screen — CRUD is forbidden — so it acknowledges the tap
  /// with the `comingSoon` key that already exists in both ARB files rather than
  /// swallowing it. That snackbar is the only correctly localized string here.
  void _onAddAsset(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.comingSoon),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    const List<AssetSummary> assets = _mockAssets;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double gutter = AppSpacing.screenGutter(constraints.maxWidth);

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    gutter,
                    AppSpacing.md,
                    gutter,
                    AppSpacing.x2l,
                  ),
                  children: <Widget>[
                    const _AssetsHeader(
                      title: AssetsCopy.title,
                      subtitle: AssetsCopy.subtitle,
                    ),
                    AppSpacing.gapV20,

                    if (assets.isEmpty)
                      EmptyAssets(
                        title: AssetsCopy.emptyTitle,
                        description: AssetsCopy.emptyDescription,
                        actionLabel: AssetsCopy.emptyAction,
                        onAddAsset: () => _onAddAsset(context),
                      )
                    else ...<Widget>[
                      const _TotalCard(assets: assets),
                      AppSpacing.gapV24,
                      const AssetDistribution(
                        title: AssetsCopy.distributionTitle,
                        assets: assets,
                      ),
                      AppSpacing.gapV24,
                      const AssetsList(assets: assets),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The total value of everything owned.
///
/// ## Why this screen shows a total when the accounts screen refused one
///
/// The accounts screen deliberately showed **no** grand total, because its
/// accounts were in EGP *and* USD, and adding those without an exchange rate would
/// have been a confident lie about someone's money (TASK_014 §4).
///
/// These four assets are **all EGP**. Summing them is arithmetic, not a currency
/// error, so the total is honest here — and a portfolio screen with no headline
/// figure feels broken. The principle did not change between the two screens; the
/// data did. That is exactly why the rule is "don't sum across currencies" and not
/// "never sum".
///
/// The total is **computed**, never stored beside the assets — the same figure
/// stored twice is the figure that eventually disagrees with itself.
class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.assets});

  final List<AssetSummary> assets;

  static final NumberFormat _format = NumberFormat.decimalPattern('en');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Brightness brightness = theme.brightness;

    final double total = assets.fold<double>(
      0,
      (double sum, AssetSummary asset) => sum + asset.value,
    );

    // Every asset is EGP in the mock; the fold above is only meaningful because of
    // that. `currencyCode` reads from the first holding rather than a hardcoded
    // 'EGP', so the day the data carries a real currency this label follows it
    // instead of lying.
    final String currency =
        assets.isEmpty ? '' : assets.first.currencyCode;

    return Container(
      width: double.infinity,
      padding: AppSpacing.heroAll,
      decoration: BoxDecoration(
        color: AppColors.heroSurface(brightness),
        borderRadius: AppRadius.borderHero,
        boxShadow: AppShadows.hero(brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            AssetsCopy.totalLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.onHeroSurfaceMuted(brightness),
            ),
          ),
          AppSpacing.gapV12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                currency,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.onHeroSurfaceMuted(brightness),
                ),
              ),
              AppSpacing.gapH8,
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    _format.format(total),
                    maxLines: 1,
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: AppColors.onHeroSurface(brightness),
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

/// A quiet subtitle above a title.
///
/// ⚠️ **Fourth copy.** `DashboardHeader`, `_AccountsHeader`, `_TransactionsHeader`,
/// and now this. It belongs in `lib\src\shared\widgets\page_header.dart`; that
/// folder is still unauthorised, and the three existing copies live in features
/// this task may not modify. Flagged, not fixed — TASK_017_REPORT.md.
class _AssetsHeader extends StatelessWidget {
  const _AssetsHeader({required this.title, required this.subtitle});

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
        Text(title, style: theme.textTheme.headlineSmall),
      ],
    );
  }
}
