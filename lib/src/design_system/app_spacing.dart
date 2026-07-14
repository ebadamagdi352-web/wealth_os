import 'package:flutter/widgets.dart';

/// Spacing scale for Wealth OS.
///
/// A single 4-point scale. Every gap, padding and margin in the product comes
/// from here — never a raw number in a widget. This is what keeps nine features
/// visually consistent when nine different sessions of work touch them.
///
/// | Token  | Value | Typical use                              |
/// |--------|-------|------------------------------------------|
/// | [x2s]  | 4     | Icon-to-label gap, tight chip padding    |
/// | [xs]   | 8     | Between related items in a row           |
/// | [sm]   | 12    | Internal padding of small controls       |
/// | [md]   | 16    | Screen padding on small phones           |
/// | [lg]   | 20    | Card padding, gap between sections       |
/// | [xl]   | 24    | Screen padding on tablets                |
/// | [x2l]  | 32    | Major separation                         |
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
  // Responsive screen padding (Task 013)
  //
  // A fixed 16pt gutter is correct on a 360dp phone and mean on a tablet, where
  // the content ends up pinned to the edges of a very wide sheet of glass. The
  // gutter grows with the window.
  // -----------------------------------------------------------------------

  /// Horizontal page gutter appropriate to [width].
  static double screenGutter(double width) {
    if (width >= tabletBreakpoint) {
      return xl; // 24
    }
    if (width >= largePhoneBreakpoint) {
      return lg; // 20
    }
    return md; // 16
  }

  /// Above this width, treat the window as a large phone.
  static const double largePhoneBreakpoint = 400;

  /// Above this width, treat the window as a tablet.
  static const double tabletBreakpoint = 600;

  // -----------------------------------------------------------------------
  // Ready-made insets.
  // -----------------------------------------------------------------------

  /// Internal padding of a card.
  ///
  /// Raised from 16 to 20 in Task 013. At 16 the content was touching the
  /// corners of a 20pt radius, which makes a card look cramped and cheap —
  /// padding must exceed the corner radius or the rounding eats into the text.
  static const EdgeInsets cardAll = EdgeInsets.all(lg);

  /// Internal padding of the hero card.
  static const EdgeInsets heroAll = EdgeInsets.all(xl);

  // -----------------------------------------------------------------------
  // Ready-made gaps, for use inside Row and Column children lists.
  // -----------------------------------------------------------------------

  static const SizedBox gapV4 = SizedBox(height: x2s);
  static const SizedBox gapV8 = SizedBox(height: xs);
  static const SizedBox gapV12 = SizedBox(height: sm);
  static const SizedBox gapV16 = SizedBox(height: md);
  static const SizedBox gapV20 = SizedBox(height: lg);
  static const SizedBox gapV24 = SizedBox(height: xl);
  static const SizedBox gapV32 = SizedBox(height: x2l);

  static const SizedBox gapH4 = SizedBox(width: x2s);
  static const SizedBox gapH8 = SizedBox(width: xs);
  static const SizedBox gapH12 = SizedBox(width: sm);
  static const SizedBox gapH16 = SizedBox(width: md);
  static const SizedBox gapH24 = SizedBox(width: xl);

  /// The rhythm between one dashboard section and the next.
  ///
  /// Named rather than left as a literal `gapV24`, because it is a *decision*
  /// about vertical rhythm, and a decision made once should be changeable once.
  static const SizedBox sectionGap = gapV24;
}
