import 'package:flutter/widgets.dart';

/// Corner radius scale for Wealth OS.
///
/// Both the raw doubles and ready-made [BorderRadius] values are exposed. Prefer
/// the [BorderRadius] constants — they are `const`, so they allocate once,
/// whereas `BorderRadius.circular(...)` builds a new object on every rebuild.
///
/// ## Task 013
///
/// [card] (20) and [hero] (24) were added. Cards were previously drawn at
/// [lg] (16), which is the radius of a *control* — a button, a text field. A card
/// is a larger object and needs a proportionally larger corner, or it reads as a
/// button that grew. The eye reads corner radius relative to the shape's size,
/// not in absolute pixels.
///
/// | Token    | Value | Typical use                            |
/// |----------|-------|----------------------------------------|
/// | [none]   | 0     | Full-bleed surfaces, dividers          |
/// | [xs]     | 4     | Progress bars, badges                  |
/// | [sm]     | 8     | Icon tiles, small chips                |
/// | [md]     | 12    | Buttons, list tiles                    |
/// | [lg]     | 16    | Inner containers, quick-action tiles   |
/// | [card]   | 20    | Cards                                  |
/// | [hero]   | 24    | The net-worth card, bottom sheets      |
/// | [xl]     | 24    | Dialogs, modals                        |
/// | [pill]   | 999   | Fully rounded — avatars, indicators    |
abstract final class AppRadius {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double card = 20;
  static const double hero = 24;
  static const double xl = 24;
  static const double pill = 999;

  // -----------------------------------------------------------------------
  // Uniform border radii.
  // -----------------------------------------------------------------------

  static const BorderRadius borderNone = BorderRadius.zero;
  static const BorderRadius borderXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderCard =
      BorderRadius.all(Radius.circular(card));
  static const BorderRadius borderHero =
      BorderRadius.all(Radius.circular(hero));
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(xl));
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
