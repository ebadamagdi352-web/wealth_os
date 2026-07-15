import 'package:wealth_os/src/core/database/app_database.dart';

/// Persistence contract for accounts. Interface only — no CRUD in this task.
abstract interface class AccountRepository {
  /// Live list of accounts. [includeArchived] defaults to false, so the common
  /// case — "the accounts I actually use" — is the default, and seeing archived
  /// ones is the deliberate ask.
  Stream<List<Account>> watchAll({bool includeArchived});

  /// One account by id, or null.
  Future<Account?> findById(String id);

  /// Inserts an account, returning its id.
  Future<String> create(AccountsCompanion account);

  /// Applies the set fields of [account] to the matching row. Returns whether one
  /// matched.
  Future<bool> update(AccountsCompanion account);

  /// Soft delete — flips `isArchived`. Never a hard delete: an account's
  /// transactions must keep something to point at.
  Future<void> archive(String id);
}
