import 'package:flutter/material.dart';

/// Typography for Wealth OS.
///
/// A complete Material 3 [TextTheme] — all fifteen roles — built entirely on
/// system fonts. No font asset is bundled and none is downloaded.
///
/// ## Why it is Arabic-ready
///
/// Three deliberate choices, each of which would break Arabic if made the
/// usual way:
///
/// 1. **`letterSpacing` is zero everywhere.** Material's default scale applies
///    positive tracking to several roles. Arabic is a cursive script: its
///    letters join. Adding tracking pulls the joins apart and produces text
///    that is not merely ugly but genuinely harder to read. Zero is the only
///    safe value for a bilingual scale.
///
/// 2. **`fontFamily` is left null.** Flutter then resolves the platform's own
///    UI font, which already carries Arabic coverage on both Android and iOS.
///    Naming a Latin-only family here would force fallback on every Arabic
///    glyph and produce mismatched metrics between the two scripts.
///
/// 3. **Line heights are generous.** Arabic stacks diacritics above and below
///    the baseline. The Material line heights are retained in full rather than
///    tightened, so nothing clips.
///
/// Colour is intentionally absent. [ThemeData] applies the colour scheme's
/// `onSurface` family to these styles automatically; hardcoding colour here
/// would break dark mode.
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

  // ---------------------------------------------------------------------
  // Display — reserved for hero figures. In this product that means the
  // headline net-worth number, and very little else.
  // ---------------------------------------------------------------------
  static final TextStyle displayLarge = _base.copyWith(
    fontSize: 57,
    height: 64 / 57,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle displayMedium = _base.copyWith(
    fontSize: 45,
    height: 52 / 45,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle displaySmall = _base.copyWith(
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w400,
  );

  // ---------------------------------------------------------------------
  // Headline — screen titles and major section headers.
  // ---------------------------------------------------------------------
  static final TextStyle headlineLarge = _base.copyWith(
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle headlineMedium = _base.copyWith(
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle headlineSmall = _base.copyWith(
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w400,
  );

  // ---------------------------------------------------------------------
  // Title — app bars, card headers, list section labels.
  // ---------------------------------------------------------------------
  static final TextStyle titleLarge = _base.copyWith(
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle titleMedium = _base.copyWith(
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle titleSmall = _base.copyWith(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
  );

  // ---------------------------------------------------------------------
  // Body — the default reading size for all prose and list content.
  // ---------------------------------------------------------------------
  static final TextStyle bodyLarge = _base.copyWith(
    fontSize: 16,
    height: 24 / 16,
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
  // Label — buttons, chips, tabs, captions on figures.
  // ---------------------------------------------------------------------
  static final TextStyle labelLarge = _base.copyWith(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle labelMedium = _base.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle labelSmall = _base.copyWith(
    fontSize: 11,
    height: 16 / 11,
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
