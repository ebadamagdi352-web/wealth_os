import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';

/// Where a goal sits in its lifecycle.
///
/// ⚠️ **APPEND-ONLY** (stored by `intEnum` index) — only ever add new values at the
/// end; reordering or deleting reassigns existing rows.
enum GoalStatus {
  active,
  completed,
  paused,
  cancelled,
}

/// How much a goal matters to the user, for ordering and emphasis.
///
/// ⚠️ **APPEND-ONLY** — same rule as [GoalStatus].
enum GoalPriority {
  low,
  medium,
  high,
  critical,
}

/// A savings goal — a target amount the user is working toward.
///
/// ## Progress is computed, never stored
///
/// There is deliberately **no `progressPercentage` column**. Progress is
/// `currentAmount / targetAmount`, read at the moment it is shown. A stored
/// percentage would be a number that could disagree with the two amounts it derives
/// from, and the first contribution that updated `currentAmount` but forgot the
/// percentage would make the goal misreport itself. The same "derive, never
/// duplicate" rule the goals UI already follows (Task 018).
///
/// ## Two `FinancialGoal`s, in different layers
///
/// The goals feature has a presentation `FinancialGoal` (a view-model with getters
/// like `progressClamped`). This is the *persistence* one — the columns that survive
/// a restart. Same concept, two layers; a mapper translates this row into that
/// view-model, and any file importing both aliases one.
@DataClassName('FinancialGoal')
class FinancialGoals extends Table {
  /// Client-generated UUID string, matching the established id convention.
  TextColumn get id => text()();

  /// The user's label: 'Emergency Fund', 'Buy Apartment'. Their words.
  TextColumn get name => text()();

  /// Optional free text. Nullable — most goals need none, and an empty string and
  /// "no description" should not be two different states.
  TextColumn get description => text().nullable()();

  /// How much the goal needs. Integer minor units of [currencyId].
  IntColumn get targetAmount => integer()();

  /// How much is set aside. Integer minor units of [currencyId].
  ///
  /// Stored as specified, but the honest long-term value is the sum of the
  /// contributions made toward this goal. When goal contributions become real
  /// transactions, this should become that sum, maintained in the same write —
  /// until then it is a standalone figure, carrying the same cache-drift caveat as
  /// `Account.currentBalance`.
  IntColumn get currentAmount => integer().withDefault(const Constant(0))();

  /// The currency the goal is tracked in. **References `Currencies.id`.**
  TextColumn get currencyId => text().references(Currencies, #id)();

  /// When the goal is wanted by, or null for an open-ended one. Nullable because a
  /// standing goal ("keep six months of expenses") has no deadline, and a fabricated
  /// one would nag the user about a date they never set.
  DateTimeColumn get targetDate => dateTime().nullable()();

  /// How much the goal matters, stored as [GoalPriority]'s index — see the
  /// append-only warning on the enum.
  IntColumn get priority => intEnum<GoalPriority>()();

  /// Lifecycle state, stored as [GoalStatus]'s index. A *stored* status, distinct
  /// from the *derived* "is it 100% funded" — a goal can be fully funded yet still
  /// `active` (unspent), or `paused` at 40%.
  IntColumn get status => intEnum<GoalStatus>()();

  /// A display colour as a packed ARGB integer, or null — the user's colour for
  /// their goal.
  IntColumn get color => integer().nullable()();

  /// An icon key the UI resolves to a glyph, or null.
  TextColumn get icon => text().nullable()();

  /// Soft delete. An abandoned goal is archived, not removed, so its history
  /// survives.
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
