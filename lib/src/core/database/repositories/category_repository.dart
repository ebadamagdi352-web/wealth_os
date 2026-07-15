import 'package:wealth_os/src/core/database/app_database.dart';
import 'package:wealth_os/src/core/database/tables/enums.dart';

/// Persistence contract for categories — the flat, row-level view.
///
/// This repository deals in **rows**, not trees: it fetches a category, its direct
/// children, or all of them, and it writes. Assembling those rows into a tree,
/// walking ancestors, and guarding against cycles is deliberately *not* here — that
/// is traversal logic and lives in `CategoryService`. Keeping the repository flat
/// keeps it honest about what SQLite hands back: rows with parent pointers.
///
/// Interface only — no CRUD in this task.
abstract interface class CategoryRepository {
  /// Every category, optionally filtered by [type] and by whether archived ones are
  /// included. Live.
  Stream<List<Category>> watchAll({
    CategoryType? type,
    bool includeArchived,
  });

  /// The direct children of [parentId], or the roots when [parentId] is null. One
  /// level only — the service composes these into a tree.
  Future<List<Category>> childrenOf(String? parentId);

  /// One category by id, or null.
  Future<Category?> findById(String id);

  /// Inserts a category, returning its id.
  Future<String> create(CategoriesCompanion category);

  /// Applies the set fields of [category] to the matching row. Returns whether one
  /// matched. A *move* — reparenting — is an `update` that sets only `parentId`,
  /// but only after the service has confirmed it forms no cycle.
  Future<bool> update(CategoriesCompanion category);

  /// Soft delete — flips `isArchived`, so historical transactions keep their
  /// classification.
  Future<void> archive(String id);
}
