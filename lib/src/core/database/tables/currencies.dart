import 'package:drift/drift.dart';

/// The currencies the app knows about.
///
/// The one table in this foundation. Everything money-related that comes later will
/// point back here — every amount is meaningless without a currency to say how many
/// decimal places it has and what symbol to print — so this is deliberately the
/// first stone laid.
@DataClassName('Currency')
class Currencies extends Table {
  /// Client-generated UUID string, not an autoincrement integer: a row needs an id
  /// the moment it is created offline, before any write succeeds, and UUIDs never
  /// collide when two devices sync. Matches the string ids the UI already uses and
  /// the `uuid` dependency already present.
  TextColumn get id => text()();

  /// ISO 4217 where one exists ('USD', 'EGP'), or a longer token for codes that have
  /// none ('BTC'). Unique — see [customConstraints].
  TextColumn get code => text().withLength(min: 2, max: 10)();

  /// Human name: 'US Dollar', 'Egyptian Pound'.
  TextColumn get name => text()();

  /// What to print beside an amount: '$', 'ج.م'.
  TextColumn get symbol => text()();

  /// Minor units per major unit — 2 for USD/EGP, 0 for JPY, 8 for BTC. The exponent
  /// that will give every future amount its scale.
  IntColumn get decimalDigits => integer().withDefault(const Constant(2))();

  /// The single reporting currency totals are expressed in. "Exactly one true" is a
  /// rule for the layer above; SQLite cannot express it as a column constraint.
  BoolColumn get isBaseCurrency =>
      boolean().withDefault(const Constant(false))();

  /// Whether the currency is offered in pickers. Currencies are deactivated, never
  /// deleted, so historical amounts always have one to point at.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// When the row was created. Defaults to the database clock at insert time, so it
  /// is set without the caller having to remember.
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// When the row was last changed. Defaults to insert time; keeping it current on
  /// updates is a write-side concern for a later task, not a column default.
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => <Column>{id};

  /// `code` is unique. A table constraint rather than a `@TableIndex` annotation, so
  /// the database itself enforces it in a form independent of any Drift version's
  /// annotation surface. Column name is snake_case because that is what Drift emits.
  @override
  List<String> get customConstraints => <String>['UNIQUE (code)'];
}
