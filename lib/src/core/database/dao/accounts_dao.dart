import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/app_database.dart';
import 'package:wealth_os/src/core/database/tables/accounts.dart';

part 'accounts_dao.g.dart';

/// Data access for the `accounts` table.
///
/// A DAO is the thinnest possible layer over Drift: each method is one generated
/// query and nothing else — no filtering policy, no validation, no derived values.
/// Decisions like "which accounts count as active", "in what order", and "archive
/// versus hard-delete" belong to the repository that will sit above this, not here.
/// That separation is the point of the DAO: it exposes the table's raw verbs so the
/// layer above can compose them without touching SQL.
///
/// `@DriftAccessor` generates the `_$AccountsDaoMixin` (in `accounts_dao.g.dart`),
/// which supplies the typed `accounts` accessor and query builders used below.
@DriftAccessor(tables: <Type>[Accounts])
class AccountsDao extends DatabaseAccessor<AppDatabase>
    with _$AccountsDaoMixin {
  AccountsDao(super.db);

  /// Watches every account — active and archived alike — emitting a new list on any
  /// change. "All" is literal here; [watchArchivedAccounts] narrows to the archived
  /// subset, and a repository can derive the active set from these.
  Stream<List<Account>> watchAllAccounts() => select(accounts).watch();

  /// The account with [id], or null if there is none.
  Future<Account?> getAccountById(String id) =>
      (select(accounts)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Inserts [account]. Returns the inserted row's rowid; the caller supplies the
  /// text `id`. Throws on a primary-key conflict, as a plain insert should.
  Future<int> insertAccount(AccountsCompanion account) =>
      into(accounts).insert(account);

  /// Replaces the row identified by [account]'s primary key with its values. The
  /// companion must carry the `id`. Returns whether a row matched.
  Future<bool> updateAccount(AccountsCompanion account) =>
      update(accounts).replace(account);

  /// Hard-deletes the account with [id], returning the number of rows removed.
  /// Archiving (the soft delete) is a repository policy expressed as an
  /// [updateAccount] that sets `isArchived`; this is the raw removal.
  Future<int> deleteAccount(String id) =>
      (delete(accounts)..where((t) => t.id.equals(id))).go();

  /// Watches only the archived accounts, emitting on any change.
  Stream<List<Account>> watchArchivedAccounts() =>
      (select(accounts)..where((t) => t.isArchived.equals(true))).watch();
}
