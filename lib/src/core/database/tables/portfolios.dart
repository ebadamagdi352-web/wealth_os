import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';

/// A named grouping of assets — "Retirement", "Trading", "Property".
///
/// Portfolios exist so that "unlimited portfolios" is a data shape, not a promise:
/// an asset points at a portfolio, a portfolio has no fixed slot, so there can be
/// one or a hundred. A user who never thinks in portfolios simply has one default
/// portfolio they never see named.
@DataClassName('Portfolio')
class Portfolios extends Table {
  /// Client-generated UUID. See `Accounts` for the id convention.
  TextColumn get id => text()();

  /// The user's label for the grouping.
  TextColumn get name => text()();

  /// The portfolio's reporting currency — what its total is expressed in when its
  /// assets span several currencies. The assets keep their own currencies; this is
  /// the lens the portfolio is summed through.
  TextColumn get currencyId => text().references(Currencies, #id)();

  /// Optional free text. Nullable because most portfolios need no description, and
  /// an empty string and "no description" should not be two different states.
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
