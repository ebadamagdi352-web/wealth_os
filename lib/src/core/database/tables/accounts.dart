import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';

/// The kind of account.
///
/// Defined here, in the table file that uses it, because the schema has no shared
/// enums file yet and this is the first enum to need a home — co-locating it with
/// its only consumer keeps it findable without inventing a folder. If a second
/// table ever needs its own enum, a shared `tables/enums.dart` is the moment to
/// introduce.
///
/// ⚠️ **APPEND-ONLY.** Stored by its integer index (Drift's `intEnum`), so the
/// database holds `0`, `1`, `2`, not `cash`, `bank`. Reordering or deleting a value
/// silently reassigns every stored row — only ever add new values at the **end**.
enum AccountType {
  cash,
  bank,
  creditCard,
  wallet,
  investment,
  loan,
  other,
}

/// A place money sits: a bank account, a wallet, a credit card, a loan.
///
/// The `type` distinguishes them; the *balance semantics* that differ between them
/// (a credit card's used-vs-limit, a loan's owed amount) are a concern for whatever
/// reads [AccountType] later, not for storage — every account stores the same two
/// integer balances regardless of kind.
@DataClassName('Account')
class Accounts extends Table {
  /// Client-generated UUID string, matching the id convention set by `Currencies`.
  TextColumn get id => text()();

  /// The user's own label for the account. Their words — never translated.
  TextColumn get name => text()();

  /// The account kind, stored as [AccountType]'s index. See the append-only warning
  /// on the enum.
  IntColumn get type => intEnum<AccountType>()();

  /// The currency this account is denominated in. **References `Currencies.id`.**
  /// Fixes the scale of both balances.
  TextColumn get currencyId => text().references(Currencies, #id)();

  /// The balance when the account was first added — the fixed starting point every
  /// later balance is derived from. Integer minor units of [currencyId].
  IntColumn get openingBalance => integer().withDefault(const Constant(0))();

  /// The balance now. Integer minor units of [currencyId].
  ///
  /// A stored cache of a derivable fact (`openingBalance + sum of this account's
  /// transactions`), kept because summing every transaction on every read does not
  /// scale. The invariant that keeps it honest — write it only inside the same
  /// database transaction that writes a movement — is repository work for a later
  /// task; this column is storage only.
  IntColumn get currentBalance => integer().withDefault(const Constant(0))();

  /// Soft delete. Accounts are archived, never removed, so their transactions keep
  /// something to point at.
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

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
