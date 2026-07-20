import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wealth_os/src/core/database/enums.dart' as db;
import 'package:wealth_os/src/design_system/app_radius.dart';
import 'package:wealth_os/src/design_system/app_spacing.dart';
import 'package:wealth_os/src/features/add_transaction/models/transaction_form.dart'
    show AddTransactionFieldStyle;

/// Every string the Add Account screen renders.
///
/// Not localized — the ARB files still hold four keys and none are these, the same
/// per-feature English pattern as every screen so far. Task 020E-A dropped the
/// localization dependency, so even the Continue acknowledgement is hardcoded.
abstract final class AddAccountCopy {
  static const String title = 'Add account';

  static const String nameLabel = 'Account name';
  static const String nameHint = 'e.g. Main Bank';
  static const String nameRequired = 'Enter an account name';

  static const String typeLabel = 'Account type';

  static const String balanceLabel = 'Opening balance';
  static const String balanceHint = '0';
  static const String balanceRequired = 'Enter an opening balance';
  static const String balanceNotNumeric = 'Enter a valid number';

  static const String cancel = 'Cancel';
  static const String continueLabel = 'Continue';

  /// Temporary — the Continue acknowledgement, until the save task replaces it.
  static const String comingSoon = 'Coming soon';
}

/// Display labels for the stored account types.
///
/// ## Why `db.AccountType`, not the feature's UI `AccountType`
///
/// The accounts feature has its own `AccountType` (checking / cash / savings /
/// creditCard) — but that is a **lossy display projection**. The database stores
/// seven kinds (`db.AccountType`), and the UI enum has no way to name a *wallet*,
/// an *investment*, or a *loan*. Building the type picker on the UI enum would make
/// those three kinds of account impossible to create.
///
/// So the picker offers `db.AccountType` — the same enum the save task will store,
/// which means no lossy mapping ever sits between what the user chose and what lands
/// in the row. `db.AccountType` is a bare enum with no label text, so the labels
/// live here.
const Map<db.AccountType, String> _accountTypeLabels = <db.AccountType, String>{
  db.AccountType.cash: 'Cash',
  db.AccountType.bank: 'Bank',
  db.AccountType.creditCard: 'Credit card',
  db.AccountType.wallet: 'Wallet',
  db.AccountType.investment: 'Investment',
  db.AccountType.loan: 'Loan',
  db.AccountType.other: 'Other',
};

/// The Add Account screen — **UI only**.
///
/// Collects a name, a type, and an opening balance, and validates them. It does
/// **not** save: Continue runs the form's validators and, on success, acknowledges
/// with the `comingSoon` snackbar. The real insert into SQLite and the return to the
/// Accounts screen are the next task. No repository, DAO, provider, currency, or
/// navigation-after-save is present here.
///
/// ## Reused, not rebuilt
///
/// The fields use `AddTransactionFieldStyle` — the shared, rounded, filled input
/// decoration from the add-transaction form — so this screen looks like the same
/// app, not a second form dialect. That does import one feature into another
/// (accounts → add_transaction), which is a coupling I would rather not have: the
/// style's real home is `AppTheme.inputDecorationTheme` (flagged since Task 005),
/// and moving it there deletes the shared class and the cross-feature import at
/// once. Until then, "reuse existing form widgets" means importing it. Flagged, not
/// hidden.
class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  /// Narrow, matching the add-transaction form. A form is read down one column; a
  /// field stretched to the 720 the dashboard uses puts its label a hand's width
  /// from its content.
  static const double _maxContentWidth = 560;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Owned here so the fields survive a rebuild without losing the cursor.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  /// Defaults to the first, most neutral kind, so the type is always set and needs
  /// no validator — a picker the user can leave alone and still be valid.
  db.AccountType _type = db.AccountType.cash;

  /// Digits and at most one decimal point — the same rule the amount field uses, so
  /// "1.2.3" can never be typed and then silently fail to parse.
  static final RegExp _numeric = RegExp(r'^\d*\.?\d*$');

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  /// Continue: **validate only**.
  ///
  /// Runs the form's validators — which is what the brief means by "it validates the
  /// form" — surfacing the required / numeric messages inline. On success it does
  /// not save (that is the next task); it acknowledges with `comingSoon` so the
  /// button is not a control that swallows a tap. The validated values are right
  /// here for that next task: `_nameController.text.trim()`, `_type`, and
  /// `double.parse(_balanceController.text.trim())`.
  void _onContinue() {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(AddAccountCopy.comingSoon),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  /// Cancel: leave the screen.
  ///
  /// `Navigator.maybePop` is framework-native, so it works however the screen ends
  /// up being presented once the next task gives it a route — pushed by GoRouter or
  /// by a plain `Navigator`, this pops either. The app's convention is GoRouter's
  /// `context.pop()`; this can switch to it when the route is wired.
  void _onCancel() {
    Navigator.of(context).maybePop();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AddAccountCopy.nameRequired;
    }
    return null;
  }

  String? _validateBalance(String? value) {
    final String trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return AddAccountCopy.balanceRequired;
    }
    if (double.tryParse(trimmed) == null) {
      return AddAccountCopy.balanceNotNumeric;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AddAccountCopy.title)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double gutter = AppSpacing.screenGutter(constraints.maxWidth);

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      gutter,
                      AppSpacing.lg,
                      gutter,
                      AppSpacing.x2l,
                    ),
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: AddTransactionFieldStyle.build(
                          context,
                          labelText: AddAccountCopy.nameLabel,
                          hintText: AddAccountCopy.nameHint,
                        ),
                        validator: _validateName,
                      ),
                      AppSpacing.gapV16,

                      _AccountTypeField(
                        value: _type,
                        onChanged: (db.AccountType next) =>
                            setState(() => _type = next),
                      ),
                      AppSpacing.gapV16,

                      TextFormField(
                        controller: _balanceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                          TextInputFormatter.withFunction(
                            (TextEditingValue oldValue,
                                TextEditingValue newValue) {
                              if (newValue.text.isEmpty) {
                                return newValue;
                              }
                              return _numeric.hasMatch(newValue.text)
                                  ? newValue
                                  : oldValue;
                            },
                          ),
                        ],
                        decoration: AddTransactionFieldStyle.build(
                          context,
                          labelText: AddAccountCopy.balanceLabel,
                          hintText: AddAccountCopy.balanceHint,
                        ),
                        validator: _validateBalance,
                      ),
                      AppSpacing.gapV32,

                      Row(
                        children: <Widget>[
                          Expanded(child: _CancelButton(onPressed: _onCancel)),
                          AppSpacing.gapH12,
                          Expanded(
                            child: _ContinueButton(onPressed: _onContinue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// The account-type picker.
///
/// Built from `InputDecorator` + `DropdownButton`, the same construction as the
/// add-transaction `AccountSelector` — a dropdown rather than a segmented control
/// because seven types will not fit across a phone. Fully driven by [value]; it
/// keeps no private copy of the selection to drift from the form's state.
class _AccountTypeField extends StatelessWidget {
  const _AccountTypeField({required this.value, required this.onChanged});

  final db.AccountType value;
  final ValueChanged<db.AccountType> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InputDecorator(
      decoration: AddTransactionFieldStyle.build(
        context,
        labelText: AddAccountCopy.typeLabel,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<db.AccountType>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          items: <DropdownMenuItem<db.AccountType>>[
            for (final db.AccountType type in db.AccountType.values)
              DropdownMenuItem<db.AccountType>(
                value: type,
                child: Text(
                  _accountTypeLabels[type]!,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
          ],
          onChanged: (db.AccountType? next) {
            if (next != null) {
              onChanged(next);
            }
          },
        ),
      ),
    );
  }
}

/// Secondary action. Outlined, so the filled Continue beside it is unmistakably the
/// primary — two filled buttons would be two competing primaries.
class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderMd,
          ),
        ),
        child: const Text(AddAccountCopy.cancel),
      ),
    );
  }
}

/// Primary action. Mirrors `SaveButton`'s styling (filled, 52 tall, rounded
/// `borderMd`) rather than reusing it, because this screen's footer is a two-button
/// row and `SaveButton` is shaped as a single full-width action. Always enabled:
/// Continue validates *on press*, so the errors it can surface are the reason to
/// press it.
class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderMd,
          ),
          textStyle: theme.textTheme.labelLarge,
        ),
        child: const Text(AddAccountCopy.continueLabel),
      ),
    );
  }
}
