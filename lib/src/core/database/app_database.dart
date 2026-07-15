import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wealth_os/src/core/database/database_constants.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';

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
/// deliberately absent — this task is the foundation and one table, nothing more.
@DriftDatabase(tables: <Type>[Currencies])
class AppDatabase extends _$AppDatabase {
  /// Opens (lazily) the on-device SQLite database.
  AppDatabase() : super(_openConnection());

  /// Bumped by one for every shipped schema change, each paired with an `onUpgrade`
  /// step. Starts at 1 — the first shipped shape.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          // Creates the currencies table, with its columns and the UNIQUE(code)
          // constraint, from the definition in `tables/currencies.dart`.
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // No upgrades yet — schemaVersion is 1. Future bumps add branches here.
        },
        beforeOpen: (OpeningDetails details) async {
          // Harmless with a single table, kept so the setting is already correct the
          // moment a foreign key is introduced: SQLite ignores foreign keys unless
          // asked, per connection.
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
