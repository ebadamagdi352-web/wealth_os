import 'package:flutter/widgets.dart';

/// Corner radius scale for Wealth OS.
///
/// Both the raw doubles and ready-made [BorderRadius] values are exposed.
/// Prefer the [BorderRadius] constants — they are `const`, so they allocate
/// once, whereas `BorderRadius.circular(...)` builds a new object on every
/// widget rebuild.
///
/// | Token    | Value | Typical use                            |
/// |----------|-------|----------------------------------------|
/// | [none]   | 0     | Full-bleed surfaces, dividers          |
/// | [xs]     | 4     | Chips, badges, tags                    |
/// | [sm]     | 8     | Text fields, small buttons             |
/// | [md]     | 12    | Buttons, list tiles                    |
/// | [lg]     | 16    | Cards, containers                      |
/// | [xl]     | 24    | Bottom sheets, dialogs, modals         |
/// | [pill]   | 999   | Fully rounded — avatars, filter chips  |
abstract final class AppRadius {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;

  // -----------------------------------------------------------------------
  // Uniform border radii.
  // -----------------------------------------------------------------------

  static const BorderRadius borderNone = BorderRadius.zero;
  static const BorderRadius borderXs =
      BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderSm =
      BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd =
      BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg =
      BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderXl =
      BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderPill =
      BorderRadius.all(Radius.circular(pill));

  // -----------------------------------------------------------------------
  // Top-only radius, for bottom sheets and drawers.
  // -----------------------------------------------------------------------

  static const BorderRadius borderTopLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  static const BorderRadius borderTopXl = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
}
