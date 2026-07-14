import 'package:equatable/equatable.dart';

/// Which way an asset has moved, independent of the raw number.
///
/// Chosen from the performance value, but named as its own concept because the
/// card colours from *this*, not from the sign of a float. `up`/`down`/`flat` is
/// three cases a `switch` can be exhaustive over; a raw `double` is infinitely
/// many, and "is this one neutral?" then gets re-decided, slightly differently,
/// at every call site.
enum AssetTrend { up, down, flat }

/// One asset holding, as the assets screen needs to see it.
///
/// ## Why this is a plain class, when `AccountSummary` is `sealed`
///
/// Accounts needed sealing because a credit card is **structurally** different
/// from a chequing account — a limit and a used amount where the other has a
/// balance. Gold and real estate have no such split: name, value, performance,
/// currency, and that is the whole of it. Cash is an asset whose performance
/// happens to be zero, not a different kind of thing.
///
/// Meaning is an enum; shape is a hierarchy. These four assets share one shape,
/// so this is a plain class with a [trend] enum — the same call made for
/// `TransactionSummary` in Task 015, and for the same reason.
class AssetSummary extends Equatable {
  const AssetSummary({
    required this.id,
    required this.name,
    required this.value,
    required this.performance,
    required this.currencyCode,
    required this.iconKey,
  });

  /// Stable identifier. Generated client-side, so an asset has an id from the
  /// moment it is created — before any database has seen it.
  final String id;

  /// The user's own name for the holding. **Never translated** — their data.
  final String name;

  /// Current value, in [currencyCode].
  final double value;

  /// Performance as a **fraction**: `0.082` is +8.2%, `-0.05` is −5%.
  ///
  /// A fraction, not percent points, so it shares one scale with the
  /// distribution shares and can be handed straight to `NumberFormat`'s percent
  /// pattern without a `/100` that someone will eventually forget.
  ///
  /// ## ⚠️ Over what period?
  ///
  /// This is the question the model cannot answer and the brief did not specify.
  /// "+8.2%" since when — a day, a month, a year, since purchase? In a wealth
  /// product the period is not a footnote; +8.2% in a day and +8.2% in a decade
  /// are opposite stories about the same asset. A bare percentage with no period
  /// is display-only, and the real model will need a period *and* a cost basis
  /// before this figure can mean anything. Flagged in TASK_017_REPORT.md.
  final double performance;

  /// ISO 4217 code. Per asset — a holding may be denominated in anything.
  final String currencyCode;

  /// Stable identifier for the icon. A string, not an `IconData`, so this file
  /// stays pure Dart and can be unit-tested without a widget binding.
  final String iconKey;

  /// Below this magnitude, performance is treated as flat.
  ///
  /// Half of 0.01% on the fraction scale. Stops a rounding-dust value like
  /// `0.00001` from rendering as a green up-arrow on what is really no change.
  static const double _flatEpsilon = 0.00005;

  /// Which way this asset has moved.
  AssetTrend get trend {
    if (performance > _flatEpsilon) {
      return AssetTrend.up;
    }
    if (performance < -_flatEpsilon) {
      return AssetTrend.down;
    }
    return AssetTrend.flat;
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        value,
        performance,
        currencyCode,
        iconKey,
      ];

  @override
  bool get stringify => true;
}
