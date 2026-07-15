import 'package:wealth_os/src/core/database/app_database.dart';
import 'package:wealth_os/src/core/database/tables/enums.dart';

/// The application-level contract for the category **tree**.
///
/// The repository returns flat rows with parent pointers; this service turns those
/// pointers into the shapes the app needs — the roots, a full subtree, the
/// breadcrumb path back to the top — and guards the one rule the adjacency-list
/// schema cannot enforce on its own: a category may not become its own ancestor.
///
/// This is where the "unlimited hierarchy" promise is actually kept, because this
/// is where depth is walked. The recursive traversal (SQLite `WITH RECURSIVE`, or
/// repeated fetches) is the implementation's; the interface only names what the app
/// can ask for. Interface only — no implementation, no logic, in this task.
abstract interface class CategoryService {
  /// The top-level categories, optionally of one [type]. The entry points into the
  /// tree.
  Future<List<Category>> roots({CategoryType? type});

  /// Every category beneath [categoryId], to any depth — the whole subtree, flat.
  /// The recursive walk lives in the implementation.
  Future<List<Category>> descendants(String categoryId);

  /// The chain from [categoryId] up to its root, nearest parent first — the
  /// breadcrumb for "Organic ▸ under Groceries ▸ under Food".
  Future<List<Category>> ancestors(String categoryId);

  /// How deep [categoryId] sits: 0 for a root, 1 for its child, and so on. The
  /// length of its [ancestors] chain.
  Future<int> depthOf(String categoryId);

  /// Reparents [categoryId] under [newParentId] (or to a root when null).
  ///
  /// Returns false, rather than corrupting the tree, when the move would create a
  /// **cycle** — moving a category under one of its own descendants, which would
  /// orphan a whole branch into an unreachable loop. That guard is the reason this
  /// operation is a service method and not a bare `repository.update` on `parentId`.
  Future<bool> move({
    required String categoryId,
    required String? newParentId,
  });
}
