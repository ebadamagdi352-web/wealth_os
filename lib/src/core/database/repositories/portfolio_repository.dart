import 'package:wealth_os/src/core/database/app_database.dart';

/// Persistence contract for portfolios. Interface only — no CRUD in this task.
abstract interface class PortfolioRepository {
  /// Live list of all portfolios.
  Stream<List<Portfolio>> watchAll();

  /// One portfolio by id, or null.
  Future<Portfolio?> findById(String id);

  /// Inserts a portfolio, returning its id.
  Future<String> create(PortfoliosCompanion portfolio);

  /// Applies the set fields of [portfolio] to the matching row. Returns whether one
  /// matched.
  Future<bool> update(PortfoliosCompanion portfolio);

  /// Removes a portfolio.
  ///
  /// Unlike accounts and currencies, a portfolio is a pure grouping — deleting it
  /// need not orphan history, provided its assets are reassigned or removed first.
  /// Enforcing that precondition is the implementation's job; the contract only
  /// names the operation.
  Future<void> delete(String id);
}
