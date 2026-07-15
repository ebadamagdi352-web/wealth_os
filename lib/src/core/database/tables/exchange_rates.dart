import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';

/// A directional exchange rate, valid from a point in time.
///
/// ## Rates are historical facts, not current settings
///
/// Each row is `1 [fromCurrency] = rate [toCurrency]`, true **as of**
/// [effectiveDate]. The table keeps every rate ever recorded rather than a single
/// mutable "current rate", because a transaction made last year must be valued at
/// last year's rate forever — re-valuing history every time today's rate moves
/// would make last year's spending totals drift daily. The latest rate is just the
/// row with the newest `effectiveDate`; the old ones are not stale, they are the
/// record.
///
/// ## ⚠️ `id` is not in the brief's field list — I added it
///
/// The brief specified `fromCurrency`, `toCurrency`, `rate`, `effectiveDate` and no
/// id. A surrogate UUID id is added anyway, for consistency with every other table
/// and because Drift's tooling is happiest with a single-column primary key. The
/// natural key — the triple of from/to/date — is enforced as a unique constraint
/// instead, so the surrogate id buys convenience without weakening the real
/// uniqueness rule. Remove `id` and make the triple the primary key if you prefer;
/// it is a small change. See TASK_019_REPORT.md.
@DataClassName('ExchangeRate')
class ExchangeRates extends Table {
  TextColumn get id => text()();

  /// The base of the quote. **Renamed** from the brief's `fromCurrency` to
  /// `fromCurrencyId` so every foreign key in the schema reads the same way — it
  /// holds a currency *id*, not a currency. Consistency with `Account.currencyId`
  /// et al.
  TextColumn get fromCurrencyId => text().references(Currencies, #id)();

  /// The quote counter-currency. Renamed from `toCurrency`, same reasoning.
  TextColumn get toCurrencyId => text().references(Currencies, #id)();

  /// Fixed-point: the real rate times `kFixedPointScale` (1e8). `30.85` is stored
  /// as `3_085_000_000`. See `database_constants.dart` for why rates are integers.
  IntColumn get rate => integer()();

  /// When this rate became effective. The newest row for a currency pair is the one
  /// in force.
  DateTimeColumn get effectiveDate => dateTime()();

  @override
  Set<Column> get primaryKey => <Column>{id};

  /// One rate per pair per instant. Snake_case column names because that is what
  /// Drift emits.
  @override
  List<String> get customConstraints => <String>[
        'UNIQUE (from_currency_id, to_currency_id, effective_date)',
      ];
}
