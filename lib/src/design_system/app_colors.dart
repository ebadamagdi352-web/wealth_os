import 'package:flutter/material.dart';

/// Colour palette for Wealth OS.
///
/// Two Material 3 [ColorScheme]s (light and dark), plus a small set of
/// semantic colours that Material does not model but a finance product
/// requires: gain, loss, warning and info.
///
/// The palette is a low-saturation teal-green with a soft navy accent —
/// calm rather than loud, which is what a product about someone's money
/// should feel like. Gain and loss are deliberately *not* pure red/green:
/// desaturated tones read as considered rather than alarming, and hold up
/// better against dark surfaces.
abstract final class AppColors {
  // ---------------------------------------------------------------------
  // LIGHT — Material 3 roles
  // ---------------------------------------------------------------------
  static const Color lightPrimary = Color(0xFF12695B);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFA2F2DF);
  static const Color lightOnPrimaryContainer = Color(0xFF00201A);

  static const Color lightSecondary = Color(0xFF4A635D);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFCCE8E0);
  static const Color lightOnSecondaryContainer = Color(0xFF05201B);

  static const Color lightTertiary = Color(0xFF3F6291);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFD3E4FF);
  static const Color lightOnTertiaryContainer = Color(0xFF001C38);

  static const Color lightError = Color(0xFFB3261E);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFF9DEDC);
  static const Color lightOnErrorContainer = Color(0xFF410E0B);

  static const Color lightSurface = Color(0xFFF7FAF8);
  static const Color lightOnSurface = Color(0xFF191C1B);
  static const Color lightOnSurfaceVariant = Color(0xFF3F4946);

  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerLow = Color(0xFFF1F5F3);
  static const Color lightSurfaceContainer = Color(0xFFECF0EE);
  static const Color lightSurfaceContainerHigh = Color(0xFFE6EAE8);
  static const Color lightSurfaceContainerHighest = Color(0xFFE0E4E2);

  static const Color lightOutline = Color(0xFF6F7975);
  static const Color lightOutlineVariant = Color(0xFFBFC9C4);

  static const Color lightInverseSurface = Color(0xFF2E3130);
  static const Color lightOnInverseSurface = Color(0xFFEFF1EF);
  static const Color lightInversePrimary = Color(0xFF85D6C3);

  // ---------------------------------------------------------------------
  // DARK — Material 3 roles
  // ---------------------------------------------------------------------
  static const Color darkPrimary = Color(0xFF85D6C3);
  static const Color darkOnPrimary = Color(0xFF00382E);
  static const Color darkPrimaryContainer = Color(0xFF005143);
  static const Color darkOnPrimaryContainer = Color(0xFFA2F2DF);

  static const Color darkSecondary = Color(0xFFB0CCC4);
  static const Color darkOnSecondary = Color(0xFF1C3530);
  static const Color darkSecondaryContainer = Color(0xFF334C46);
  static const Color darkOnSecondaryContainer = Color(0xFFCCE8E0);

  static const Color darkTertiary = Color(0xFFA6C8FF);
  static const Color darkOnTertiary = Color(0xFF00315B);
  static const Color darkTertiaryContainer = Color(0xFF234A79);
  static const Color darkOnTertiaryContainer = Color(0xFFD3E4FF);

  static const Color darkError = Color(0xFFF2B8B5);
  static const Color darkOnError = Color(0xFF601410);
  static const Color darkErrorContainer = Color(0xFF8C1D18);
  static const Color darkOnErrorContainer = Color(0xFFF9DEDC);

  static const Color darkSurface = Color(0xFF101413);
  static const Color darkOnSurface = Color(0xFFE0E4E2);
  static const Color darkOnSurfaceVariant = Color(0xFFBFC9C4);

  static const Color darkSurfaceContainerLowest = Color(0xFF0B0F0E);
  static const Color darkSurfaceContainerLow = Color(0xFF191C1B);
  static const Color darkSurfaceContainer = Color(0xFF1D2120);
  static const Color darkSurfaceContainerHigh = Color(0xFF272B2A);
  static const Color darkSurfaceContainerHighest = Color(0xFF323635);

  static const Color darkOutline = Color(0xFF899390);
  static const Color darkOutlineVariant = Color(0xFF3F4946);

  static const Color darkInverseSurface = Color(0xFFE0E4E2);
  static const Color darkOnInverseSurface = Color(0xFF2E3130);
  static const Color darkInversePrimary = Color(0xFF12695B);

  // ---------------------------------------------------------------------
  // SHARED
  // ---------------------------------------------------------------------
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // ---------------------------------------------------------------------
  // SEMANTIC — finance
  //
  // Material 3 has no role for "this number went up". These fill that gap.
  // They are plain constants for now; see TASK_005_REPORT.md for why they
  // are not yet a ThemeExtension.
  // ---------------------------------------------------------------------
  static const Color lightGain = Color(0xFF1B7F4B);
  static const Color lightOnGain = Color(0xFFFFFFFF);
  static const Color lightGainContainer = Color(0xFFC7F0D8);
  static const Color lightOnGainContainer = Color(0xFF00210F);

  static const Color lightLoss = Color(0xFFC02626);
  static const Color lightOnLoss = Color(0xFFFFFFFF);
  static const Color lightLossContainer = Color(0xFFFFDAD6);
  static const Color lightOnLossContainer = Color(0xFF410002);

  static const Color lightWarning = Color(0xFFB26A00);
  static const Color lightOnWarning = Color(0xFFFFFFFF);

  static const Color lightInfo = Color(0xFF2C6EA8);
  static const Color lightOnInfo = Color(0xFFFFFFFF);

  static const Color darkGain = Color(0xFF7ADCA4);
  static const Color darkOnGain = Color(0xFF003920);
  static const Color darkGainContainer = Color(0xFF005230);
  static const Color darkOnGainContainer = Color(0xFFC7F0D8);

  static const Color darkLoss = Color(0xFFFFB4AB);
  static const Color darkOnLoss = Color(0xFF690005);
  static const Color darkLossContainer = Color(0xFF93000A);
  static const Color darkOnLossContainer = Color(0xFFFFDAD6);

  static const Color darkWarning = Color(0xFFFFB870);
  static const Color darkOnWarning = Color(0xFF4A2800);

  static const Color darkInfo = Color(0xFF9CCBFF);
  static const Color darkOnInfo = Color(0xFF00325A);

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
