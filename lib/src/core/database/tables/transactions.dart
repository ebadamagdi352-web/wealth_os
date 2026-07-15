import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/accounts.dart';
import 'package:wealth_os/src/core/database/tables/categories.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';
import 'package:wealth_os/src/core/database/tables/enums.dart';

/// A single movement of money.
///
/// ## The data class is `TransactionEntry`, not `Transaction`
///
/// Drift already has a `Transaction` — its type for a database transaction (the
/// `db.transaction(() {...})` unit of work). Naming this row class `Transaction`
/// would put two very different `Transaction`s in scope wherever repository code
/// touches both, and the resulting import shadowing is a genuine trap. `@DataClassName`
/// renames the row to [TransactionEntry] so the two never collide.
@DataClassName('TransactionEntry')
class Transactions extends Table {
  /// Client-generated UUID. See `Accounts` for the id convention.
  TextColumn get id => text()();

  /// The account the money moves out of, or into. For a transfer this is the
  /// **source**; see [transferAccountId] for the other side.
  TextColumn get accountId => text().references(Accounts, #id)();

  /// The category, or null. **Nullable**: a transfer between a user's own accounts
  /// is not spending or income and often has no category, and forcing one would
  /// pollute every "spending by category" report with internal money shuffling.
  TextColumn get categoryId =>
      text().nullable().references(Categories, #id)();

  /// The currency of [amount]. Usually the account's currency, but stored
  /// explicitly so a foreign-currency transaction on a local account is
  /// representable without lying about which currency the number is in.
  TextColumn get currencyId => text().references(Currencies, #id)();

  /// The magnitude, in integer minor units of [currencyId].
  ///
  /// Whether it adds to or subtracts from the account is carried by [type], not by
  /// a sign here — an expense and an income of "the same amount" store the same
  /// positive integer, and the type says which direction. (An implementation may
  /// equally choose signed amounts; that is a repository convention, and it must be
  /// chosen once and documented. The column permits either.)
  IntColumn get amount => integer()();

  /// The rate used to convert [amount] into the base currency **at the time of the
  /// transaction**. Fixed-point, scaled by `kFixedPointScale` (1e8).
  ///
  /// Nullable — null when [currencyId] already is the base currency, so no
  /// conversion applies. Capturing the rate *here*, on the row, is what stops last
  /// year's transactions from being silently re-valued every time today's rate
  /// moves: the historical rate is a fact of the transaction, not a lookup done
  /// fresh on every read.
  IntColumn get exchangeRate => integer().nullable()();

  /// When the movement happened — the user's stated date, which may not be when the
  /// row was written.
  DateTimeColumn get date => dateTime()();

  /// Free text. Nullable; an empty note and no note are the same state.
  TextColumn get notes => text().nullable()();

  /// Income, expense, or transfer. Stored as the enum index — see the append-only
  /// warning in `enums.dart`.
  IntColumn get type => intEnum<TransactionType>()();

  /// ⚠️ **Not in the brief's field list — added to close the double-entry gap.**
  ///
  /// The brief's `Transaction` has a single `accountId`, which cannot express a
  /// transfer: "moved 5,000 out of Main Bank" never says where it landed, and the
  /// money vanishes from the ledger. This is precisely the gap flagged in
  /// TASK_015_REPORT.md §6 and TASK_016 §4, and the data-layer task is where it is
  /// finally addressable.
  ///
  /// This nullable second account is the **minimal** fix: for a transfer, it is the
  /// destination; for income and expense it is null. Deleting this one column
  /// returns the table to exactly the brief's fields.
  ///
  /// The *rigorous* fix is a separate postings/ledger table where each transaction
  /// has two or more signed legs — the classic double-entry model. That is a larger
  /// structural change than the brief's single-table shape, so it is written up as
  /// the recommended evolution in TASK_019_REPORT.md rather than imposed here.
  TextColumn get transferAccountId =>
      text().nullable().references(Accounts, #id)();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
