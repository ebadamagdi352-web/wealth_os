import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealth_os/src/design_system/app_colors.dart';
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/design_system/app_theme.dart';
import 'package:wealth_os/src/design_system/app_typography.dart';
import 'package:wealth_os/src/features/accounts/models/account_summary.dart';
import 'package:wealth_os/src/features/accounts/widgets/account_balance.dart';

/// One account.
///
/// The body is a `switch` over the sealed [AccountSummary]. A [DepositAccount]
/// shows a balance and stops. A [CreditCardAccount] shows what is available, then
/// a utilisation bar, then what is owed against the limit.
///
/// Because the model is sealed, adding a fifth kind of account — a loan, a
/// brokerage — **will not compile** until this switch decides how to draw it. The
/// alternative, a `default:` branch, would silently render the new account as a
/// blank card and nobody would find out until a user did.
class AccountCard extends StatelessWidget {
  const AccountCard({required this.account, super.key});

  final AccountSummary account;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    final Brightness brightness = theme.brightness;
    final bool isDark = brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.cardAll,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderCard,
        // Shadow in light, border in dark — never both. A black shadow on a
        // near-black surface is invisible, so dark mode separates by edge.
        boxShadow: AppShadows.card(brightness),
        border: isDark ? Border.all(color: colors.outlineVariant) : null,
      ),
      child: switch (account) {
        final DepositAccount deposit => _DepositBody(account: deposit),
        final CreditCardAccount credit => _CreditBody(account: credit),
      },
    );
  }
}

/// Chequing, cash, savings: an identity row and a balance.
class _DepositBody extends StatelessWidget {
  const _DepositBody({required this.account});

  final DepositAccount account;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double balance = account.balance;

    // An overdrawn account is shown in the loss colour *and* with a minus sign.
    // The sign is what makes it correct; the colour only makes it fast. Roughly
    // one man in twelve cannot rely on the colour at all.
    final bool isOverdrawn = balance < 0;
    final Color? amountColor = isOverdrawn
        ? (theme.brightness == Brightness.dark
            ? AppColors.darkLoss
            : AppColors.lightLoss)
        : null;

    return Row(
      children: <Widget>[
        _AccountIcon(type: account.type),
        AppSpacing.gapH12,
        Expanded(child: _AccountIdentity(account: account)),
        AppSpacing.gapH8,
        Flexible(
          child: AccountBalance(
            currencyCode: account.currencyCode,
            amount: balance,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}

/// A credit card: available credit, a utilisation bar, and the debt.
class _CreditBody extends StatelessWidget {
  const _CreditBody({required this.account});

  final CreditCardAccount account;

  static final NumberFormat _format = NumberFormat.decimalPattern('en');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    final Color barColor = _utilisationColor(
      theme.brightness,
      account.utilisation,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            _AccountIcon(type: account.type),
            AppSpacing.gapH12,
            Expanded(
              child: _AccountIdentity(
                account: account,
                badge: _UtilisationBadge(utilisation: account.utilisation),
              ),
            ),
            AppSpacing.gapH8,
            // The card leads with what is *available*, which is the question a
            // user is actually asking when they look at a credit card. The debt
            // sits directly beneath it — shown, never hidden.
            Flexible(
              child: AccountBalance(
                currencyCode: account.currencyCode,
                amount: account.availableCredit,
                label: AccountCardCopy.available,
              ),
            ),
          ],
        ),
        AppSpacing.gapV16,
        ClipRRect(
          borderRadius: AppRadius.borderXs,
          child: LinearProgressIndicator(
            value: account.utilisation,
            minHeight: 5,
            backgroundColor: colors.surfaceContainerHigh,
            color: barColor,
          ),
        ),
        AppSpacing.gapV8,
        Text(
          '${AccountCardCopy.used} '
          '${account.currencyCode} ${_format.format(account.usedAmount)} '
          '${AccountCardCopy.of} '
          '${_format.format(account.creditLimit)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
      ],
    );
  }

  /// The bar changes colour as the card fills up.
  ///
  /// Not decoration. Credit utilisation above roughly 30% is the single largest
  /// negative factor in most credit scoring models, and above 70% the card is one
  /// bad month from being maxed. A bar that stays the same colour at 5% and 95%
  /// is withholding the only thing it knows.
  ///
  /// The percentage is always shown as text beside it, so the colour is never the
  /// sole carrier of the warning.
  static Color _utilisationColor(Brightness brightness, double utilisation) {
    final bool isDark = brightness == Brightness.dark;
    if (utilisation >= 0.7) {
      return isDark ? AppColors.darkLoss : AppColors.lightLoss;
    }
    if (utilisation >= 0.3) {
      return isDark ? AppColors.darkWarning : AppColors.lightWarning;
    }
    return isDark ? AppColors.darkGain : AppColors.lightGain;
  }
}

/// Name over type.
class _AccountIdentity extends StatelessWidget {
  const _AccountIdentity({required this.account, this.badge});

  final AccountSummary account;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          account.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall,
        ),
        AppSpacing.gapV4,
        if (badge != null)
          badge!
        else
          Text(
            account.type.displayLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

/// The optional status badge. Currently used only by credit cards.
///
/// It carries a *fact* — how much of the limit is gone — rather than a status
/// word like "Active". Every one of these four accounts would read "Active", and
/// a badge that says the same thing on every card is a badge that has stopped
/// being read.
class _UtilisationBadge extends StatelessWidget {
  const _UtilisationBadge({required this.utilisation});

  final double utilisation;

  static final NumberFormat _percent = NumberFormat.decimalPercentPattern(
    locale: 'en',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: AppRadius.borderPill,
      ),
      child: Text(
        '${_percent.format(utilisation)} ${AccountCardCopy.usedSuffix}',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colors.onSurfaceVariant,
          fontFeatures: AppTypography.tabularFigures,
        ),
      ),
    );
  }
}

/// The tinted icon chip.
class _AccountIcon extends StatelessWidget {
  const _AccountIcon({required this.type});

  final AccountType type;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: AppRadius.borderMd,
      ),
      child: Icon(
        AccountIcons.forKey(type.iconKey),
        size: 20,
        color: colors.onPrimaryContainer,
      ),
    );
  }
}

/// Resolves an [AccountType.iconKey] to a Material icon.
///
/// The indirection is what keeps `account_summary.dart` free of Flutter. A model
/// carrying an `IconData` cannot be unit-tested without a widget binding, and
/// cannot be serialised without a custom converter.
abstract final class AccountIcons {
  static const Map<String, IconData> _icons = <String, IconData>{
    'checking': Icons.account_balance_outlined,
    'cash': Icons.account_balance_wallet_outlined,
    'savings': Icons.savings_outlined,
    'credit_card': Icons.credit_card,
  };

  /// Fallback for a key with no mapping.
  ///
  /// A missing icon must not crash the screen. The fallback is visually obvious,
  /// so an unmapped key gets noticed rather than silently tolerated.
  static const IconData fallback = Icons.account_balance_outlined;

  static IconData forKey(String iconKey) => _icons[iconKey] ?? fallback;
}

/// Copy owned by the account card.
///
/// Not localized — see `AccountsCopy` in `accounts_page.dart` for the full note.
/// It lives here rather than in the page because the card is the only thing that
/// renders it, and passing four strings down through two widgets to reach one
/// `Text` is worse than the rule it would be honouring.
abstract final class AccountCardCopy {
  static const String available = 'Available';
  static const String used = 'Used';
  static const String of = 'of';
  static const String usedSuffix = 'used';
}
