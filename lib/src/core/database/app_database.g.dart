// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decimalDigitsMeta = const VerificationMeta(
    'decimalDigits',
  );
  @override
  late final GeneratedColumn<int> decimalDigits = GeneratedColumn<int>(
    'decimal_digits',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _isBaseCurrencyMeta = const VerificationMeta(
    'isBaseCurrency',
  );
  @override
  late final GeneratedColumn<bool> isBaseCurrency = GeneratedColumn<bool>(
    'is_base_currency',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_base_currency" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    symbol,
    decimalDigits,
    isBaseCurrency,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Currency> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('decimal_digits')) {
      context.handle(
        _decimalDigitsMeta,
        decimalDigits.isAcceptableOrUnknown(
          data['decimal_digits']!,
          _decimalDigitsMeta,
        ),
      );
    }
    if (data.containsKey('is_base_currency')) {
      context.handle(
        _isBaseCurrencyMeta,
        isBaseCurrency.isAcceptableOrUnknown(
          data['is_base_currency']!,
          _isBaseCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      code:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}code'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      symbol:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}symbol'],
          )!,
      decimalDigits:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}decimal_digits'],
          )!,
      isBaseCurrency:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_base_currency'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  /// Client-generated UUID. See `Accounts` for why every id in this schema is a
  /// text UUID rather than an autoincrementing integer.
  final String id;

  /// ISO 4217 where one exists ('USD', 'EGP'), or a longer token for assets that
  /// have no ISO code ('BTC', 'XAU'). Unique — see [customConstraints].
  final String code;

  /// Human name: 'US Dollar', 'Egyptian Pound'. Display text; the app may localize
  /// it, but the row stores one canonical name.
  final String name;

  /// What to print beside an amount: '$', 'ج.م', '₿'.
  final String symbol;

  /// How many minor units make one major unit — 2 for USD/EGP, 0 for JPY, 8 for
  /// BTC. This is the exponent that gives every amount in `currencyId`-bearing
  /// tables its scale. See `database_constants.dart`.
  final int decimalDigits;

  /// The single reporting currency everything is converted *to* for totals and
  /// net-worth. Exactly one row should have this true; enforcing "exactly one" is a
  /// service-layer rule, not a column constraint, because SQLite cannot express
  /// "at most one true".
  final bool isBaseCurrency;

  /// Whether the currency is offered in pickers. Currencies are **deactivated,
  /// never deleted** — a retired currency still has historical transactions
  /// pointing at it, and deleting it would orphan them.
  final bool isActive;
  const Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.decimalDigits,
    required this.isBaseCurrency,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['symbol'] = Variable<String>(symbol);
    map['decimal_digits'] = Variable<int>(decimalDigits);
    map['is_base_currency'] = Variable<bool>(isBaseCurrency);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      symbol: Value(symbol),
      decimalDigits: Value(decimalDigits),
      isBaseCurrency: Value(isBaseCurrency),
      isActive: Value(isActive),
    );
  }

  factory Currency.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String>(json['symbol']),
      decimalDigits: serializer.fromJson<int>(json['decimalDigits']),
      isBaseCurrency: serializer.fromJson<bool>(json['isBaseCurrency']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String>(symbol),
      'decimalDigits': serializer.toJson<int>(decimalDigits),
      'isBaseCurrency': serializer.toJson<bool>(isBaseCurrency),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Currency copyWith({
    String? id,
    String? code,
    String? name,
    String? symbol,
    int? decimalDigits,
    bool? isBaseCurrency,
    bool? isActive,
  }) => Currency(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    symbol: symbol ?? this.symbol,
    decimalDigits: decimalDigits ?? this.decimalDigits,
    isBaseCurrency: isBaseCurrency ?? this.isBaseCurrency,
    isActive: isActive ?? this.isActive,
  );
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      decimalDigits:
          data.decimalDigits.present
              ? data.decimalDigits.value
              : this.decimalDigits,
      isBaseCurrency:
          data.isBaseCurrency.present
              ? data.isBaseCurrency.value
              : this.isBaseCurrency,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('decimalDigits: $decimalDigits, ')
          ..write('isBaseCurrency: $isBaseCurrency, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    symbol,
    decimalDigits,
    isBaseCurrency,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.decimalDigits == this.decimalDigits &&
          other.isBaseCurrency == this.isBaseCurrency &&
          other.isActive == this.isActive);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> symbol;
  final Value<int> decimalDigits;
  final Value<bool> isBaseCurrency;
  final Value<bool> isActive;
  final Value<int> rowid;
  const CurrenciesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.decimalDigits = const Value.absent(),
    this.isBaseCurrency = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    required String id,
    required String code,
    required String name,
    required String symbol,
    this.decimalDigits = const Value.absent(),
    this.isBaseCurrency = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       symbol = Value(symbol);
  static Insertable<Currency> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<int>? decimalDigits,
    Expression<bool>? isBaseCurrency,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (decimalDigits != null) 'decimal_digits': decimalDigits,
      if (isBaseCurrency != null) 'is_base_currency': isBaseCurrency,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrenciesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String>? symbol,
    Value<int>? decimalDigits,
    Value<bool>? isBaseCurrency,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return CurrenciesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      decimalDigits: decimalDigits ?? this.decimalDigits,
      isBaseCurrency: isBaseCurrency ?? this.isBaseCurrency,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (decimalDigits.present) {
      map['decimal_digits'] = Variable<int>(decimalDigits.value);
    }
    if (isBaseCurrency.present) {
      map['is_base_currency'] = Variable<bool>(isBaseCurrency.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('decimalDigits: $decimalDigits, ')
          ..write('isBaseCurrency: $isBaseCurrency, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromCurrencyIdMeta = const VerificationMeta(
    'fromCurrencyId',
  );
  @override
  late final GeneratedColumn<String> fromCurrencyId = GeneratedColumn<String>(
    'from_currency_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES currencies (id)',
    ),
  );
  static const VerificationMeta _toCurrencyIdMeta = const VerificationMeta(
    'toCurrencyId',
  );
  @override
  late final GeneratedColumn<String> toCurrencyId = GeneratedColumn<String>(
    'to_currency_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES currencies (id)',
    ),
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<int> rate = GeneratedColumn<int>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveDate =
      GeneratedColumn<DateTime>(
        'effective_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromCurrencyId,
    toCurrencyId,
    rate,
    effectiveDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_currency_id')) {
      context.handle(
        _fromCurrencyIdMeta,
        fromCurrencyId.isAcceptableOrUnknown(
          data['from_currency_id']!,
          _fromCurrencyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromCurrencyIdMeta);
    }
    if (data.containsKey('to_currency_id')) {
      context.handle(
        _toCurrencyIdMeta,
        toCurrencyId.isAcceptableOrUnknown(
          data['to_currency_id']!,
          _toCurrencyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toCurrencyIdMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRate(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      fromCurrencyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}from_currency_id'],
          )!,
      toCurrencyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}to_currency_id'],
          )!,
      rate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}rate'],
          )!,
      effectiveDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}effective_date'],
          )!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRate extends DataClass implements Insertable<ExchangeRate> {
  final String id;

  /// The base of the quote. **Renamed** from the brief's `fromCurrency` to
  /// `fromCurrencyId` so every foreign key in the schema reads the same way — it
  /// holds a currency *id*, not a currency. Consistency with `Account.currencyId`
  /// et al.
  final String fromCurrencyId;

  /// The quote counter-currency. Renamed from `toCurrency`, same reasoning.
  final String toCurrencyId;

  /// Fixed-point: the real rate times `kFixedPointScale` (1e8). `30.85` is stored
  /// as `3_085_000_000`. See `database_constants.dart` for why rates are integers.
  final int rate;

  /// When this rate became effective. The newest row for a currency pair is the one
  /// in force.
  final DateTime effectiveDate;
  const ExchangeRate({
    required this.id,
    required this.fromCurrencyId,
    required this.toCurrencyId,
    required this.rate,
    required this.effectiveDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_currency_id'] = Variable<String>(fromCurrencyId);
    map['to_currency_id'] = Variable<String>(toCurrencyId);
    map['rate'] = Variable<int>(rate);
    map['effective_date'] = Variable<DateTime>(effectiveDate);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      fromCurrencyId: Value(fromCurrencyId),
      toCurrencyId: Value(toCurrencyId),
      rate: Value(rate),
      effectiveDate: Value(effectiveDate),
    );
  }

  factory ExchangeRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRate(
      id: serializer.fromJson<String>(json['id']),
      fromCurrencyId: serializer.fromJson<String>(json['fromCurrencyId']),
      toCurrencyId: serializer.fromJson<String>(json['toCurrencyId']),
      rate: serializer.fromJson<int>(json['rate']),
      effectiveDate: serializer.fromJson<DateTime>(json['effectiveDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromCurrencyId': serializer.toJson<String>(fromCurrencyId),
      'toCurrencyId': serializer.toJson<String>(toCurrencyId),
      'rate': serializer.toJson<int>(rate),
      'effectiveDate': serializer.toJson<DateTime>(effectiveDate),
    };
  }

  ExchangeRate copyWith({
    String? id,
    String? fromCurrencyId,
    String? toCurrencyId,
    int? rate,
    DateTime? effectiveDate,
  }) => ExchangeRate(
    id: id ?? this.id,
    fromCurrencyId: fromCurrencyId ?? this.fromCurrencyId,
    toCurrencyId: toCurrencyId ?? this.toCurrencyId,
    rate: rate ?? this.rate,
    effectiveDate: effectiveDate ?? this.effectiveDate,
  );
  ExchangeRate copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRate(
      id: data.id.present ? data.id.value : this.id,
      fromCurrencyId:
          data.fromCurrencyId.present
              ? data.fromCurrencyId.value
              : this.fromCurrencyId,
      toCurrencyId:
          data.toCurrencyId.present
              ? data.toCurrencyId.value
              : this.toCurrencyId,
      rate: data.rate.present ? data.rate.value : this.rate,
      effectiveDate:
          data.effectiveDate.present
              ? data.effectiveDate.value
              : this.effectiveDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRate(')
          ..write('id: $id, ')
          ..write('fromCurrencyId: $fromCurrencyId, ')
          ..write('toCurrencyId: $toCurrencyId, ')
          ..write('rate: $rate, ')
          ..write('effectiveDate: $effectiveDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fromCurrencyId, toCurrencyId, rate, effectiveDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRate &&
          other.id == this.id &&
          other.fromCurrencyId == this.fromCurrencyId &&
          other.toCurrencyId == this.toCurrencyId &&
          other.rate == this.rate &&
          other.effectiveDate == this.effectiveDate);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRate> {
  final Value<String> id;
  final Value<String> fromCurrencyId;
  final Value<String> toCurrencyId;
  final Value<int> rate;
  final Value<DateTime> effectiveDate;
  final Value<int> rowid;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.fromCurrencyId = const Value.absent(),
    this.toCurrencyId = const Value.absent(),
    this.rate = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    required String id,
    required String fromCurrencyId,
    required String toCurrencyId,
    required int rate,
    required DateTime effectiveDate,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fromCurrencyId = Value(fromCurrencyId),
       toCurrencyId = Value(toCurrencyId),
       rate = Value(rate),
       effectiveDate = Value(effectiveDate);
  static Insertable<ExchangeRate> custom({
    Expression<String>? id,
    Expression<String>? fromCurrencyId,
    Expression<String>? toCurrencyId,
    Expression<int>? rate,
    Expression<DateTime>? effectiveDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromCurrencyId != null) 'from_currency_id': fromCurrencyId,
      if (toCurrencyId != null) 'to_currency_id': toCurrencyId,
      if (rate != null) 'rate': rate,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRatesCompanion copyWith({
    Value<String>? id,
    Value<String>? fromCurrencyId,
    Value<String>? toCurrencyId,
    Value<int>? rate,
    Value<DateTime>? effectiveDate,
    Value<int>? rowid,
  }) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      fromCurrencyId: fromCurrencyId ?? this.fromCurrencyId,
      toCurrencyId: toCurrencyId ?? this.toCurrencyId,
      rate: rate ?? this.rate,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromCurrencyId.present) {
      map['from_currency_id'] = Variable<String>(fromCurrencyId.value);
    }
    if (toCurrencyId.present) {
      map['to_currency_id'] = Variable<String>(toCurrencyId.value);
    }
    if (rate.present) {
      map['rate'] = Variable<int>(rate.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<DateTime>(effectiveDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('fromCurrencyId: $fromCurrencyId, ')
          ..write('toCurrencyId: $toCurrencyId, ')
          ..write('rate: $rate, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PortfoliosTable extends Portfolios
    with TableInfo<$PortfoliosTable, Portfolio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PortfoliosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyIdMeta = const VerificationMeta(
    'currencyId',
  );
  @override
  late final GeneratedColumn<String> currencyId = GeneratedColumn<String>(
    'currency_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES currencies (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, currencyId, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'portfolios';
  @override
  VerificationContext validateIntegrity(
    Insertable<Portfolio> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency_id')) {
      context.handle(
        _currencyIdMeta,
        currencyId.isAcceptableOrUnknown(data['currency_id']!, _currencyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Portfolio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Portfolio(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      currencyId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}currency_id'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $PortfoliosTable createAlias(String alias) {
    return $PortfoliosTable(attachedDatabase, alias);
  }
}

class Portfolio extends DataClass implements Insertable<Portfolio> {
  /// Client-generated UUID. See `Accounts` for the id convention.
  final String id;

  /// The user's label for the grouping.
  final String name;

  /// The portfolio's reporting currency — what its total is expressed in when its
  /// assets span several currencies. The assets keep their own currencies; this is
  /// the lens the portfolio is summed through.
  final String currencyId;

  /// Optional free text. Nullable because most portfolios need no description, and
  /// an empty string and "no description" should not be two different states.
  final String? description;
  const Portfolio({
    required this.id,
    required this.name,
    required this.currencyId,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['currency_id'] = Variable<String>(currencyId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  PortfoliosCompanion toCompanion(bool nullToAbsent) {
    return PortfoliosCompanion(
      id: Value(id),
      name: Value(name),
      currencyId: Value(currencyId),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
    );
  }

  factory Portfolio.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Portfolio(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      currencyId: serializer.fromJson<String>(json['currencyId']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'currencyId': serializer.toJson<String>(currencyId),
      'description': serializer.toJson<String?>(description),
    };
  }

  Portfolio copyWith({
    String? id,
    String? name,
    String? currencyId,
    Value<String?> description = const Value.absent(),
  }) => Portfolio(
    id: id ?? this.id,
    name: name ?? this.name,
    currencyId: currencyId ?? this.currencyId,
    description: description.present ? description.value : this.description,
  );
  Portfolio copyWithCompanion(PortfoliosCompanion data) {
    return Portfolio(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Portfolio(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, currencyId, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Portfolio &&
          other.id == this.id &&
          other.name == this.name &&
          other.currencyId == this.currencyId &&
          other.description == this.description);
}

class PortfoliosCompanion extends UpdateCompanion<Portfolio> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> currencyId;
  final Value<String?> description;
  final Value<int> rowid;
  const PortfoliosCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PortfoliosCompanion.insert({
    required String id,
    required String name,
    required String currencyId,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       currencyId = Value(currencyId);
  static Insertable<Portfolio> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? currencyId,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (currencyId != null) 'currency_id': currencyId,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PortfoliosCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? currencyId,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return PortfoliosCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyId: currencyId ?? this.currencyId,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<String>(currencyId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PortfoliosCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyId: $currencyId, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final $PortfoliosTable portfolios = $PortfoliosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    currencies,
    exchangeRates,
    portfolios,
  ];
}

typedef $$CurrenciesTableCreateCompanionBuilder =
    CurrenciesCompanion Function({
      required String id,
      required String code,
      required String name,
      required String symbol,
      Value<int> decimalDigits,
      Value<bool> isBaseCurrency,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$CurrenciesTableUpdateCompanionBuilder =
    CurrenciesCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<String> symbol,
      Value<int> decimalDigits,
      Value<bool> isBaseCurrency,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$CurrenciesTableReferences
    extends BaseReferences<_$AppDatabase, $CurrenciesTable, Currency> {
  $$CurrenciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PortfoliosTable, List<Portfolio>>
  _portfoliosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.portfolios,
    aliasName: 'currencies__id__portfolios__currency_id',
  );

  $$PortfoliosTableProcessedTableManager get portfoliosRefs {
    final manager = $$PortfoliosTableTableManager(
      $_db,
      $_db.portfolios,
    ).filter((f) => f.currencyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_portfoliosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CurrenciesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get decimalDigits => $composableBuilder(
    column: $table.decimalDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBaseCurrency => $composableBuilder(
    column: $table.isBaseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> portfoliosRefs(
    Expression<bool> Function($$PortfoliosTableFilterComposer f) f,
  ) {
    final $$PortfoliosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.portfolios,
      getReferencedColumn: (t) => t.currencyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PortfoliosTableFilterComposer(
            $db: $db,
            $table: $db.portfolios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get decimalDigits => $composableBuilder(
    column: $table.decimalDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBaseCurrency => $composableBuilder(
    column: $table.isBaseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<int> get decimalDigits => $composableBuilder(
    column: $table.decimalDigits,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBaseCurrency => $composableBuilder(
    column: $table.isBaseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> portfoliosRefs<T extends Object>(
    Expression<T> Function($$PortfoliosTableAnnotationComposer a) f,
  ) {
    final $$PortfoliosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.portfolios,
      getReferencedColumn: (t) => t.currencyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PortfoliosTableAnnotationComposer(
            $db: $db,
            $table: $db.portfolios,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CurrenciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurrenciesTable,
          Currency,
          $$CurrenciesTableFilterComposer,
          $$CurrenciesTableOrderingComposer,
          $$CurrenciesTableAnnotationComposer,
          $$CurrenciesTableCreateCompanionBuilder,
          $$CurrenciesTableUpdateCompanionBuilder,
          (Currency, $$CurrenciesTableReferences),
          Currency,
          PrefetchHooks Function({bool portfoliosRefs})
        > {
  $$CurrenciesTableTableManager(_$AppDatabase db, $CurrenciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<int> decimalDigits = const Value.absent(),
                Value<bool> isBaseCurrency = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurrenciesCompanion(
                id: id,
                code: code,
                name: name,
                symbol: symbol,
                decimalDigits: decimalDigits,
                isBaseCurrency: isBaseCurrency,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required String symbol,
                Value<int> decimalDigits = const Value.absent(),
                Value<bool> isBaseCurrency = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurrenciesCompanion.insert(
                id: id,
                code: code,
                name: name,
                symbol: symbol,
                decimalDigits: decimalDigits,
                isBaseCurrency: isBaseCurrency,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CurrenciesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({portfoliosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (portfoliosRefs) db.portfolios],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (portfoliosRefs)
                    await $_getPrefetchedData<
                      Currency,
                      $CurrenciesTable,
                      Portfolio
                    >(
                      currentTable: table,
                      referencedTable: $$CurrenciesTableReferences
                          ._portfoliosRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CurrenciesTableReferences(
                                db,
                                table,
                                p0,
                              ).portfoliosRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.currencyId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CurrenciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurrenciesTable,
      Currency,
      $$CurrenciesTableFilterComposer,
      $$CurrenciesTableOrderingComposer,
      $$CurrenciesTableAnnotationComposer,
      $$CurrenciesTableCreateCompanionBuilder,
      $$CurrenciesTableUpdateCompanionBuilder,
      (Currency, $$CurrenciesTableReferences),
      Currency,
      PrefetchHooks Function({bool portfoliosRefs})
    >;
typedef $$ExchangeRatesTableCreateCompanionBuilder =
    ExchangeRatesCompanion Function({
      required String id,
      required String fromCurrencyId,
      required String toCurrencyId,
      required int rate,
      required DateTime effectiveDate,
      Value<int> rowid,
    });
typedef $$ExchangeRatesTableUpdateCompanionBuilder =
    ExchangeRatesCompanion Function({
      Value<String> id,
      Value<String> fromCurrencyId,
      Value<String> toCurrencyId,
      Value<int> rate,
      Value<DateTime> effectiveDate,
      Value<int> rowid,
    });

final class $$ExchangeRatesTableReferences
    extends BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRate> {
  $$ExchangeRatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CurrenciesTable _fromCurrencyIdTable(_$AppDatabase db) => db
      .currencies
      .createAlias('exchange_rates__from_currency_id__currencies__id');

  $$CurrenciesTableProcessedTableManager get fromCurrencyId {
    final $_column = $_itemColumn<String>('from_currency_id')!;

    final manager = $$CurrenciesTableTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromCurrencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CurrenciesTable _toCurrencyIdTable(_$AppDatabase db) => db.currencies
      .createAlias('exchange_rates__to_currency_id__currencies__id');

  $$CurrenciesTableProcessedTableManager get toCurrencyId {
    final $_column = $_itemColumn<String>('to_currency_id')!;

    final manager = $$CurrenciesTableTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toCurrencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  $$CurrenciesTableFilterComposer get fromCurrencyId {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromCurrencyId,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurrenciesTableFilterComposer get toCurrencyId {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toCurrencyId,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$CurrenciesTableOrderingComposer get fromCurrencyId {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromCurrencyId,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurrenciesTableOrderingComposer get toCurrencyId {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toCurrencyId,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  $$CurrenciesTableAnnotationComposer get fromCurrencyId {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromCurrencyId,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get toCurrencyId {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toCurrencyId,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExchangeRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExchangeRatesTable,
          ExchangeRate,
          $$ExchangeRatesTableFilterComposer,
          $$ExchangeRatesTableOrderingComposer,
          $$ExchangeRatesTableAnnotationComposer,
          $$ExchangeRatesTableCreateCompanionBuilder,
          $$ExchangeRatesTableUpdateCompanionBuilder,
          (ExchangeRate, $$ExchangeRatesTableReferences),
          ExchangeRate,
          PrefetchHooks Function({bool fromCurrencyId, bool toCurrencyId})
        > {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ExchangeRatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fromCurrencyId = const Value.absent(),
                Value<String> toCurrencyId = const Value.absent(),
                Value<int> rate = const Value.absent(),
                Value<DateTime> effectiveDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExchangeRatesCompanion(
                id: id,
                fromCurrencyId: fromCurrencyId,
                toCurrencyId: toCurrencyId,
                rate: rate,
                effectiveDate: effectiveDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fromCurrencyId,
                required String toCurrencyId,
                required int rate,
                required DateTime effectiveDate,
                Value<int> rowid = const Value.absent(),
              }) => ExchangeRatesCompanion.insert(
                id: id,
                fromCurrencyId: fromCurrencyId,
                toCurrencyId: toCurrencyId,
                rate: rate,
                effectiveDate: effectiveDate,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ExchangeRatesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            fromCurrencyId = false,
            toCurrencyId = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (fromCurrencyId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.fromCurrencyId,
                            referencedTable: $$ExchangeRatesTableReferences
                                ._fromCurrencyIdTable(db),
                            referencedColumn:
                                $$ExchangeRatesTableReferences
                                    ._fromCurrencyIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (toCurrencyId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.toCurrencyId,
                            referencedTable: $$ExchangeRatesTableReferences
                                ._toCurrencyIdTable(db),
                            referencedColumn:
                                $$ExchangeRatesTableReferences
                                    ._toCurrencyIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExchangeRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExchangeRatesTable,
      ExchangeRate,
      $$ExchangeRatesTableFilterComposer,
      $$ExchangeRatesTableOrderingComposer,
      $$ExchangeRatesTableAnnotationComposer,
      $$ExchangeRatesTableCreateCompanionBuilder,
      $$ExchangeRatesTableUpdateCompanionBuilder,
      (ExchangeRate, $$ExchangeRatesTableReferences),
      ExchangeRate,
      PrefetchHooks Function({bool fromCurrencyId, bool toCurrencyId})
    >;
typedef $$PortfoliosTableCreateCompanionBuilder =
    PortfoliosCompanion Function({
      required String id,
      required String name,
      required String currencyId,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$PortfoliosTableUpdateCompanionBuilder =
    PortfoliosCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> currencyId,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$PortfoliosTableReferences
    extends BaseReferences<_$AppDatabase, $PortfoliosTable, Portfolio> {
  $$PortfoliosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CurrenciesTable _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias('portfolios__currency_id__currencies__id');

  $$CurrenciesTableProcessedTableManager get currencyId {
    final $_column = $_itemColumn<String>('currency_id')!;

    final manager = $$CurrenciesTableTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PortfoliosTableFilterComposer
    extends Composer<_$AppDatabase, $PortfoliosTable> {
  $$PortfoliosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$CurrenciesTableFilterComposer get currencyId {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currencyId,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PortfoliosTableOrderingComposer
    extends Composer<_$AppDatabase, $PortfoliosTable> {
  $$PortfoliosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$CurrenciesTableOrderingComposer get currencyId {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currencyId,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PortfoliosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PortfoliosTable> {
  $$PortfoliosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$CurrenciesTableAnnotationComposer get currencyId {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currencyId,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CurrenciesTableAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PortfoliosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PortfoliosTable,
          Portfolio,
          $$PortfoliosTableFilterComposer,
          $$PortfoliosTableOrderingComposer,
          $$PortfoliosTableAnnotationComposer,
          $$PortfoliosTableCreateCompanionBuilder,
          $$PortfoliosTableUpdateCompanionBuilder,
          (Portfolio, $$PortfoliosTableReferences),
          Portfolio,
          PrefetchHooks Function({bool currencyId})
        > {
  $$PortfoliosTableTableManager(_$AppDatabase db, $PortfoliosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PortfoliosTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PortfoliosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PortfoliosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> currencyId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PortfoliosCompanion(
                id: id,
                name: name,
                currencyId: currencyId,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String currencyId,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PortfoliosCompanion.insert(
                id: id,
                name: name,
                currencyId: currencyId,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PortfoliosTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({currencyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (currencyId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.currencyId,
                            referencedTable: $$PortfoliosTableReferences
                                ._currencyIdTable(db),
                            referencedColumn:
                                $$PortfoliosTableReferences
                                    ._currencyIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PortfoliosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PortfoliosTable,
      Portfolio,
      $$PortfoliosTableFilterComposer,
      $$PortfoliosTableOrderingComposer,
      $$PortfoliosTableAnnotationComposer,
      $$PortfoliosTableCreateCompanionBuilder,
      $$PortfoliosTableUpdateCompanionBuilder,
      (Portfolio, $$PortfoliosTableReferences),
      Portfolio,
      PrefetchHooks Function({bool currencyId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
  $$PortfoliosTableTableManager get portfolios =>
      $$PortfoliosTableTableManager(_db, _db.portfolios);
}
