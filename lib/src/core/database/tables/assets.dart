import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';
import 'package:wealth_os/src/core/database/tables/enums.dart';
import 'package:wealth_os/src/core/database/tables/portfolios.dart';

/// A single holding inside a portfolio: 12.5 grams of gold, 40 shares, a flat.
///
/// The split between [cost] and [currentValue] is what lets performance be
/// *computed* rather than stored — gain is `currentValue - cost`, and a percentage
/// is that over `cost`. Storing a "performance %" here would be a third number that
/// could disagree with the two it comes from; the assets feature (Task 017) already
/// derives it, and this schema keeps only the inputs.
@DataClassName('Asset')
class Assets extends Table {
  /// Client-generated UUID. See `Accounts` for the id convention.
  TextColumn get id => text()();

  /// The portfolio this holding belongs to. Every asset lives in exactly one.
  TextColumn get portfolioId => text().references(Portfolios, #id)();

  /// The user's label: 'Gold', 'Apple', 'Sea-view flat'.
  TextColumn get name => text()();

  /// Stored as the enum's index — see the append-only warning in `enums.dart`.
  IntColumn get type => intEnum<AssetType>()();

  /// The currency [cost] and [currentValue] are expressed in.
  TextColumn get currencyId => text().references(Currencies, #id)();

  /// How much is held — 12.5 grams, 40 shares, 0.75 BTC. **Fixed-point**, scaled by
  /// `kFixedPointScale` (1e8), because quantities are routinely fractional and a
  /// `double` would round them. `12.5` is stored as `1_250_000_000`.
  IntColumn get quantity => integer().withDefault(const Constant(0))();

  /// What was paid to acquire the holding — the cost basis. Integer minor units of
  /// [currencyId]. The denominator of every return figure.
  IntColumn get cost => integer().withDefault(const Constant(0))();

  /// What the holding is worth now. Integer minor units of [currencyId]. Updated
  /// from a valuation source; the schema stores the number, not where it came from.
  IntColumn get currentValue => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
