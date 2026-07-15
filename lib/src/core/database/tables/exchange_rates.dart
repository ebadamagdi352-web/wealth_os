import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';

/// A directional exchange rate, valid from a point in time.
///
/// Each row states `1 [fromCurrencyId] = rate [toCurrencyId]`, true as of
/// [effectiveDate]. The table keeps every rate ever recorded rather than one mutable
/// "current" rate: a transaction made last year must stay valued at last year's rate
/// forever, so history is never overwritten — a correction is a newer row, and "the
/// current rate" is simply the newest row for a pair.
@DataClassName('ExchangeRate')
class ExchangeRates extends Table {
  /// Client-generated UUID string, matching the id convention set by `Currencies`.
  TextColumn get id => text()();

  /// The base of the quote. **References `Currencies.id`.** Named with the `Id`
  /// suffix so every foreign key in the schema reads the same way — it holds a
  /// currency id, not a currency.
  TextColumn get fromCurrencyId => text().references(Currencies, #id)();

  /// The counter-currency of the quote. **References `Currencies.id`.**
  TextColumn get toCurrencyId => text().references(Currencies, #id)();

  /// Fixed-point: the real rate times `kFixedPointScale` (1e8), stored as an
  /// integer. `30.85` is `3_085_000_000`. A rate is never a floating-point number —
  /// see `database_constants.dart` for why.
  IntColumn get rate => integer()();

  /// The instant this rate took effect. The newest row for a pair is the one in
  /// force.
  DateTimeColumn get effectiveDate => dateTime()();

  /// Row creation time, defaulted to the database clock at insert.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Last-change time, defaulted at insert; kept current on updates is a write-side
  /// concern for a later task.
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => <Column>{id};

  /// One rate per currency pair per instant. The unique index SQLite builds for this
  /// constraint also serves the "latest rate for this pair" lookup, since
  /// `from_currency_id` is its leftmost column. Snake_case names because that is what
  /// Drift emits.
  @override
  List<String> get customConstraints => <String>[
        'UNIQUE (from_currency_id, to_currency_id, effective_date)',
      ];
}
