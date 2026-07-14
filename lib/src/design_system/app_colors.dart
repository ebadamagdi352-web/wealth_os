import 'package:flutter/material.dart';

/// Colour palette for Wealth OS.
///
/// ## What changed in Task 013, and why
///
/// The previous palette was built around a bright mint (`#A2F2DF`) as
/// `primaryContainer`, and the net-worth card sat on it. Mint is a *fresh*
/// colour — it belongs on a fitness app or a savings challenge. It does not
/// belong under someone's net worth, because the emotional register is wrong:
/// premium finance does not shout, it recedes.
///
/// Three moves make it feel expensive rather than cheerful:
///
/// 1. **The greens got deeper and quieter.** Saturation down, value down.
///    `#12695B` → `#0E5C4F`; the mint container → a soft sage.
/// 2. **The surfaces went neutral.** They were tinted green
///    (`#F7FAF8`), which reads as a *theme* rather than as paper. Near-neutral
///    greys let the one accent colour do all the work.
/// 3. **The hero became ink.** The net-worth card is now a near-black card with
///    light type — the visual language of a metal credit card. That contrast is
///    what makes one number on a screen feel like *the* number.
abstract final class AppColors {
  // ---------------------------------------------------------------------
  // LIGHT — Material 3 roles
  // ---------------------------------------------------------------------
  static const Color lightPrimary = Color(0xFF0E5C4F);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFCFE6DE);
  static const Color lightOnPrimaryContainer = Color(0xFF05261F);

  static const Color lightSecondary = Color(0xFF4C6259);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFDCE5E1);
  static const Color lightOnSecondaryContainer = Color(0xFF101F1B);

  static const Color lightTertiary = Color(0xFF3B5B7A);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFD8E4EF);
  static const Color lightOnTertiaryContainer = Color(0xFF0B2233);

  static const Color lightError = Color(0xFFB3261E);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFF6DEDC);
  static const Color lightOnErrorContainer = Color(0xFF410E0B);

  // Neutral, not green-tinted. Paper, not theme.
  static const Color lightSurface = Color(0xFFFAFAF9);
  static const Color lightOnSurface = Color(0xFF171A19);
  static const Color lightOnSurfaceVariant = Color(0xFF5B615F);

  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerLow = Color(0xFFF5F6F5);
  static const Color lightSurfaceContainer = Color(0xFFF0F1F0);
  static const Color lightSurfaceContainerHigh = Color(0xFFEAECEB);
  static const Color lightSurfaceContainerHighest = Color(0xFFE4E6E5);

  static const Color lightOutline = Color(0xFF7B817F);

  /// Hairline borders. Deliberately faint — a card should be *suggested*, not
  /// fenced in. A visible 1px grey rectangle around everything is the single
  /// fastest way to make a UI look like a form from 2009.
  static const Color lightOutlineVariant = Color(0xFFDFE2E0);

  static const Color lightInverseSurface = Color(0xFF2B2F2E);
  static const Color lightOnInverseSurface = Color(0xFFF0F1F0);
  static const Color lightInversePrimary = Color(0xFF8FCEBF);

  // ---------------------------------------------------------------------
  // DARK — Material 3 roles
  // ---------------------------------------------------------------------
  static const Color darkPrimary = Color(0xFF7FCCBA);
  static const Color darkOnPrimary = Color(0xFF00382E);
  static const Color darkPrimaryContainer = Color(0xFF145145);
  static const Color darkOnPrimaryContainer = Color(0xFFB7E9DC);

  static const Color darkSecondary = Color(0xFFAFC3BB);
  static const Color darkOnSecondary = Color(0xFF1B322C);
  static const Color darkSecondaryContainer = Color(0xFF31473F);
  static const Color darkOnSecondaryContainer = Color(0xFFDCE5E1);

  static const Color darkTertiary = Color(0xFFA3C3E0);
  static const Color darkOnTertiary = Color(0xFF0D2B42);
  static const Color darkTertiaryContainer = Color(0xFF2B455C);
  static const Color darkOnTertiaryContainer = Color(0xFFD8E4EF);

  static const Color darkError = Color(0xFFF2B8B5);
  static const Color darkOnError = Color(0xFF601410);
  static const Color darkErrorContainer = Color(0xFF8C1D18);
  static const Color darkOnErrorContainer = Color(0xFFF6DEDC);

  static const Color darkSurface = Color(0xFF0F1211);
  static const Color darkOnSurface = Color(0xFFE2E4E3);
  static const Color darkOnSurfaceVariant = Color(0xFFB7BDBA);

  static const Color darkSurfaceContainerLowest = Color(0xFF0A0D0C);
  static const Color darkSurfaceContainerLow = Color(0xFF151817);
  static const Color darkSurfaceContainer = Color(0xFF191D1C);
  static const Color darkSurfaceContainerHigh = Color(0xFF232726);
  static const Color darkSurfaceContainerHighest = Color(0xFF2D3130);

  static const Color darkOutline = Color(0xFF868C8A);
  static const Color darkOutlineVariant = Color(0xFF333836);

  static const Color darkInverseSurface = Color(0xFFE2E4E3);
  static const Color darkOnInverseSurface = Color(0xFF2B2F2E);
  static const Color darkInversePrimary = Color(0xFF0E5C4F);

  // ---------------------------------------------------------------------
  // SHARED
  // ---------------------------------------------------------------------
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // ---------------------------------------------------------------------
  // HERO — the net-worth card
  //
  // Material 3 has no role for "the one surface on this screen that must
  // dominate every other surface". These fill that gap.
  //
  // Deep ink in both modes, rather than flipping to light in dark mode the way
  // `inverseSurface` would. The hero is not an inversion of the page — it is a
  // physical object sitting on the page, and objects do not change colour when
  // the room does.
  // ---------------------------------------------------------------------
  static const Color lightHeroSurface = Color(0xFF0C443A);
  static const Color lightOnHeroSurface = Color(0xFFEAF3F0);
  static const Color lightOnHeroSurfaceMuted = Color(0xFF9CC2B8);

  static const Color darkHeroSurface = Color(0xFF14332C);
  static const Color darkOnHeroSurface = Color(0xFFE2EDE9);
  static const Color darkOnHeroSurfaceMuted = Color(0xFF8FB3A9);

  /// The hero surface for [brightness].
  static Color heroSurface(Brightness brightness) =>
      brightness == Brightness.dark ? darkHeroSurface : lightHeroSurface;

  /// Type on the hero surface.
  static Color onHeroSurface(Brightness brightness) =>
      brightness == Brightness.dark ? darkOnHeroSurface : lightOnHeroSurface;

  /// Secondary type on the hero surface — labels, captions.
  static Color onHeroSurfaceMuted(Brightness brightness) =>
      brightness == Brightness.dark
          ? darkOnHeroSurfaceMuted
          : lightOnHeroSurfaceMuted;

  // ---------------------------------------------------------------------
  // SEMANTIC — finance
  //
  // Desaturated on purpose. A 2% dip is not an emergency, and fire-engine red
  // says it is. Colour must also never be the *only* signal — every amount in
  // the product carries an explicit sign, because roughly one man in twelve
  // cannot reliably separate these two hues.
  // ---------------------------------------------------------------------
  static const Color lightGain = Color(0xFF1E7A57);
  static const Color lightOnGain = Color(0xFFFFFFFF);
  static const Color lightGainContainer = Color(0xFFD3EBDF);
  static const Color lightOnGainContainer = Color(0xFF04240F);

  static const Color lightLoss = Color(0xFFB0403A);
  static const Color lightOnLoss = Color(0xFFFFFFFF);
  static const Color lightLossContainer = Color(0xFFF4DDDB);
  static const Color lightOnLossContainer = Color(0xFF3F0908);

  static const Color lightWarning = Color(0xFF9C6410);
  static const Color lightOnWarning = Color(0xFFFFFFFF);

  static const Color lightInfo = Color(0xFF2C5F92);
  static const Color lightOnInfo = Color(0xFFFFFFFF);

  static const Color darkGain = Color(0xFF74CBA0);
  static const Color darkOnGain = Color(0xFF00341C);
  static const Color darkGainContainer = Color(0xFF135032);
  static const Color darkOnGainContainer = Color(0xFFD3EBDF);

  static const Color darkLoss = Color(0xFFEDA6A0);
  static const Color darkOnLoss = Color(0xFF5A100C);
  static const Color darkLossContainer = Color(0xFF7D231E);
  static const Color darkOnLossContainer = Color(0xFFF4DDDB);

  static const Color darkWarning = Color(0xFFE9B36A);
  static const Color darkOnWarning = Color(0xFF432A00);

  static const Color darkInfo = Color(0xFF9CBFE2);
  static const Color darkOnInfo = Color(0xFF10314F);

  // ---------------------------------------------------------------------
  // SCHEMES
  // ---------------------------------------------------------------------

  /// Material 3 colour scheme for light mode.
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: lightPrimary,
    onPrimary: lightOnPrimary,
    primaryContainer: lightPrimaryContainer,
    onPrimaryContainer: lightOnPrimaryContainer,
    secondary: lightSecondary,
    onSecondary: lightOnSecondary,
    secondaryContainer: lightSecondaryContainer,
    onSecondaryContainer: lightOnSecondaryContainer,
    tertiary: lightTertiary,
    onTertiary: lightOnTertiary,
    tertiaryContainer: lightTertiaryContainer,
    onTertiaryContainer: lightOnTertiaryContainer,
    error: lightError,
    onError: lightOnError,
    errorContainer: lightErrorContainer,
    onErrorContainer: lightOnErrorContainer,
    surface: lightSurface,
    onSurface: lightOnSurface,
    onSurfaceVariant: lightOnSurfaceVariant,
    surfaceContainerLowest: lightSurfaceContainerLowest,
    surfaceContainerLow: lightSurfaceContainerLow,
    surfaceContainer: lightSurfaceContainer,
    surfaceContainerHigh: lightSurfaceContainerHigh,
    surfaceContainerHighest: lightSurfaceContainerHighest,
    outline: lightOutline,
    outlineVariant: lightOutlineVariant,
    shadow: shadow,
    scrim: scrim,
    inverseSurface: lightInverseSurface,
    onInverseSurface: lightOnInverseSurface,
    inversePrimary: lightInversePrimary,
  );

  /// Material 3 colour scheme for dark mode.
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimary,
    onPrimary: darkOnPrimary,
    primaryContainer: darkPrimaryContainer,
    onPrimaryContainer: darkOnPrimaryContainer,
    secondary: darkSecondary,
    onSecondary: darkOnSecondary,
    secondaryContainer: darkSecondaryContainer,
    onSecondaryContainer: darkOnSecondaryContainer,
    tertiary: darkTertiary,
    onTertiary: darkOnTertiary,
    tertiaryContainer: darkTertiaryContainer,
    onTertiaryContainer: darkOnTertiaryContainer,
    error: darkError,
    onError: darkOnError,
    errorContainer: darkErrorContainer,
    onErrorContainer: darkOnErrorContainer,
    surface: darkSurface,
    onSurface: darkOnSurface,
    onSurfaceVariant: darkOnSurfaceVariant,
    surfaceContainerLowest: darkSurfaceContainerLowest,
    surfaceContainerLow: darkSurfaceContainerLow,
    surfaceContainer: darkSurfaceContainer,
    surfaceContainerHigh: darkSurfaceContainerHigh,
    surfaceContainerHighest: darkSurfaceContainerHighest,
    outline: darkOutline,
    outlineVariant: darkOutlineVariant,
    shadow: shadow,
    scrim: scrim,
    inverseSurface: darkInverseSurface,
    onInverseSurface: darkOnInverseSurface,
    inversePrimary: darkInversePrimary,
  );
}
