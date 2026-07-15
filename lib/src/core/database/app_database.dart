import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/accounts.dart';
import 'package:wealth_os/src/core/database/tables/assets.dart';
import 'package:wealth_os/src/core/database/tables/categories.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';
import 'package:wealth_os/src/core/database/tables/exchange_rates.dart';
import 'package:wealth_os/src/core/database/tables/financial_goals.dart';
import 'package:wealth_os/src/core/database/tables/portfolios.dart';
import 'package:wealth_os/src/core/database/tables/transactions.dart';

// ⚠️ GENERATED FILE — does not exist until you run code generation.
//
// `flutter analyze` will report "Target of URI doesn't exist: 'app_database.g.dart'"
// and "_$AppDatabase isn't defined" until you run, from the project root:
//
//   dart run build_runner build --delete-conflicting-outputs
//
// This is normal and expected for every Drift database, not a fault in this file.
// The two setup steps — adding the drift dependencies to pubspec.yaml, then running
// the generator — are spelled out at the top of TASK_019_REPORT.md. Nothing in the
// data layer compiles until both are done; that is the nature of a code-generated
// ORM, not something this task could avoid.
part 'app_database.g.dart';

/// The application's Drift database — the one object that owns the schema.
///
/// It deliberately does **not** open its own connection. The [QueryExecutor] is
/// injected through the constructor, which keeps this class free of any platform
/// code (`path_provider`, `sqlite3`, native/web openers all live elsewhere) and
/// makes it trivially testable: a test passes an in-memory executor, production
/// passes a file-backed one, and this class cannot tell the difference. That is
/// dependency inversion doing exactly what it is for — the database depends on the
/// *abstraction* of an executor, not on how one is obtained.
///
/// Wiring a real executor and handing this database to the app belongs in
/// `bootstrap.dart`, which is out of scope for this task. See TASK_019_REPORT.md.
@DriftDatabase(
  tables: <Type>[
    Currencies,
    ExchangeRates,
    Accounts,
    Portfolios,
    Assets,
    Categories,
    Transactions,
    FinancialGoals,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Takes an already-built executor. See the class doc for why the connection is
  /// injected rather than opened here.
  AppDatabase(super.executor);

  /// Bumped by one for every shipped schema change, paired with an `onUpgrade` step
  /// below. Starts at 1 — the first shipped shape.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          // Creates every table, with its columns, foreign keys and unique
          // constraints, from the definitions in `tables/`.
          await m.createAll();

          // Performance indexes. Created here rather than via a `@TableIndex`
          // annotation so the exact SQL is visible and version-independent — every
          // one of these is a foreign key or a hot query column that would
          // otherwise force a full-table scan on a join or a sort.
          //
          // Column and table names are snake_case because that is what Drift emits
          // from the camelCase getters.
          await customStatement(
            'CREATE INDEX idx_account_currency '
            'ON accounts (currency_id)',
          );
          await customStatement(
            'CREATE INDEX idx_asset_portfolio '
            'ON assets (portfolio_id)',
          );
          await customStatement(
            'CREATE INDEX idx_asset_currency '
            'ON assets (currency_id)',
          );
          await customStatement(
            'CREATE INDEX idx_category_parent '
            'ON categories (parent_id)',
          );
          await customStatement(
            'CREATE INDEX idx_txn_account '
            'ON transactions (account_id)',
          );
          await customStatement(
            'CREATE INDEX idx_txn_category '
            'ON transactions (category_id)',
          );
          await customStatement(
            'CREATE INDEX idx_txn_date '
            'ON transactions (date)',
          );
          await customStatement(
            'CREATE INDEX idx_rate_lookup '
            'ON exchange_rates (from_currency_id, to_currency_id, effective_date)',
          );
          await customStatement(
            'CREATE INDEX idx_goal_currency '
            'ON financial_goals (currency_id)',
          );
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // No upgrades yet — schemaVersion is 1. Each future bump adds a branch
          // here that transforms `from` into `to`. See TASK_019_REPORT.md for the
          // step-by-step and schema-test strategy.
        },
        beforeOpen: (OpeningDetails details) async {
          // SQLite does **not** enforce foreign keys unless asked, per connection,
          // every time. Without this, a transaction could reference a deleted
          // account and the database would say nothing. Turned on before any query
          // runs.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
