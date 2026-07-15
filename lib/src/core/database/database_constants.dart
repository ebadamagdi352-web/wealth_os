/// Storage conventions for the numeric quantities in this schema.
///
/// # Money is never a floating-point number
///
/// `0.1 + 0.2 != 0.3` in IEEE-754, and a ledger that stores balances as `double`
/// will, given enough transactions, disagree with itself by a fraction of a
/// piastre — and then a whole one. Every monetary and fractional quantity in this
/// database is therefore an **integer**, and these constants define what the
/// integers mean.
///
/// ## Monetary amounts — minor units of their own currency
///
/// Balances, costs, values, transaction amounts, and goal targets are stored as
/// integer **minor units**: the smallest unit the currency actually has. For a
/// 2-digit currency (EGP, USD) that is piastres/cents — `150.00 EGP` is stored as
/// `15000`. For a 0-digit currency (JPY) it is whole yen. For an 8-digit currency
/// (BTC) it is satoshis.
///
/// The scale is therefore **not fixed** — it is `10 ^ currency.decimalDigits`,
/// which is exactly why every table that stores an amount also stores a
/// `currencyId`. **You cannot interpret an amount without its currency.** That is a
/// property of money, not a limitation of the schema: `15000` is 150.00 dollars or
/// 15000 yen depending entirely on which currency it belongs to.
///
/// ## Rates and quantities — a fixed high-precision scale
///
/// Exchange rates and asset quantities are not money and have no currency to take a
/// scale from, so they use one fixed scale: [kFixedPointScale]. A rate or quantity
/// is stored as `value * kFixedPointScale`.
library;

/// The fixed-point multiplier for exchange rates and asset quantities.
///
/// `1e8` gives eight decimal places — enough to hold an FX rate to the precision
/// any market quotes, and enough to hold one satoshi of Bitcoin or a fractional
/// share to a hundred-millionth. Stored as `int`, so a rate of `30.85` is the
/// integer `3_085_000_000` and a holding of `12.5` grams of gold is
/// `1_250_000_000`.
///
/// This value must **never change** once data exists: every stored rate and
/// quantity is scaled by it, so altering it would silently multiply or divide every
/// number in those columns. If more precision is ever needed, that is a schema
/// migration that rewrites the affected columns, not an edit to this constant.
const int kFixedPointScale = 100000000; // 1e8
