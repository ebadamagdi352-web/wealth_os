import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';
import 'package:wealth_os/src/core/database/tables/enums.dart';

/// A place money sits: a bank account, a wallet, a credit card.
///
/// ## Why every id in this schema is a text UUID
///
/// This table sets the convention the whole database follows, so the reasoning
/// lives here. Ids are **client-generated UUID strings**, not autoincrementing
/// integers, for three reasons that all point the same way:
///
/// * **Offline-first.** A row needs an id the instant it is created on the device,
///   before any server or even any successful write has assigned one. Autoincrement
///   hands out ids at insert time; a UUID exists the moment `Uuid().v4()` returns.
/// * **Sync without collisions.** Two phones both using autoincrement will both
///   mint account `1`, and merging them is a nightmare of id rewriting. Two UUIDs
///   never collide, so a future sync layer can merge devices by copying rows.
/// * **It matches the app that already exists.** Every feature built in Sprints 1–2
///   already uses string ids (`'acc_main_bank'`); the `uuid` package has been a
///   dependency since Task 002 for exactly this.
///
/// The cost is larger, slightly slower indexes than 8-byte integers. For a personal
/// finance app's data volumes that is nothing; the sync-safety is worth far more.
@DataClassName('Account')
class Accounts extends Table {
  TextColumn get id => text()();

  /// The user's own label. Their words — never translated.
  TextColumn get name => text()();

  /// Stored as the enum's index. See the append-only warning in `enums.dart`.
  IntColumn get type => intEnum<AccountType>()();

  /// The currency this account is denominated in. Fixes the scale of
  /// [openingBalance] and [currentBalance].
  TextColumn get currencyId => text().references(Currencies, #id)();

  /// The balance when the account was first added — the starting point every later
  /// balance is derived from. Integer minor units of [currencyId].
  IntColumn get openingBalance => integer().withDefault(const Constant(0))();

  /// The balance now. Integer minor units of [currencyId].
  ///
  /// ⚠️ **A stored cache of a derivable fact.** The honest value is
  /// `openingBalance + sum(transactions on this account)`. It is stored anyway
  /// because recomputing it by summing every transaction on every read does not
  /// scale, and a running balance is read constantly. The rule that keeps a cache
  /// honest: it is only ever written by the same operation that writes a
  /// transaction, inside one database transaction, so the two can never disagree.
  /// That write is repository work, deferred — this task defines the column, not
  /// the invariant that maintains it. Flagged in TASK_019_REPORT.md.
  IntColumn get currentBalance => integer().withDefault(const Constant(0))();

  /// Soft delete. Accounts are **archived, never removed** — deleting one would
  /// orphan its transactions, and "where did that money go?" is the one question a
  /// finance app must always be able to answer.
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
