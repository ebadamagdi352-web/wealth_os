import 'package:flutter/material.dart';

/// Typography for Wealth OS.
///
/// A complete Material 3 [TextTheme] — all fifteen roles — built entirely on
/// system fonts. No font asset is bundled and none is downloaded.
///
/// ## Why it is Arabic-ready
///
/// **`letterSpacing` is zero everywhere.** Material's default scale applies
/// positive tracking to several roles. Arabic is cursive — its letters *join* —
/// and tracking pulls those joins apart, producing text that is not merely ugly
/// but harder to read. Zero is the only safe value for a bilingual scale.
///
/// This has a cost worth naming: optical tracking is the usual way to make large
/// display type feel tight and expensive, and it is unavailable to us. Weight and
/// size do that work here instead.
///
/// `fontFamily` is left null, so Flutter resolves the platform's own UI font,
/// which already carries Arabic coverage on both Android and iOS. Line heights
/// are kept generous, because Arabic stacks diacritics above and below the
/// baseline.
///
/// ## Weight is part of the scale, not a per-widget decision (Task 013)
///
/// Every `title` role now carries `w600`. Before, each widget wrote
/// `.copyWith(fontWeight: FontWeight.w600)` on its own — which is a design
/// decision repeated in six files, and therefore six files that can drift apart.
/// Hierarchy is a property of the scale.
///
/// Colour is intentionally absent. [ThemeData] applies the colour scheme's
/// `onSurface` family automatically; hardcoding colour here is the single most
/// common way a design system breaks dark mode.
abstract final class AppTypography {
  /// Fallback chain used when the platform default lacks a glyph.
  ///
  /// Unknown family names are skipped silently by the engine, so listing the
  /// Android and iOS Arabic faces together is safe on both platforms.
  static const List<String> fontFamilyFallback = <String>[
    'Noto Naskh Arabic', // Android
    'Geeza Pro', // iOS
    'Arial',
  ];

  static const TextStyle _base = TextStyle(
    letterSpacing: 0,
    fontFamilyFallback: fontFamilyFallback,
  );

  /// Figures that occupy identical width regardless of digit.
  ///
  /// Money must be set in tabular figures. With proportional figures a `1` is
  /// narrower than a `0`, so a column of amounts fails to align on the decimal —
  /// and misaligned money is the fastest way for a finance product to look
  /// untrustworthy.
  static const List<FontFeature> tabularFigures = <FontFeature>[
    FontFeature.tabularFigures(),
  ];

  // ---------------------------------------------------------------------
  // Display — the hero figure, and essentially nothing else.
  // ---------------------------------------------------------------------
  static final TextStyle displayLarge = _base.copyWith(
    fontSize: 52,
    height: 60 / 52,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle displayMedium = _base.copyWith(
    fontSize: 42,
    height: 50 / 42,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle displaySmall = _base.copyWith(
    fontSize: 34,
    height: 42 / 34,
    fontWeight: FontWeight.w600,
  );

  // ---------------------------------------------------------------------
  // Headline — screen titles.
  //
  // Task 013 pulled these down. The old headlineMedium was 28pt, which on a
  // 360dp phone is a title competing with the net-worth figure for attention.
  // Only one thing on a screen may be the loudest.
  // ---------------------------------------------------------------------
  static final TextStyle headlineLarge = _base.copyWith(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle headlineMedium = _base.copyWith(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle headlineSmall = _base.copyWith(
    fontSize: 21,
    height: 28 / 21,
    fontWeight: FontWeight.w600,
  );

  // ---------------------------------------------------------------------
  // Title — app bars, card headers, section labels.
  // ---------------------------------------------------------------------
  static final TextStyle titleLarge = _base.copyWith(
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle titleMedium = _base.copyWith(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle titleSmall = _base.copyWith(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );

  // ---------------------------------------------------------------------
  // Body — the default reading size for all prose and list content.
  // ---------------------------------------------------------------------
  static final TextStyle bodyLarge = _base.copyWith(
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle bodyMedium = _base.copyWith(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );

  // ---------------------------------------------------------------------
  // Label — buttons, chips, navigation, captions.
  // ---------------------------------------------------------------------
  static final TextStyle labelLarge = _base.copyWith(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle labelMedium = _base.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle labelSmall = _base.copyWith(
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w500,
  );

  /// The complete Material 3 text theme, colour-free.
  static final TextTheme textTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
