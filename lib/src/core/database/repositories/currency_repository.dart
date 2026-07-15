import 'package:wealth_os/src/core/database/app_database.dart';

/// Persistence contract for currencies.
///
/// An interface, not an implementation — the whole point of a repository is that
/// the code above it never learns whether currencies come from Drift, a network,
/// or a test double. Every method here is a promise; the Drift implementation that
/// keeps those promises is a later task (this one forbids CRUD).
///
/// The types it traffics in — [Currency], [CurrenciesCompanion] — are Drift's
/// generated row and write classes. That the *data-layer* repository speaks the
/// data layer's types is fine; the note in TASK_019_REPORT.md explains how these
/// interfaces move to a domain layer, retyped to domain entities, if and when one
/// is introduced.
abstract interface class CurrencyRepository {
  /// Every currency, updating live as the table changes.
  Stream<List<Currency>> watchAll();

  /// Only the currencies offered in pickers (`isActive`).
  Stream<List<Currency>> watchActive();

  /// One currency by id, or null if there is none.
  Future<Currency?> findById(String id);

  /// One currency by ISO code ('USD'), or null. The code is unique, so at most one.
  Future<Currency?> findByCode(String code);

  /// The single base/reporting currency, or null if none is set yet.
  Future<Currency?> findBaseCurrency();

  /// Inserts a currency, returning its id.
  Future<String> create(CurrenciesCompanion currency);

  /// Applies the set fields of [currency] to the row with its id. Returns whether a
  /// row matched.
  Future<bool> update(CurrenciesCompanion currency);

  /// Flips `isActive` to false. Currencies are deactivated, never deleted, so
  /// historical amounts keep a currency to point at.
  Future<void> deactivate(String id);
}
