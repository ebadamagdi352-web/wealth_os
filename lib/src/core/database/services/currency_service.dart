import 'package:wealth_os/src/core/database/app_database.dart';

/// The application-level contract for working with currencies and the money stored
/// against them.
///
/// A **service**, not a repository: a repository moves rows in and out of storage,
/// while a service performs the operations the rest of the app thinks in — "what is
/// the base currency", "turn these minor units into a string a person can read",
/// "turn what a person typed into minor units". Those cross a repository and a
/// formatting rule; that combination is what a service is for.
///
/// Interface only. Every method is a promise whose implementation — which is where
/// the actual formatting and rounding live — is a later task. This one forbids
/// business logic, and a signature is not logic.
abstract interface class CurrencyService {
  /// The single reporting currency. Throws, or returns null by an implementation's
  /// documented choice, if none is configured — a state the app should not reach
  /// past first-run setup.
  Future<Currency?> baseCurrency();

  /// The currencies offered in pickers, ready to display.
  Future<List<Currency>> activeCurrencies();

  /// Formats an integer minor-unit amount into a display string for [currency],
  /// applying its `decimalDigits` and `symbol` — e.g. `15000` in EGP becomes
  /// "150.00 ج.م". The inverse of [parseToMinorUnits].
  ///
  /// Synchronous because it is a pure function of its arguments; it touches no
  /// storage. The rounding and grouping rules it must follow are the implementation's
  /// to define and test.
  String formatMinorUnits(int minorUnits, Currency currency);

  /// Parses user input ("150.5") into integer minor units of [currency], honouring
  /// its `decimalDigits`. The inverse of [formatMinorUnits]. Throws on input that
  /// is not a number; enforcing *limits* on the value is not this method's job.
  int parseToMinorUnits(String input, Currency currency);

  /// Converts minor units to major units as a `double`, **for display arithmetic
  /// only** — never for storage, where the integer is the source of truth. Exists so
  /// a chart axis or a percentage can work in familiar units without re-deriving the
  /// scale each time.
  double toMajorUnits(int minorUnits, Currency currency);
}
