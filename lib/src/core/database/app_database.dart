import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wealth_os/src/core/database/database_constants.dart';
import 'package:wealth_os/src/core/database/tables/accounts.dart';
import 'package:wealth_os/src/core/database/tables/categories.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';
import 'package:wealth_os/src/core/database/tables/exchange_rates.dart';
import 'package:wealth_os/src/core/database/tables/transactions.dart';

// ⚠️ GENERATED FILE — created by code generation, not by hand.
//
// `flutter analyze` reports this missing until you run, from the project root:
//
//   dart run build_runner build --delete-conflicting-outputs
//
// That is normal for every Drift database. The command, and the full gate
// sequence, are in TASK_019A_REPORT.md.
part 'app_database.g.dart';

/// The application's Drift database.
///
/// One responsibility: own the schema and hand out a live connection to it. It
/// registers the tables, sets the schema version, and opens a SQLite file in the
/// app's documents directory. Repositories, services, and providers are all
/// deliberately absent — this layer is schema only.
@DriftDatabase(
  tables: <Type>[Currencies, ExchangeRates, Accounts, Categories, Transactions],
)
class AppDatabase extends _$AppDatabase {
  /// Opens (lazily) the on-device SQLite database.
  AppDatabase() : super(_openConnection());

  /// Bumped by one for every shipped schema change, each paired with an `onUpgrade`
  /// step. Now 5 — v1 currencies, v2 exchange_rates, v3 accounts, v4 categories,
  /// v5 transactions.
  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          // A fresh install: creates every registered table, with their columns and
          // constraints, then the secondary indexes. Never runs onUpgrade.
          await m.createAll();
          await _createIndexes();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Stepped: each guarded block adds exactly the table its version
          // introduced, so a database at any older version catches up by running
          // every step above it, in order.
          if (from < 2) {
            await m.createTable(exchangeRates);
          }
          if (from < 3) {
            await m.createTable(accounts);
          }
          if (from < 4) {
            await m.createTable(categories);
          }
          if (from < 5) {
            await m.createTable(transactions);
          }
          // By here every table up to the current version exists, so the secondary
          // indexes can be declared idempotently in one place, shared with onCreate.
          await _createIndexes();
        },
        beforeOpen: (OpeningDetails details) async {
          // Now load-bearing: exchange_rates has two foreign keys into currencies,
          // and SQLite ignores foreign keys unless asked, per connection. Without
          // this, a rate could reference a currency that does not exist and the
          // database would say nothing.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// The secondary (non-constraint) indexes, declared once and created idempotently
  /// so the fresh-install and upgrade paths cannot drift apart. `createAll` and
  /// `createTable` build tables and their unique constraints, but not these — each
  /// backs a foreign key or a hot query column that would otherwise force a scan.
  Future<void> _createIndexes() async {
    // Category tree: the parent pointer every traversal walks.
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_category_parent '
      'ON categories (parent_id)',
    );
    // Transactions: the three columns the ledger is queried and sorted by.
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_txn_account '
      'ON transactions (account_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_txn_category '
      'ON transactions (category_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_txn_date '
      'ON transactions (transaction_date)',
    );
  }
}

/// Builds the executor without opening it until first use.
///
/// [LazyDatabase] defers the async directory lookup so the constructor can stay
/// synchronous. `createInBackground` runs SQLite on its own isolate, keeping heavy
/// queries off the UI thread — the native binaries come from `sqlite3_flutter_libs`,
/// the file location from `path_provider`, and the path is joined with `path`.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory documents = await getApplicationDocumentsDirectory();
    final File file = File(p.join(documents.path, kDatabaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}
