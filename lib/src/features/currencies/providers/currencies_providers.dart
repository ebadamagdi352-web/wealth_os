import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth_os/src/core/database/app_database.dart';
import 'package:wealth_os/src/core/database/dao/currencies_dao.dart';
import 'package:wealth_os/src/core/database/repositories/currencies_repository.dart';
import 'package:wealth_os/src/features/accounts/providers/accounts_providers.dart';

/// The Riverpod wiring for currencies.
///
/// Mirrors the accounts provider chain exactly. Nothing here filters, sorts,
/// validates, or transforms — each provider only hands the next one down the chain
/// the object it needs. The chain is:
///
///   appDatabaseProvider → currenciesDaoProvider → currenciesRepositoryProvider
///   → currenciesStreamProvider / activeCurrenciesProvider / baseCurrencyProvider
///
/// Only classic `Provider` / `StreamProvider` / `FutureProvider` are used — no
/// notifier of any kind, matching the accounts chain.
///
/// ## Reuses `appDatabaseProvider` from the accounts feature
///
/// The database root lives in `accounts_providers.dart`, so this file imports it —
/// a temporary currencies → accounts coupling, accepted for this task and left
/// un-refactored per its scope. The root's proper home is a shared `core` providers
/// location; when it moves there, every provider below keeps working, because they
/// depend on its *name*, not its location.

/// Exposes the generated [CurrenciesDao] from the database.
///
/// Uses the `currenciesDao` accessor Drift generates from the `daos:` registration,
/// so the DAO shares the one database connection rather than opening another.
final Provider<CurrenciesDao> currenciesDaoProvider =
    Provider<CurrenciesDao>((ref) {
  return ref.watch(appDatabaseProvider).currenciesDao;
});

/// Exposes the [CurrenciesRepository], built over the DAO above.
final Provider<CurrenciesRepository> currenciesRepositoryProvider =
    Provider<CurrenciesRepository>((ref) {
  return CurrenciesRepository(ref.watch(currenciesDaoProvider));
});

/// Streams every currency, straight from
/// [CurrenciesRepository.watchAllCurrencies]. No filtering — the repository decides
/// that.
final StreamProvider<List<Currency>> currenciesStreamProvider =
    StreamProvider<List<Currency>>((ref) {
  return ref.watch(currenciesRepositoryProvider).watchAllCurrencies();
});

/// Streams the active currencies, from
/// [CurrenciesRepository.watchActiveCurrencies] — the natural source for a picker.
final StreamProvider<List<Currency>> activeCurrenciesProvider =
    StreamProvider<List<Currency>>((ref) {
  return ref.watch(currenciesRepositoryProvider).watchActiveCurrencies();
});

/// The base currency, from [CurrenciesRepository.getBaseCurrency].
///
/// A `FutureProvider`, not a `StreamProvider`, because the repository returns a
/// one-shot `Future<Currency?>` here — the only shape difference from the accounts
/// chain, forced by the method's return type. Still a classic provider; still no
/// notifier.
final FutureProvider<Currency?> baseCurrencyProvider =
    FutureProvider<Currency?>((ref) {
  return ref.watch(currenciesRepositoryProvider).getBaseCurrency();
});
