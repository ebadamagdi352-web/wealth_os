/// Enumerations persisted by the data layer.
///
/// # ⚠️ APPEND-ONLY — reordering or deleting a value corrupts existing data
///
/// Every one of these is stored by its **integer index** (Drift's `intEnum`), so
/// the database holds `0`, `1`, `2`, not `income`, `expense`, `transfer`. That
/// makes the *position* of each value load-bearing:
///
/// * **Add** a value only at the **end** of the list.
/// * **Never reorder** existing values — row `2` would silently become a different
///   thing.
/// * **Never delete** a value — every later value shifts down by one, and every
///   row pointing past the gap now means something else.
///
/// Storing by index is the compact, fast choice; the discipline above is the price.
/// The alternative — Drift's `textEnum`, which stores the *name* — survives
/// reordering but costs bytes and a text comparison on every read. If this app ever
/// needs to freely reorder these, that is the trade to revisit (see
/// TASK_019_REPORT.md §Migration).
library;

/// The kind of account. Deposit-style accounts hold a balance; a credit card is
/// still an account here — the *balance semantics* (a limit and a used amount) are
/// a concern for the domain layer that reads [AccountType], not for storage.
enum AccountType {
  cash,
  checking,
  savings,
  creditCard,
  loan,
  investment,
  wallet,
}

/// The kind of holding inside a portfolio.
enum AssetType {
  cash,
  stock,
  bond,
  fund,
  gold,
  realEstate,
  crypto,
  other,
}

/// The nature of a category.
///
/// Identical membership to [TransactionType] **today**, but kept separate on
/// purpose: a category classifies *where money is grouped*, a transaction
/// classifies *what a single movement is*, and the two axes may diverge (a future
/// `system` or `adjustment` category with no transaction counterpart). Merging them
/// now would couple two concepts that only coincidentally match.
enum CategoryType {
  income,
  expense,
  transfer,
}

/// The nature of a single money movement.
enum TransactionType {
  income,
  expense,
  transfer,
}

/// Where a goal is in its lifecycle.
enum GoalStatus {
  active,
  completed,
  paused,
  cancelled,
}
