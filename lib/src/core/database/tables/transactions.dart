import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/enums.dart';
import 'package:wealth_os/src/core/database/tables/accounts.dart';
import 'package:wealth_os/src/core/database/tables/categories.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';

/// A single movement of money — the ledger's atom.
///
/// ## The data class is `TransactionEntry`, not `Transaction`
///
/// Drift already owns the name `Transaction` (its type for a database transaction,
/// the `db.transaction(() {...})` unit of work). Naming this row `Transaction` would
/// put two very different `Transaction`s in scope in any code that touches both, so
/// `@DataClassName` renames the row to [TransactionEntry].
///
/// ## Amount and rate are stored raw, never pre-converted
///
/// [amount] is kept in the transaction's **own** currency, exactly as it happened —
/// never converted to the base currency before storage. [exchangeRate] records the
/// rate that was true **at [transactionDate]**, so a report can convert this
/// movement using the rate of its own moment. Convert-then-store would fossilise
/// today's rate into last year's spending and make historical totals shift every
/// time the rate moves; storing raw keeps history true.
@DataClassName('TransactionEntry')
class Transactions extends Table {
  /// Client-generated UUID string, matching the established id convention.
  TextColumn get id => text()();

  /// The account this movement belongs to. **References `Accounts.id`.**
  TextColumn get accountId => text().references(Accounts, #id)();

  /// The category, or null. **References `Categories.id`.** Nullable on purpose: a
  /// transfer between the user's own accounts, or a balance adjustment, is neither
  /// spending nor income and often has no category — forcing one would pollute every
  /// "spending by category" report with internal movements.
  TextColumn get categoryId =>
      text().nullable().references(Categories, #id)();

  /// The currency [amount] is expressed in. **References `Currencies.id`.** Usually
  /// the account's currency, stored explicitly so a foreign-currency movement is
  /// representable without lying about which currency the number is in.
  TextColumn get currencyId => text().references(Currencies, #id)();

  /// The magnitude, in integer minor units of [currencyId], stored **without
  /// conversion**. Direction (does it add to or subtract from the account) is carried
  /// by [type]; a repository may equally adopt a signed convention, but that choice
  /// is made once, above this column.
  IntColumn get amount => integer()();

  /// The rate used to value [amount] in the base currency, as of [transactionDate].
  /// Fixed-point, `real rate × 1e8` (`kFixedPointScale`). Nullable — null when the
  /// movement is already in the base currency and no conversion applied.
  IntColumn get exchangeRate => integer().nullable()();

  /// When the movement happened — the user's stated date, which may differ from when
  /// the row was written (see [createdAt]).
  DateTimeColumn get transactionDate => dateTime()();

  /// Free text. Nullable; an empty note and no note are the same state.
  TextColumn get notes => text().nullable()();

  /// An external reference — a cheque number, a receipt id, a bank reference.
  /// Nullable.
  TextColumn get reference => text().nullable()();

  /// Income, expense, transfer, investment, or adjustment. Stored as
  /// [TransactionType]'s index — see the append-only warning on the enum.
  IntColumn get type => intEnum<TransactionType>()();

  /// Row creation time, defaulted to the database clock at insert.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Last-change time, defaulted at insert; kept current on updates is a write-side
  /// concern for a later task.
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
