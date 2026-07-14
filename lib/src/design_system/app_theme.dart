import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_colors.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';

/// Theme construction for Wealth OS.
///
/// [light] and [dark] are the only two themes the product will ever have.
/// Both are assembled from the same component definitions, differing solely
/// in the [ColorScheme] passed in — so a component styled once is styled
/// correctly in both modes, and cannot drift apart over time.
///
/// This file is **not yet wired into the application**. Task 005 builds the
/// design system; connecting it to `WealthOsApp` is a later task.
abstract final class AppTheme {
  /// Light theme.
  static ThemeData light() => _build(AppColors.lightScheme);

  /// Dark theme.
  static ThemeData dark() => _build(AppColors.darkScheme);

  static ThemeData _build(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: _appBarTheme(scheme),
      dividerTheme: _dividerTheme(scheme),
      bottomSheetTheme: _bottomSheetTheme(scheme),
      filledButtonTheme: FilledButtonThemeData(style: _filledButtonStyle()),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: _elevatedButtonStyle()),
      outlinedButtonTheme:
          OutlinedButtonThemeData(style: _outlinedButtonStyle()),
      textButtonTheme: TextButtonThemeData(style: _textButtonStyle()),
    );
  }

  // ---------------------------------------------------------------------
  // Components
  // ---------------------------------------------------------------------

  static AppBarTheme _appBarTheme(ColorScheme scheme) {
    return AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: scheme.onSurface,
      ),
    );
  }

  static DividerThemeData _dividerTheme(ColorScheme scheme) {
    return DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: AppSpacing.md,
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme scheme) {
    return BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.borderTopXl,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Buttons
  //
  // Every button shares one padding rhythm and one corner radius, both drawn
  // from the scale. Colours are omitted deliberately: `styleFrom` falls back
  // to the ColorScheme, so each button is correct in light and dark without
  // being told twice.
  // ---------------------------------------------------------------------

  static const EdgeInsets _buttonPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
    vertical: AppSpacing.sm,
  );

  static const RoundedRectangleBorder _buttonShape = RoundedRectangleBorder(
    borderRadius: AppRadius.borderMd,
  );

  static ButtonStyle _filledButtonStyle() {
    return FilledButton.styleFrom(
      padding: _buttonPadding,
      shape: _buttonShape,
      textStyle: AppTypography.labelLarge,
      minimumSize: const Size(0, AppSpacing.x4l),
    );
  }

  static ButtonStyle _elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: _buttonPadding,
      shape: _buttonShape,
      textStyle: AppTypography.labelLarge,
      minimumSize: const Size(0, AppSpacing.x4l),
    );
  }

  static ButtonStyle _outlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: _buttonPadding,
      shape: _buttonShape,
      textStyle: AppTypography.labelLarge,
      minimumSize: const Size(0, AppSpacing.x4l),
    );
  }

  static ButtonStyle _textButtonStyle() {
    return TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.borderSm,
      ),
      textStyle: AppTypography.labelLarge,
    );
  }
}
