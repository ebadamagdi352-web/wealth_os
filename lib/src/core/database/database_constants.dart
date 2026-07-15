/// Constants and storage conventions for the Drift data layer.
library;

/// The SQLite file's name. Lives under the app's documents directory; see
/// `app_database.dart` for where that is resolved.
const String kDatabaseFileName = 'wealth_os.sqlite';

/// The fixed-point multiplier for future rate and quantity columns.
///
/// Not used by the currencies table — no rates or quantities exist yet — but the
/// convention is established here so it is decided once. When exchange rates and
/// asset quantities arrive, they are stored as `value * kFixedPointScale` in an
/// integer column, never as a floating-point number, because `0.1 + 0.2 != 0.3` in
/// IEEE-754 and a ledger cannot afford that. `1e8` gives eight decimal places.
///
/// Monetary *amounts*, when they arrive, follow a related rule: integer minor units
/// of their own currency, scaled by `10 ^ currency.decimalDigits` — which is why
/// `Currencies.decimalDigits` exists.
const int kFixedPointScale = 100000000; // 1e8
