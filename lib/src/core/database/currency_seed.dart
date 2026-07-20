/// The default currencies inserted the first time the database is created (and
/// back-filled into databases that predate the seed). Task 020E-B1.
///
/// ## Pure data, on purpose
///
/// This file holds no Drift types and imports nothing — it is a plain, reviewable
/// list. The *insertion* (mapping these into rows) lives in `app_database.dart`'s
/// migration, so this file cannot form an import cycle with the generated database
/// and can be read at a glance as "the currencies the app ships with".
///
/// ## Stable, fixed ids — the whole point of "stable UUIDs"
///
/// Each [SeedCurrency.id] is a **fixed UUID literal**, not one generated at runtime.
/// The same currency therefore has the same id on every device and on every re-seed,
/// which is what lets the insert be idempotent (an insert-if-absent can never
/// duplicate a currency) and lets anything that stores a `currencyId` mean the same
/// thing across installs. Per the database design, `id` remains the primary key and
/// `code` remains a separate unique field — the code is **not** the id.
///
/// These ids live only here. This file is their one home; nothing else hardcodes a
/// currency id.
library;

/// One seeded currency, as plain data. Mirrors the columns of the `Currencies`
/// table that the seed sets; the rest (`isActive`, timestamps) take their column
/// defaults at insert time.
class SeedCurrency {
  const SeedCurrency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.decimalDigits,
    required this.isBaseCurrency,
  });

  /// Fixed UUID. Stable across installs and re-seeds.
  final String id;

  /// ISO 4217 code. Unique in the table.
  final String code;

  final String name;
  final String symbol;

  /// Minor units per major unit — 2 for most, 0 for JPY.
  final int decimalDigits;

  /// Exactly one seeded currency has this true.
  final bool isBaseCurrency;
}

/// The currencies the app ships with.
///
/// EGP is the base currency (the app's reporting currency, per the dashboard);
/// exactly one entry has `isBaseCurrency: true`. The rest are common majors and
/// regional currencies. JPY is included partly because its `decimalDigits: 0`
/// exercises the non-2-digit path.
const List<SeedCurrency> defaultCurrencies = <SeedCurrency>[
  SeedCurrency(
    id: '57b41bcb-f269-43cd-8b16-cd500321d812',
    code: 'EGP',
    name: 'Egyptian Pound',
    symbol: 'ج.م',
    decimalDigits: 2,
    isBaseCurrency: true,
  ),
  SeedCurrency(
    id: 'd1040a31-9acd-4a87-a899-6adaca0389ce',
    code: 'USD',
    name: 'US Dollar',
    symbol: r'$',
    decimalDigits: 2,
    isBaseCurrency: false,
  ),
  SeedCurrency(
    id: '4f23493a-3880-4c3e-ae57-ad16f9ca3317',
    code: 'EUR',
    name: 'Euro',
    symbol: '€',
    decimalDigits: 2,
    isBaseCurrency: false,
  ),
  SeedCurrency(
    id: '23865743-ac63-463d-acda-7062f35e060a',
    code: 'GBP',
    name: 'British Pound',
    symbol: '£',
    decimalDigits: 2,
    isBaseCurrency: false,
  ),
  SeedCurrency(
    id: 'e8a5f165-e256-447d-8bbf-abe40831737d',
    code: 'SAR',
    name: 'Saudi Riyal',
    symbol: 'ر.س',
    decimalDigits: 2,
    isBaseCurrency: false,
  ),
  SeedCurrency(
    id: '657b6ece-cf4e-44b1-80d0-09fd1c3dd515',
    code: 'AED',
    name: 'UAE Dirham',
    symbol: 'د.إ',
    decimalDigits: 2,
    isBaseCurrency: false,
  ),
  SeedCurrency(
    id: 'f606acea-b24e-42b2-9bb6-4114c0c39039',
    code: 'JPY',
    name: 'Japanese Yen',
    symbol: '¥',
    decimalDigits: 0,
    isBaseCurrency: false,
  ),
];
