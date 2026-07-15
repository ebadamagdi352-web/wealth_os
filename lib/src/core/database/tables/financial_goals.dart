import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';
import 'package:wealth_os/src/core/database/tables/enums.dart';

/// A savings goal.
///
/// ## Two `FinancialGoal`s, on purpose, in different layers
///
/// The goals feature (Task 018) already has a `FinancialGoal` — a presentation
/// view-model with derived getters like `progressClamped`. This is the *persistence*
/// `FinancialGoal`: the columns that survive a restart. They share a name because
/// they model the same concept at two layers, and they must not share a type — a
/// mapper will translate this row into that view-model, and the one file that
/// imports both will alias one. Different layers, different shapes, one idea.
@DataClassName('FinancialGoal')
class FinancialGoals extends Table {
  /// Client-generated UUID. See `Accounts` for the id convention.
  TextColumn get id => text()();

  /// The user's label: 'Emergency Fund', 'Buy Apartment'. Their words.
  TextColumn get name => text()();

  /// How much the goal needs. Integer minor units of [currencyId].
  IntColumn get targetAmount => integer()();

  /// How much is set aside. Integer minor units of [currencyId].
  ///
  /// ⚠️ Stored as the brief specifies, but the honest long-term value is
  /// **derived**: the sum of the contributions made toward this goal. Storing it
  /// standalone risks the same drift as `Account.currentBalance` — a cached total
  /// that can disagree with the movements it should equal. When goal contributions
  /// become real transactions, this should become the sum of them, maintained in
  /// the same write. Flagged in TASK_019_REPORT.md.
  IntColumn get currentAmount => integer().withDefault(const Constant(0))();

  /// The currency the goal is tracked in.
  TextColumn get currencyId => text().references(Currencies, #id)();

  /// When the goal is wanted by, or null for an open-ended one. Nullable because a
  /// standing goal ("keep six months of expenses") has no deadline, and a fabricated
  /// one would nag the user about a date they never set.
  DateTimeColumn get targetDate => dateTime().nullable()();

  /// Where the goal is in its lifecycle. Stored as the enum index — see the
  /// append-only warning in `enums.dart`. Note this is a *stored* status, distinct
  /// from the *derived* "is it 100% funded" the feature computes: a goal can be
  /// fully funded yet still `active` (the user hasn't spent it), or `paused` at 40%.
  IntColumn get status => intEnum<GoalStatus>()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
