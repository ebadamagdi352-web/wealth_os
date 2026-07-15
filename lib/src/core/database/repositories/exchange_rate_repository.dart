import 'package:wealth_os/src/core/database/app_database.dart';

/// Persistence contract for exchange rates.
///
/// Reads lean on the fact that rates are append-only history: "the rate now" is
/// "the newest row for this pair", and "the rate then" is "the newest row on or
/// before that date". The repository exposes both without the caller ever writing
/// a date comparison. No implementation here — this task forbids CRUD.
abstract interface class ExchangeRateRepository {
  /// The rate in force for a pair as of [asOf] (default: now) — the newest row on
  /// or before that instant, or null if the pair has never been recorded.
  Future<ExchangeRate?> rateFor({
    required String fromCurrencyId,
    required String toCurrencyId,
    DateTime? asOf,
  });

  /// Every recorded rate for a pair, newest first — the full history, for a chart
  /// or an audit.
  Stream<List<ExchangeRate>> watchHistory({
    required String fromCurrencyId,
    required String toCurrencyId,
  });

  /// Records a rate. Rates are only ever inserted, never updated in place: a
  /// "correction" is a newer row, so the record of what was believed when stays
  /// intact.
  Future<String> add(ExchangeRatesCompanion rate);
}
