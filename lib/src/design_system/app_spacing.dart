import 'package:flutter/widgets.dart';

/// Spacing scale for Wealth OS.
///
/// A single 4-point scale. Every gap, padding and margin in the product must
/// come from here — never a raw number in a widget. This is what keeps nine
/// features visually consistent when nine different sessions of work touch
/// them.
///
/// | Token  | Value | Typical use                              |
/// |--------|-------|------------------------------------------|
/// | [x2s]  | 4     | Icon-to-label gap, tight chip padding    |
/// | [xs]   | 8     | Between related items in a row           |
/// | [sm]   | 12    | Internal padding of small controls       |
/// | [md]   | 16    | Default screen padding, card padding     |
/// | [lg]   | 20    | Between grouped elements                 |
/// | [xl]   | 24    | Between distinct blocks                  |
/// | [x2l]  | 32    | Section separation                       |
/// | [x3l]  | 40    | Large section separation                 |
/// | [x4l]  | 48    | Page-level breathing room, empty states  |
abstract final class AppSpacing {
  static const double x2s = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double x2l = 32;
  static const double x3l = 40;
  static const double x4l = 48;

  // -----------------------------------------------------------------------
  // Ready-made insets. Const, so they cost nothing to use.
  // -----------------------------------------------------------------------

  /// Standard horizontal padding for a screen body.
  static const EdgeInsets screenHorizontal =
      EdgeInsets.symmetric(horizontal: md);

  /// Standard padding for a screen body on all sides.
  static const EdgeInsets screenAll = EdgeInsets.all(md);

  /// Standard internal padding for a card or tile.
  static const EdgeInsets cardAll = EdgeInsets.all(md);

  // -----------------------------------------------------------------------
  // Ready-made gaps, for use inside Row and Column children lists.
  // -----------------------------------------------------------------------

  static const SizedBox gapV4 = SizedBox(height: x2s);
  static const SizedBox gapV8 = SizedBox(height: xs);
  static const SizedBox gapV12 = SizedBox(height: sm);
  static const SizedBox gapV16 = SizedBox(height: md);
  static const SizedBox gapV24 = SizedBox(height: xl);
  static const SizedBox gapV32 = SizedBox(height: x2l);

  static const SizedBox gapH4 = SizedBox(width: x2s);
  static const SizedBox gapH8 = SizedBox(width: xs);
  static const SizedBox gapH12 = SizedBox(width: sm);
  static const SizedBox gapH16 = SizedBox(width: md);
  static const SizedBox gapH24 = SizedBox(width: xl);
}
