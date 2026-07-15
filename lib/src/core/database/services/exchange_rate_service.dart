import 'package:wealth_os/src/core/database/app_database.dart';

/// The application-level contract for converting money between currencies.
///
/// Where `ExchangeRateRepository` stores and fetches rate *rows*, this service
/// answers the question the app actually asks — "how much is this, in that
/// currency, then?" — which means finding the right historical rate and applying it
/// to an integer minor-unit amount without ever going through a lossy `double`.
///
/// Interface only; the conversion arithmetic is the implementation's, and a later
/// task's.
abstract interface class ExchangeRateService {
  /// Converts [amountMinorUnits] from one currency to another, as of [asOf]
  /// (default: now), returning integer minor units of [to].
  ///
  /// "As of" matters: converting a transaction from last year uses last year's
  /// rate, so the returned figure is what it was worth *then*, not what the same
  /// amount would be worth at today's rate. The result is rounded to `to`'s
  /// precision by a rule the implementation defines and documents — rounding money
  /// is never accidental.
  Future<int> convertMinorUnits({
    required int amountMinorUnits,
    required Currency from,
    required Currency to,
    DateTime? asOf,
  });

  /// The rate row in force for a pair as of [asOf], or null if the pair has no
  /// recorded rate. Exposed for callers that want the rate itself — to show it, or
  /// to store it on a transaction at write time.
  Future<ExchangeRate?> effectiveRate({
    required Currency from,
    required Currency to,
    DateTime? asOf,
  });

  /// Whether a conversion is even possible between two currencies as of [asOf] —
  /// false when no rate connects them. Lets a caller disable a control instead of
  /// discovering the gap mid-calculation.
  Future<bool> canConvert({
    required Currency from,
    required Currency to,
    DateTime? asOf,
  });
}
