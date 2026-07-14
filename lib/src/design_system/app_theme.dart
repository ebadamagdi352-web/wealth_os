import 'package:flutter/material.dart';
import 'package:wealth_os/src/design_system/app_colors.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';

/// Elevation for Wealth OS.
///
/// ## Shadows in light, borders in dark — and never both
///
/// A shadow is light being blocked. In a dark interface there is no light to
/// block: a black shadow against a near-black surface is invisible, so a card
/// that relies on one simply vanishes. Material's own answer is a *surface tint*
/// that lightens the card instead — which works, but stacks tints on tints and
/// tends to look muddy.
///
/// So elevation is expressed differently in each mode:
///
/// * **Light** — a soft, wide, low-opacity shadow. Two layers: a tight one for
///   the contact edge, a broad one for the ambient lift. One shadow at high
///   opacity looks like a drop shadow from a 2005 web page; two at low opacity
///   look like an object resting on paper.
/// * **Dark** — no shadow at all. A hairline border and a slightly lighter
///   surface do the separating.
///
/// Using both in either mode is what makes a card look like a mistake.
abstract final class AppShadows {
  /// Resting elevation for a card.
  static List<BoxShadow> card(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const <BoxShadow>[];
    }
    return const <BoxShadow>[
      BoxShadow(
        color: Color(0x0A0F1A17),
        blurRadius: 2,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0x0F0F1A17),
        blurRadius: 16,
        offset: Offset(0, 6),
      ),
    ];
  }

  /// Elevation for the hero card, which sits above everything else.
  static List<BoxShadow> hero(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const <BoxShadow>[];
    }
    return const <BoxShadow>[
      BoxShadow(
        color: Color(0x1A0C443A),
        blurRadius: 24,
        offset: Offset(0, 10),
      ),
    ];
  }
}

/// Theme construction for Wealth OS.
///
/// [light] and [dark] are the only two themes the product will ever have. Both
/// are assembled from the same component definitions, differing solely in the
/// [ColorScheme] passed in — so a component styled once is styled correctly in
/// both modes and cannot drift.
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
      navigationBarTheme: _navigationBarTheme(scheme),
      filledButtonTheme: FilledButtonThemeData(style: _filledButtonStyle()),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: _elevatedButtonStyle()),
      outlinedButtonTheme:
          OutlinedButtonThemeData(style: _outlinedButtonStyle()),
      textButtonTheme: TextButtonThemeData(style: _textButtonStyle()),
    );
  }

  // ---------------------------------------------------------------------
  // Navigation bar
  // ---------------------------------------------------------------------

  /// Material 3 navigation bar.
  ///
  /// Emphasis lives in **three** signals at once, and only on the selected
  /// destination:
  ///
  /// 1. The pill indicator behind the icon.
  /// 2. A filled icon, where the others are outlined.
  /// 3. A heavier label, in a stronger colour.
  ///
  /// Unselected destinations get `onSurfaceVariant` and a normal weight — quiet,
  /// legible, and clearly secondary. A bar where every item competes is a bar
  /// where nothing is findable.
  ///
  /// `surfaceTintColor` is transparent. Material 3's default tints an elevated
  /// surface with the primary colour, which on a navigation bar produces a faint
  /// green wash that reads as a rendering bug rather than as a decision.
  static NavigationBarThemeData _navigationBarTheme(ColorScheme scheme) {
    return NavigationBarThemeData(
      height: 68,
      backgroundColor: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      indicatorColor: scheme.secondaryContainer,
      indicatorShape: const RoundedRectangleBorder(
        borderRadius: AppRadius.borderPill,
      ),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (Set<WidgetState> states) {
          final bool isSelected = states.contains(WidgetState.selected);
          return AppTypography.labelSmall.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? scheme.onSurface : scheme.onSurfaceVariant,
          );
        },
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
        (Set<WidgetState> states) {
          final bool isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: isSelected
                ? scheme.onSecondaryContainer
                : scheme.onSurfaceVariant,
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Other components
  // ---------------------------------------------------------------------

  static AppBarTheme _appBarTheme(ColorScheme scheme) {
    return AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
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
  // One padding rhythm and one corner radius across every button family.
  // Colours are omitted deliberately: `styleFrom` falls back to the
  // ColorScheme, so each button is correct in light and dark without being told
  // twice.
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
