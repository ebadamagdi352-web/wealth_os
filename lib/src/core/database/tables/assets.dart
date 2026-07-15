import 'package:drift/drift.dart';
import 'package:wealth_os/src/core/database/enums.dart';
import 'package:wealth_os/src/core/database/tables/accounts.dart';
import 'package:wealth_os/src/core/database/tables/currencies.dart';

/// A single holding of owned wealth: grams of gold, shares of a stock, a flat, a
/// car, a stake in a business.
///
/// ## Total value is computed, never stored
///
/// The table keeps three raw numbers — [quantity], [unitCost], [currentUnitValue] —
/// and deliberately **no total**. A holding's worth is `quantity × currentUnitValue`
/// and its cost basis is `quantity × unitCost`; storing either total as a fourth
/// column would be a number that could disagree with the three it derives from, and
/// the first re-valuation that updated the unit value but forgot the total would
/// make the row lie. Gain, cost basis, and current worth are all read as products of
/// these three, at the moment they are needed.
///
/// ## The scales differ, on purpose
///
/// * [quantity] is fixed-point, `value × kFixedPointScale` (1e8) — holdings are
///   routinely fractional (12.5 grams, 0.75 BTC, 3.2 shares) and a `double` would
///   round them.
/// * [unitCost] and [currentUnitValue] are integer **minor units** of [currencyId]
///   (`× 10 ^ currency.decimalDigits`) — they are money, one unit's worth of it.
///
/// So a total in minor units is `quantity × currentUnitValue ÷ kFixedPointScale` —
/// the division removing the quantity's fixed-point scale. That arithmetic belongs
/// to a future service; the table's job is to store the exact inputs.
@DataClassName('Asset')
class Assets extends Table {
  /// Client-generated UUID string, matching the established id convention.
  TextColumn get id => text()();

  /// The user's label: 'Gold', 'Apple', 'Sea-view flat'.
  TextColumn get name => text()();

  /// The kind of asset, stored as [AssetType]'s index — see the append-only warning
  /// on the enum.
  IntColumn get type => intEnum<AssetType>()();

  /// The account this holding is tied to, or null. **References `Accounts.id`,
  /// nullable** — some assets (a flat, physical gold, a business stake) are wealth
  /// the user owns without sitting inside any tracked account, so forcing an account
  /// would invent a link that does not exist.
  TextColumn get accountId => text().nullable().references(Accounts, #id)();

  /// The currency [unitCost] and [currentUnitValue] are expressed in. **References
  /// `Currencies.id`.**
  TextColumn get currencyId => text().references(Currencies, #id)();

  /// How much is held — 12.5 grams, 40 shares, 0.75 BTC. Fixed-point, scaled by
  /// `kFixedPointScale` (1e8). `12.5` is stored as `1_250_000_000`.
  IntColumn get quantity => integer().withDefault(const Constant(0))();

  /// What one unit cost to acquire — the per-unit cost basis. Integer minor units of
  /// [currencyId].
  IntColumn get unitCost => integer().withDefault(const Constant(0))();

  /// What one unit is worth now. Integer minor units of [currencyId]. Updated from a
  /// valuation source; the table stores the number, not where it came from.
  IntColumn get currentUnitValue => integer().withDefault(const Constant(0))();

  /// Free text. Nullable; an empty note and no note are the same state.
  TextColumn get notes => text().nullable()();

  /// Soft delete. A sold or written-off asset is archived, not removed, so its
  /// history survives.
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
