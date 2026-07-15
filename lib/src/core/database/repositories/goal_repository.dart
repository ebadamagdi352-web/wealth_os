import 'package:wealth_os/src/core/database/app_database.dart';
import 'package:wealth_os/src/core/database/tables/enums.dart';

/// Persistence contract for financial goals. Interface only — no CRUD in this task.
abstract interface class GoalRepository {
  /// Live list of goals, optionally filtered to a single [status] (e.g. only
  /// `active` ones for the main screen).
  Stream<List<FinancialGoal>> watchAll({GoalStatus? status});

  /// One goal by id, or null.
  Future<FinancialGoal?> findById(String id);

  /// Inserts a goal, returning its id.
  Future<String> create(FinancialGoalsCompanion goal);

  /// Applies the set fields of [goal] to the matching row. Returns whether one
  /// matched.
  ///
  /// ⚠️ Contributing to a goal will, in the mature model, be a *transaction* that
  /// raises `currentAmount` as a side effect — not a bare `update` typed by hand.
  /// Until then, adjusting `currentAmount` is an `update`, with the same drift risk
  /// noted on the column. See TASK_019_REPORT.md.
  Future<bool> update(FinancialGoalsCompanion goal);

  /// Removes a goal. A goal is a target, not a record of money — deleting it does
  /// not orphan transactions — so a hard delete is acceptable here.
  Future<void> delete(String id);
}
