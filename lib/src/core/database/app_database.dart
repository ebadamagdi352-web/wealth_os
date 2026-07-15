import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wealth_os/src/core/database/database_constants.dart';
import 'package:wealth_os/src/core/database/tables/accounts.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';
import 'package:wealth_os/src/core/database/tables/exchange_rates.dart';

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
@DriftDatabase(tables: <Type>[Currencies, ExchangeRates, Accounts])
class AppDatabase extends _$AppDatabase {
  /// Opens (lazily) the on-device SQLite database.
  AppDatabase() : super(_openConnection());

  /// Bumped by one for every shipped schema change, each paired with an `onUpgrade`
  /// step. Now 3 — v1 currencies, v2 added exchange_rates, v3 adds accounts.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          // A fresh install: creates every registered table, with their columns and
          // constraints. Never runs onUpgrade — it starts at the current version.
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Stepped: each guarded block adds exactly what its version introduced, so
          // a database at any older version catches up by running every step above
          // it, in order.
          //
          // v1 → v2: exchange_rates joins the schema.
          if (from < 2) {
            await m.createTable(exchangeRates);
          }
          // v2 → v3: accounts joins the schema.
          if (from < 3) {
            await m.createTable(accounts);
          }
        },
        beforeOpen: (OpeningDetails details) async {
          // Now load-bearing: exchange_rates has two foreign keys into currencies,
          // and SQLite ignores foreign keys unless asked, per connection. Without
          // this, a rate could reference a currency that does not exist and the
          // database would say nothing.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
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
