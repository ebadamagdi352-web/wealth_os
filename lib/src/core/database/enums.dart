/// Every enum persisted by the data layer, in one place.
///
/// Consolidated here (Task 019H) from the individual table files where each was
/// first defined, so the full set is visible together and any table can share one
/// without importing another table's file.
///
/// ⚠️ **APPEND-ONLY — the order below is load-bearing.** Every one of these is
/// stored by its integer index (Drift's `intEnum`), so the database holds `0`, `1`,
/// `2`, not the names. The *position* of each value is therefore part of the stored
/// data:
///
/// * **Add** a value only at the **end** of its list.
/// * **Never reorder** existing values — a row's stored index would come to mean a
///   different thing.
/// * **Never delete** a value — every later value shifts down and every row past the
///   gap is silently rewritten.
///
/// The order here is exactly the order these enums shipped with across Tasks
/// 019C–019G and must not change.
library;

/// The kind of account.
enum AccountType {
  cash,
  bank,
  creditCard,
  wallet,
  investment,
  loan,
  other,
}

/// The kind of owned wealth held as an asset.
enum AssetType {
  cash,
  gold,
  silver,
  stock,
  etf,
  mutualFund,
  bond,
  crypto,
  realEstate,
  vehicle,
  business,
  commodity,
  other,
}

/// The nature of a category.
///
/// Identical membership to some of [TransactionType] today, but a distinct axis —
/// a category classifies where money is grouped, a transaction classifies a single
/// movement — so the two are kept separate.
enum CategoryType {
  expense,
  income,
  investment,
  transfer,
  saving,
  other,
}

/// The nature of a single money movement.
enum TransactionType {
  income,
  expense,
  transfer,
  investment,
  adjustment,
}

/// Where a goal sits in its lifecycle.
enum GoalStatus {
  active,
  completed,
  paused,
  cancelled,
}

/// How much a goal matters to the user, for ordering and emphasis.
enum GoalPriority {
  low,
  medium,
  high,
  critical,
}
