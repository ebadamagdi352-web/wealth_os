import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth_os/src/core/database/app_database.dart';
import 'package:wealth_os/src/core/database/dao/accounts_dao.dart';
import 'package:wealth_os/src/core/database/repositories/accounts_repository.dart';

/// The Riverpod wiring for the accounts feature.
///
/// Nothing here filters, sorts, validates, or transforms — each provider only
/// hands the next one down the chain the object it needs. The chain is:
///
///   appDatabaseProvider → accountsDaoProvider → accountsRepositoryProvider
///   → accountsStreamProvider / archivedAccountsStreamProvider
///
/// Only classic `Provider` and `StreamProvider` are used — no notifier of any kind.

/// The single [AppDatabase] instance for the app.
///
/// ⚠️ **Not in the task's list of four, but the root they all require.** An
/// `AccountsDao` cannot exist without an `AppDatabase`, and the project has no
/// database provider yet, so the chain needs a root. It lives here for now because
/// this file is the only one this task may create; when a second feature needs the
/// database it should move to a shared `core` providers location — every provider
/// below would keep working, since they depend on the *name*, not the location.
///
/// It is kept alive (a plain `Provider`) and closes the database when the provider
/// is disposed, so the SQLite connection has one owner and a clean shutdown.
final Provider<AppDatabase> appDatabaseProvider = Provider<AppDatabase>((ref) {
  final AppDatabase database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

/// Exposes the generated [AccountsDao] from the database.
///
/// Uses the `accountsDao` accessor Drift generates from the `daos:` registration,
/// so the DAO shares the one database connection rather than opening another.
final Provider<AccountsDao> accountsDaoProvider = Provider<AccountsDao>((ref) {
  return ref.watch(appDatabaseProvider).accountsDao;
});

/// Exposes the [AccountsRepository], built over the DAO above.
final Provider<AccountsRepository> accountsRepositoryProvider =
    Provider<AccountsRepository>((ref) {
  return AccountsRepository(ref.watch(accountsDaoProvider));
});

/// Streams every account (active and archived), straight from
/// [AccountsRepository.watchAccounts]. No filtering or sorting — a consumer or a
/// later provider decides those.
final StreamProvider<List<Account>> accountsStreamProvider =
    StreamProvider<List<Account>>((ref) {
  return ref.watch(accountsRepositoryProvider).watchAccounts();
});

/// Streams the archived accounts, from
/// [AccountsRepository.watchArchivedAccounts].
final StreamProvider<List<Account>> archivedAccountsStreamProvider =
    StreamProvider<List<Account>>((ref) {
  return ref.watch(accountsRepositoryProvider).watchArchivedAccounts();
});
