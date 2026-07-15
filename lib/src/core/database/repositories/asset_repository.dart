import 'package:wealth_os/src/core/database/app_database.dart';

/// Persistence contract for assets. Interface only — no CRUD in this task.
abstract interface class AssetRepository {
  /// Every asset across all portfolios, live.
  Stream<List<Asset>> watchAll();

  /// The assets in one portfolio, live — the query the portfolio detail view needs.
  Stream<List<Asset>> watchByPortfolio(String portfolioId);

  /// One asset by id, or null.
  Future<Asset?> findById(String id);

  /// Inserts an asset, returning its id.
  Future<String> create(AssetsCompanion asset);

  /// Applies the set fields of [asset] to the matching row. Returns whether one
  /// matched. Re-valuing a holding is an `update` that sets only `currentValue`.
  Future<bool> update(AssetsCompanion asset);

  /// Removes an asset. An asset is a leaf — nothing points at it — so a hard delete
  /// orphans nothing.
  Future<void> delete(String id);
}
