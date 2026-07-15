import 'package:wealth_os/src/core/database/app_database.dart';

/// Persistence contract for transactions. Interface only — no CRUD in this task.
///
/// The read methods are shaped by how transactions are actually looked at — by
/// account, by date range — because those are the queries the indexes in
/// `AppDatabase` exist to serve. A `watchAll()` with no bound is deliberately
/// absent: a mature ledger has tens of thousands of rows, and any real screen pages
/// or filters them.
abstract interface class TransactionRepository {
  /// The transactions on one account, newest first, live.
  Stream<List<TransactionEntry>> watchByAccount(String accountId);

  /// The transactions within a date range, live — what a monthly view or a report
  /// asks for. The range is half-open `[from, to)` by convention; the
  /// implementation documents and honours it.
  Stream<List<TransactionEntry>> watchByDateRange({
    required DateTime from,
    required DateTime to,
  });

  /// One transaction by id, or null.
  Future<TransactionEntry?> findById(String id);

  /// Records a transaction, returning its id.
  ///
  /// ⚠️ A real implementation of this does **not** just insert one row. It must, in
  /// a single database transaction, also move the affected account balance(s) — and
  /// for a transfer, both the source and the [TransactionEntry.transferAccountId]
  /// destination. That atomic "write the movement *and* update the balance" is the
  /// invariant that keeps `Account.currentBalance` honest. The contract names the
  /// operation; the atomicity is the implementation's obligation. See
  /// TASK_019_REPORT.md.
  Future<String> create(TransactionsCompanion transaction);

  /// Applies the set fields of [transaction] to the matching row. Editing an amount
  /// carries the same balance-adjustment obligation as [create].
  Future<bool> update(TransactionsCompanion transaction);

  /// Removes a transaction — which must also reverse its effect on the account
  /// balance, atomically, or the running total silently rots.
  Future<void> delete(String id);
}
