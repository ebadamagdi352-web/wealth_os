import 'package:drift/drift.dart';

/// The nature of a category.
///
/// Lives in this file for the same reason `AccountType` lives in `accounts.dart` —
/// the schema has no shared enums file yet, and an enum belongs with its consumer
/// until a second table needs it.
///
/// ⚠️ **APPEND-ONLY.** Stored by its integer index (`intEnum`), so reordering or
/// deleting a value silently reassigns existing rows. Only ever add new values at
/// the **end**.
enum CategoryType {
  expense,
  income,
  investment,
  transfer,
  saving,
  other,
}

/// A transaction category, in a tree of unlimited depth.
///
/// ## How the unlimited hierarchy works
///
/// Each row carries a nullable [parentId] pointing at another row in *this same
/// table*. A null parent is a root ("Expenses"); a non-null parent is a child
/// ("Food" under "Expenses", "Groceries" under "Food"). That single self-referencing
/// column is the whole mechanism — the **adjacency-list** model — and it imposes no
/// depth limit, because nothing in the schema counts levels. The example tree
///
/// ```
/// Expenses
///  └── Food
///       └── Groceries
/// ```
///
/// is just three rows, each naming the one above it; a tenth level is a tenth row.
///
/// The honest trade-off: adjacency lists make inserts and "who is my direct parent"
/// trivial, but "give me this whole subtree" needs a recursive query
/// (SQLite `WITH RECURSIVE`). That is a read concern for a future service, not a
/// schema limit — the shape supports any depth; traversal is supplied on top.
@DataClassName('Category')
class Categories extends Table {
  /// Client-generated UUID string, matching the established id convention.
  TextColumn get id => text()();

  /// The parent category, or null for a top-level one. **Self-referencing** —
  /// references `Categories.id` — and this pointer is the entire hierarchy. A
  /// service-level guard must later stop a category being moved under its own
  /// descendant (a cycle); the schema permits the pointer, the service forbids the
  /// loop.
  TextColumn get parentId =>
      text().nullable().references(Categories, #id)();

  /// The user's label for this category.
  TextColumn get name => text()();

  /// Whether this groups expense, income, etc. Stored as [CategoryType]'s index —
  /// see the append-only warning on the enum.
  IntColumn get type => intEnum<CategoryType>()();

  /// An icon key — a string the UI resolves to a glyph, the indirection the features
  /// already use. Nullable: a category may inherit or default its icon.
  TextColumn get icon => text().nullable()();

  /// A display colour as a packed ARGB integer, or null. Presentation data stored
  /// deliberately, because the colour is the *user's* choice attached to *their*
  /// category, not a theme value.
  IntColumn get color => integer().nullable()();

  /// Manual ordering among siblings, so a user's arrangement survives where
  /// alphabetical would throw it away.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Soft delete. A category with historical transactions is archived, not removed,
  /// so old transactions keep their classification.
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
