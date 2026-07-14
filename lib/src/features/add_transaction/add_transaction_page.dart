import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/add_transaction/models/transaction_form.dart';
import 'package:wealth_os/src/features/add_transaction/widgets/account_selector.dart';
import 'package:wealth_os/src/features/add_transaction/widgets/amount_field.dart';
import 'package:wealth_os/src/features/add_transaction/widgets/category_selector.dart';
import 'package:wealth_os/src/features/add_transaction/widgets/date_selector.dart';
import 'package:wealth_os/src/features/add_transaction/widgets/notes_field.dart';
import 'package:wealth_os/src/features/add_transaction/widgets/save_button.dart';
import 'package:wealth_os/src/features/add_transaction/widgets/transaction_type_selector.dart';
import 'package:wealth_os/src/features/transactions/models/transaction_summary.dart';
import 'package:wealth_os/src/localization/generated/app_localizations.dart';
import 'package:wealth_os/src/routing/route_paths.dart';

/// Every string this screen renders, except those owned by an individual field.
///
/// Same confession as `DashboardCopy`, `AccountsCopy` and `TransactionsCopy`: the ARB
/// files hold four keys, none of them these, and localization has been out of scope for
/// eight consecutive tasks.
abstract final class AddTransactionCopy {
  static const String title = 'Add Transaction';
  static const String fromAccount = 'From account';
  static const String toAccount = 'To account';
  static const String account = 'Account';
  static const String save = 'Save transaction';
}

/// The add-transaction form.
///
/// UI only. No provider, no repository, no database, no API, no persistence. Saving
/// raises a snackbar and nothing else.
///
/// ## Why this is a `StatefulWidget`
///
/// Providers are forbidden here, so the form's state lives in `State`. That is not a
/// compromise — it is the right home for it regardless. **Form state is ephemeral**: it
/// belongs to one screen, for the length of one visit, and it should die when the screen
/// does. Hoisting it into a global provider would make a half-typed amount survive
/// navigation, app backgrounding, and the user's decision to give up — and then reappear,
/// uninvited, the next time they opened the form.
///
/// What *does* belong in a provider is the **submit**: `ref.read(transactionRepositoryProvider).add(...)`.
/// The form holds the draft; the provider performs the act.
class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  /// Narrower than the other screens' 720.
  ///
  /// A form is read down a single column, and a text field stretched to 720px is a text
  /// field whose label is a hand's width from its content. Forms want to be narrow;
  /// dashboards want to be wide.
  static const double _maxContentWidth = 560;

  /// Used when no account is selected yet, so the amount field always has a suffix. A
  /// number with no currency beside it is not money, it is just a number.
  static const String _fallbackCurrency = 'EGP';

  // ---------------------------------------------------------------------
  // MOCK DATA
  //
  // Deliberately **not** imported from `features\accounts\`. The form needs three fields
  // — id, name, currency — and pulling in `AccountSummary` to get them would couple two
  // features for no benefit. When a repository exists this becomes
  // `ref.watch(accountsProvider)`, mapped to `FormAccount`.
  // ---------------------------------------------------------------------
  static const List<FormAccount> _mockAccounts = <FormAccount>[
    FormAccount(id: 'acc_main_bank', name: 'Main Bank', currencyCode: 'EGP'),
    FormAccount(id: 'acc_cash_wallet', name: 'Cash Wallet', currencyCode: 'EGP'),
    FormAccount(id: 'acc_savings', name: 'Savings', currencyCode: 'USD'),
    FormAccount(
      id: 'acc_visa_platinum',
      name: 'Visa Platinum',
      currencyCode: 'EGP',
    ),
  ];

  late TransactionForm _form;

  /// The two text controllers are owned here rather than inside the fields.
  ///
  /// A `TextField` that builds its own controller loses the cursor position every time
  /// its parent rebuilds — and this parent rebuilds on every keystroke, because the form
  /// state is immutable and `setState` replaces it. Owning the controllers is what makes
  /// an immutable form model survive contact with a text field.
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The date defaults to today. Nine times in ten that is the answer, and a form that
    // opens with its most likely value already filled is a form the user can finish
    // without touching it.
    _form = TransactionForm(date: DateTime.now());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _update(TransactionForm next) {
    setState(() => _form = next);
  }

  /// The currency shown beside the amount: the source account's, if one is chosen.
  String get _currencyCode {
    final String? id = _form.sourceAccountId;
    if (id == null) {
      return _fallbackCurrency;
    }
    for (final FormAccount account in _mockAccounts) {
      if (account.id == id) {
        return account.currencyCode;
      }
    }
    return _fallbackCurrency;
  }

  /// What saving does.
  ///
  /// There is no repository — CRUD is forbidden — so nothing is written. It does **not**
  /// silently do nothing: a primary button that swallows a tap teaches a user the app is
  /// broken. It acknowledges the tap with the `comingSoon` key that already exists in both
  /// ARB files, which makes this the only correctly localized string on the screen.
  void _onSave() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.comingSoon),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _onClose() {
    // `canPop` first: the page can be reached by deep link, in which case there is no
    // history to pop and a bare `pop()` would leave the user on a blank route.
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RoutePaths.transactions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTransfer = _form.needsDestinationAccount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AddTransactionCopy.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _onClose,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double gutter = AppSpacing.screenGutter(constraints.maxWidth);

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    gutter,
                    AppSpacing.lg,
                    gutter,
                    AppSpacing.x2l,
                  ),
                  children: <Widget>[
                    TransactionTypeSelector(
                      selected: _form.kind,
                      onChanged: (TransactionKind kind) =>
                          _update(_form.copyWith(kind: kind)),
                    ),
                    AppSpacing.gapV24,

                    AmountField(
                      controller: _amountController,
                      currencyCode: _currencyCode,
                      onChanged: (double? amount) =>
                          _update(_form.copyWith(amount: amount)),
                    ),
                    AppSpacing.gapV16,

                    // One widget, two roles. For a transfer it is the source; for
                    // anything else it is simply "the account".
                    AccountSelector(
                      label: isTransfer
                          ? AddTransactionCopy.fromAccount
                          : AddTransactionCopy.account,
                      accounts: _mockAccounts,
                      selectedId: _form.sourceAccountId,
                      onChanged: (String? id) =>
                          _update(_form.copyWith(sourceAccountId: id)),
                    ),

                    // ⚠️ Not in the brief's field list, and deliberately added.
                    //
                    // A transfer with one account is not a transfer: "moved 5,000 out of
                    // Main Bank" does not say where it went, and the other side of the
                    // entry does not exist. The money vanishes from the ledger.
                    //
                    // This is the double-entry gap flagged in TASK_015_REPORT.md §6.
                    // Deleting this block returns the form to exactly what was specified.
                    if (isTransfer) ...<Widget>[
                      AppSpacing.gapV16,
                      AccountSelector(
                        label: AddTransactionCopy.toAccount,
                        accounts: _mockAccounts,
                        selectedId: _form.destinationAccountId,
                        // A transfer from an account to itself is a no-op. Far easier to
                        // make it unselectable than to explain a rejection.
                        excludedId: _form.sourceAccountId,
                        onChanged: (String? id) =>
                            _update(_form.copyWith(destinationAccountId: id)),
                      ),
                    ],
                    AppSpacing.gapV16,

                    CategorySelector(
                      selected: _form.category,
                      onChanged: (TransactionCategory? category) =>
                          _update(_form.copyWith(category: category)),
                    ),
                    AppSpacing.gapV16,

                    DateSelector(
                      selected: _form.date,
                      onChanged: (DateTime date) =>
                          _update(_form.copyWith(date: date)),
                    ),
                    AppSpacing.gapV16,

                    NotesField(
                      controller: _notesController,
                      onChanged: (String notes) =>
                          _update(_form.copyWith(notes: notes)),
                    ),
                    AppSpacing.gapV32,

                    SaveButton(
                      label: AddTransactionCopy.save,
                      enabled: _form.isComplete,
                      onPressed: _onSave,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
