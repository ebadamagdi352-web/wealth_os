import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/assets/models/asset_summary.dart';
import 'package:wealth_os/src/features/assets/widgets/asset_card.dart';

/// The assets, laid out.
///
/// One column on a phone; two on a tablet, where a single column of full-width
/// cards would strand the eye in a wide empty margin.
///
/// The cards arrive **already ordered**. This widget does not sort or rank —
/// ordering is a decision about *what the data is* and belongs with whatever
/// produces it, not with whatever draws it.
///
/// Deliberately **not** a `ListView`: it sits inside the page's scroll view, and
/// nesting scrollables means pinning the inner one to a fixed height. That is
/// right at four assets and wrong at four hundred — see TASK_017_REPORT.md.
class AssetsList extends StatelessWidget {
  const AssetsList({required this.assets, super.key});

  final List<AssetSummary> assets;

  /// Above this width, the cards go two-across.
  static const double _twoColumnBreakpoint = 640;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isWide = constraints.maxWidth >= _twoColumnBreakpoint;
        return isWide ? _TwoColumn(assets: assets) : _OneColumn(assets: assets);
      },
    );
  }
}

class _OneColumn extends StatelessWidget {
  const _OneColumn({required this.assets});

  final List<AssetSummary> assets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < assets.length; i++) ...<Widget>[
          if (i > 0) AppSpacing.gapV12,
          AssetCard(asset: assets[i]),
        ],
      ],
    );
  }
}

class _TwoColumn extends StatelessWidget {
  const _TwoColumn({required this.assets});

  final List<AssetSummary> assets;

  @override
  Widget build(BuildContext context) {
    final List<List<AssetSummary>> rows = <List<AssetSummary>>[];
    for (int i = 0; i < assets.length; i += 2) {
      final int end = (i + 2) > assets.length ? assets.length : i + 2;
      rows.add(assets.sublist(i, end));
    }

    return Column(
      children: <Widget>[
        for (int r = 0; r < rows.length; r++) ...<Widget>[
          if (r > 0) AppSpacing.gapV12,
          IntrinsicHeight(
            // A long asset name wraps one card taller than its neighbour, and a
            // row of two cards at different heights looks broken. `IntrinsicHeight`
            // equalises them — an expensive pass, affordable only because the row
            // holds two children.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int c = 0; c < 2; c++) ...<Widget>[
                  if (c > 0) AppSpacing.gapH12,
                  Expanded(
                    child: c < rows[r].length
                        ? AssetCard(asset: rows[r][c])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
