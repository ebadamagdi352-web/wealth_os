import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/app_database.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';

part 'currencies_dao.g.dart';

/// Data access for the `currencies` table.
///
/// A DAO is the thinnest possible layer over Drift: each method is one generated
/// query and nothing else — no filtering policy, no ordering, no derived values.
/// Decisions above that belong to the repository that will sit on top, not here.
///
/// **Read-only.** The table's only writer is the seed (Task 020E-B1); nothing else
/// creates, edits, or removes a currency yet, so this DAO exposes only reads.
///
/// `@DriftAccessor` generates the `_$CurrenciesDaoMixin` (in `currencies_dao.g.dart`),
/// which supplies the typed `currencies` accessor and query builders used below.
@DriftAccessor(tables: <Type>[Currencies])
class CurrenciesDao extends DatabaseAccessor<AppDatabase>
    with _$CurrenciesDaoMixin {
  CurrenciesDao(super.db);

  /// Watches every currency — active and inactive alike — emitting a new list on any
  /// change. "All" is literal here; [watchActiveCurrencies] narrows to the active
  /// subset.
  Stream<List<Currency>> watchAllCurrencies() => select(currencies).watch();

  /// Watches only the active currencies, emitting on any change — the natural source
  /// for a picker.
  Stream<List<Currency>> watchActiveCurrencies() =>
      (select(currencies)..where((t) => t.isActive.equals(true))).watch();

  /// The currency with [id], or null if there is none.
  Future<Currency?> getCurrencyById(String id) =>
      (select(currencies)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// The base currency, or null if none is marked. Returns a single row — the seed
  /// guarantees exactly one `isBaseCurrency = true`, so more than one would be a data
  /// error worth surfacing rather than hiding.
  Future<Currency?> getBaseCurrency() =>
      (select(currencies)..where((t) => t.isBaseCurrency.equals(true)))
          .getSingleOrNull();
}
