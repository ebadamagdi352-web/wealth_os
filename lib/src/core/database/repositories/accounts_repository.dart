import 'package:wealth_os/src/core/database/app_database.dart';
import 'package:wealth_os/src/core/database/dao/accounts_dao.dart';

/// Repository over the accounts table.
///
/// It wraps [AccountsDao] and delegates to it — nothing more. Every method here is
/// a one-line forward to a DAO method; there is no filtering, no ordering, no
/// validation, no mapping. That is deliberate for this step: the repository exists
/// so the layers above depend on *it* rather than on Drift, giving one seam to
/// evolve later, but at this point that seam is a straight passthrough.
///
/// It reaches the database **only through the DAO** — it never selects, inserts, or
/// touches a Drift table itself. The DAO owns the SQL; the repository owns the
/// dependency direction.
///
/// ## Where this grows
///
/// Under strict Clean Architecture a repository would eventually return *domain
/// entities* rather than Drift's generated `Account` rows, mapping between the two
/// at this boundary — that is the point of having the seam. This task's rule is
/// "delegate only, no business logic", so the Drift types pass straight through for
/// now; the mapping is added the day a domain model exists, without any caller
/// above needing to change which class they depend on.
class AccountsRepository {
  AccountsRepository(this._dao);

  final AccountsDao _dao;

  /// Watches every account, active and archived alike.
  Stream<List<Account>> watchAccounts() => _dao.watchAllAccounts();

  /// Watches only the archived accounts.
  Stream<List<Account>> watchArchivedAccounts() =>
      _dao.watchArchivedAccounts();

  /// The account with [id], or null.
  Future<Account?> getAccountById(String id) => _dao.getAccountById(id);

  /// Inserts [account]; returns the DAO's result (the inserted row's rowid).
  Future<int> createAccount(AccountsCompanion account) =>
      _dao.insertAccount(account);

  /// Replaces the row identified by [account]'s primary key; returns whether one
  /// matched.
  Future<bool> updateAccount(AccountsCompanion account) =>
      _dao.updateAccount(account);

  /// Hard-deletes the account with [id]; returns the number of rows removed.
  Future<int> deleteAccount(String id) => _dao.deleteAccount(id);
}
