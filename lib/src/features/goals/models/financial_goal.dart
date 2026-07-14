import 'package:equatable/equatable.dart';

/// One savings goal, as the goals screen needs to see it.
///
/// ## A plain class, like `TransactionSummary` and `AssetSummary`
///
/// Every goal is the same shape — a name, an amount saved, an amount wanted, and
/// a date it is wanted by. There is no "credit-card-shaped goal" that carries
/// fields the others lack, so there is nothing to seal. The only variation is a
/// nullable [targetDate], and a nullable field is variation *within* one shape,
/// not a second shape. Sealing here would buy an exhaustive switch over a single
/// case, which is just a class wearing a costume.
///
/// The progress figures are **derived, never stored**. A goal that carried both a
/// current amount and a "61%" would hold one fact in two places, and the first
/// edit to either that forgot the other would make the card lie about itself.
/// Here the percentage cannot disagree with the amounts, because it *is* the
/// amounts.
class FinancialGoal extends Equatable {
  const FinancialGoal({
    required this.id,
    required this.name,
    required this.currentAmount,
    required this.targetAmount,
    required this.currencyCode,
    required this.iconKey,
    this.targetDate,
  });

  /// Stable identifier, generated client-side so a goal has one before any
  /// database sees it.
  final String id;

  /// The user's own name for the goal. **Never translated** — their words.
  final String name;

  /// How much has been set aside so far.
  final double currentAmount;

  /// How much the goal needs. Assumed positive; a goal of zero is not a goal, and
  /// [progress] guards against it rather than dividing by it.
  final double targetAmount;

  /// ISO 4217 code. Per goal — someone may save for an overseas flat in a
  /// different currency than their emergency fund.
  final String currencyCode;

  /// Stable icon identifier. A string, not an `IconData`, so this file stays pure
  /// Dart and unit-testable without a widget binding.
  final String iconKey;

  /// When the goal is wanted by. **Nullable on purpose** — some goals are dates
  /// ("a deposit by 2028"), and some are open-ended ("keep six months of expenses
  /// on hand, forever"). An open-ended goal with a fabricated deadline is a goal
  /// that nags the user about a date they never set.
  final DateTime? targetDate;

  /// Progress as a raw fraction: `0.6167` is 61.67%.
  ///
  /// **Uncapped**, so an over-funded goal reads above 1.0 and the fact that the
  /// user oversaved is not hidden from any caller that wants to know. Guards a
  /// zero (or negative) target by returning 0 rather than producing infinity or
  /// NaN, either of which renders as a broken bar.
  double get progress => targetAmount <= 0 ? 0 : currentAmount / targetAmount;

  /// Progress clamped to `0.0..1.0`, for the things that cannot exceed full — a
  /// progress bar's width, an average that should not be dragged past 100% by one
  /// over-funded goal.
  ///
  /// `.toDouble()` because `num.clamp` is typed to return `num`; without it this
  /// getter would not satisfy its own `double` return type.
  double get progressClamped => progress.clamp(0.0, 1.0).toDouble();

  /// Whether the goal is met. A positive target guards the "0 / 0 is done" trap,
  /// where an empty goal would otherwise report itself complete.
  bool get isComplete => targetAmount > 0 && currentAmount >= targetAmount;

  /// How much is still needed, never negative. Zero once the goal is met, so the
  /// card can say "done" instead of "−5,000 to go".
  double get remaining =>
      (targetAmount - currentAmount).clamp(0.0, double.infinity).toDouble();

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        currentAmount,
        targetAmount,
        currencyCode,
        iconKey,
        targetDate,
      ];

  @override
  bool get stringify => true;
}
