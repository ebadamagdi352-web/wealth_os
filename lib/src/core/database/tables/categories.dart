import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/enums.dart';

/// A transaction category, in a tree of unlimited depth.
///
/// ## How "unlimited hierarchy" is actually achieved
///
/// Each row carries a nullable [parentId] pointing at another row in *this same
/// table*. A null parent is a root; a non-null parent is a child. That single
/// self-referencing column is the entire mechanism — it is the **adjacency-list**
/// model, and it imposes no depth limit at all, because nothing in the schema
/// counts levels. "Food → Groceries → Organic" is three rows, each pointing at the
/// one above; a fourth level is just another row.
///
/// The trade-off is honest and worth stating: adjacency lists make *inserts* and
/// *"who is my direct parent"* trivial, but *"give me this whole subtree"* needs a
/// **recursive query** (SQLite's `WITH RECURSIVE`). That is a read concern for
/// `CategoryService`, not a schema change — the shape supports the depth; the
/// service supplies the traversal. The alternative models (nested sets, materialized
/// paths) make subtree reads faster but every *move* expensive, which is the wrong
/// trade for categories a user reorganizes by hand. See TASK_019_REPORT.md.
@DataClassName('Category')
class Categories extends Table {
  /// Client-generated UUID. See `Accounts` for the id convention.
  TextColumn get id => text()();

  /// The parent category, or null for a top-level one. **Self-referencing** — this
  /// is the whole of the hierarchy. A service-level guard must stop a category being
  /// moved under its own descendant (a cycle); the schema permits the pointer, the
  /// service forbids the loop.
  TextColumn get parentId =>
      text().nullable().references(Categories, #id)();

  /// The user's label for this category.
  TextColumn get name => text()();

  /// Whether this groups income, expense, or transfers. Stored as the enum index —
  /// see the append-only warning in `enums.dart`.
  IntColumn get type => intEnum<CategoryType>()();

  /// An icon key — a string resolved to a glyph by the UI, the same indirection the
  /// features already use. Nullable: a category may inherit or default its icon.
  TextColumn get icon => text().nullable()();

  /// A display colour as a packed ARGB integer. Nullable for the same reason as
  /// [icon]. This is presentation data living in the store — a small, deliberate
  /// concession, because the colour is the *user's* choice attached to *their*
  /// category, not a theme value. Portable enough; a hex string would be the
  /// alternative if the int format ever felt too Flutter-specific.
  IntColumn get color => integer().nullable()();

  /// Manual ordering among siblings. Two categories under one parent are shown in
  /// `sortOrder` order, so the user's arrangement survives — alphabetical would
  /// throw it away.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Soft delete. A category with historical transactions is archived, not removed,
  /// so old transactions keep their classification.
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
