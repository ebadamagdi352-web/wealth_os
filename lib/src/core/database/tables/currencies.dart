import 'package:drift/drift.dart';

/// The currencies the app knows about.
///
/// The spine of the whole schema: every amount, in every other table, is
/// meaningless without a row here to say how many decimal places it has and what to
/// print beside it. Supporting "unlimited currencies" is not a feature bolted on —
/// it is the consequence of every money column carrying a `currencyId` instead of
/// assuming one.
@DataClassName('Currency')
class Currencies extends Table {
  /// Client-generated UUID. See `Accounts` for why every id in this schema is a
  /// text UUID rather than an autoincrementing integer.
  TextColumn get id => text()();

  /// ISO 4217 where one exists ('USD', 'EGP'), or a longer token for assets that
  /// have no ISO code ('BTC', 'XAU'). Unique — see [customConstraints].
  TextColumn get code => text().withLength(min: 2, max: 10)();

  /// Human name: 'US Dollar', 'Egyptian Pound'. Display text; the app may localize
  /// it, but the row stores one canonical name.
  TextColumn get name => text()();

  /// What to print beside an amount: '$', 'ج.م', '₿'.
  TextColumn get symbol => text()();

  /// How many minor units make one major unit — 2 for USD/EGP, 0 for JPY, 8 for
  /// BTC. This is the exponent that gives every amount in `currencyId`-bearing
  /// tables its scale. See `database_constants.dart`.
  IntColumn get decimalDigits => integer().withDefault(const Constant(2))();

  /// The single reporting currency everything is converted *to* for totals and
  /// net-worth. Exactly one row should have this true; enforcing "exactly one" is a
  /// service-layer rule, not a column constraint, because SQLite cannot express
  /// "at most one true".
  BoolColumn get isBaseCurrency =>
      boolean().withDefault(const Constant(false))();

  /// Whether the currency is offered in pickers. Currencies are **deactivated,
  /// never deleted** — a retired currency still has historical transactions
  /// pointing at it, and deleting it would orphan them.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => <Column>{id};

  /// `code` is unique. Declared as a table constraint rather than a `@TableIndex`
  /// annotation so it is enforced by the database itself, in a form that does not
  /// depend on any particular Drift version's annotation surface. Column name is
  /// snake_case because that is what Drift emits.
  @override
  List<String> get customConstraints => <String>['UNIQUE (code)'];
}
