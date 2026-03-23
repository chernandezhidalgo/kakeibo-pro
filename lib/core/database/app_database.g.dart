// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EnvelopesTableTable extends EnvelopesTable
    with TableInfo<$EnvelopesTableTable, EnvelopesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
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
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetedAmountMeta = const VerificationMeta(
    'budgetedAmount',
  );
  @override
  late final GeneratedColumn<double> budgetedAmount = GeneratedColumn<double>(
    'budgeted_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _spentAmountMeta = const VerificationMeta(
    'spentAmount',
  );
  @override
  late final GeneratedColumn<double> spentAmount = GeneratedColumn<double>(
    'spent_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 3),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('CRC'),
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
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _iconCodeMeta = const VerificationMeta(
    'iconCode',
  );
  @override
  late final GeneratedColumn<String> iconCode = GeneratedColumn<String>(
    'icon_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _localStatusMeta = const VerificationMeta(
    'localStatus',
  );
  @override
  late final GeneratedColumn<String> localStatus = GeneratedColumn<String>(
    'local_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    name,
    category,
    budgetedAmount,
    spentAmount,
    currency,
    isActive,
    sortOrder,
    iconCode,
    colorHex,
    createdAt,
    updatedAt,
    isSynced,
    localStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelopes';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvelopesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('budgeted_amount')) {
      context.handle(
        _budgetedAmountMeta,
        budgetedAmount.isAcceptableOrUnknown(
          data['budgeted_amount']!,
          _budgetedAmountMeta,
        ),
      );
    }
    if (data.containsKey('spent_amount')) {
      context.handle(
        _spentAmountMeta,
        spentAmount.isAcceptableOrUnknown(
          data['spent_amount']!,
          _spentAmountMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('icon_code')) {
      context.handle(
        _iconCodeMeta,
        iconCode.isAcceptableOrUnknown(data['icon_code']!, _iconCodeMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('local_status')) {
      context.handle(
        _localStatusMeta,
        localStatus.isAcceptableOrUnknown(
          data['local_status']!,
          _localStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvelopesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvelopesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      budgetedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}budgeted_amount'],
      )!,
      spentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spent_amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      iconCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_code'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      localStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_status'],
      )!,
    );
  }

  @override
  $EnvelopesTableTable createAlias(String alias) {
    return $EnvelopesTableTable(attachedDatabase, alias);
  }
}

class EnvelopesTableData extends DataClass
    implements Insertable<EnvelopesTableData> {
  final String id;
  final String familyId;
  final String name;
  final String category;
  final double budgetedAmount;
  final double spentAmount;
  final String currency;
  final bool isActive;
  final int sortOrder;
  final String? iconCode;
  final String? colorHex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final String localStatus;
  const EnvelopesTableData({
    required this.id,
    required this.familyId,
    required this.name,
    required this.category,
    required this.budgetedAmount,
    required this.spentAmount,
    required this.currency,
    required this.isActive,
    required this.sortOrder,
    this.iconCode,
    this.colorHex,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    required this.localStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['budgeted_amount'] = Variable<double>(budgetedAmount);
    map['spent_amount'] = Variable<double>(spentAmount);
    map['currency'] = Variable<String>(currency);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || iconCode != null) {
      map['icon_code'] = Variable<String>(iconCode);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['local_status'] = Variable<String>(localStatus);
    return map;
  }

  EnvelopesTableCompanion toCompanion(bool nullToAbsent) {
    return EnvelopesTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      name: Value(name),
      category: Value(category),
      budgetedAmount: Value(budgetedAmount),
      spentAmount: Value(spentAmount),
      currency: Value(currency),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
      iconCode: iconCode == null && nullToAbsent
          ? const Value.absent()
          : Value(iconCode),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      localStatus: Value(localStatus),
    );
  }

  factory EnvelopesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvelopesTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      budgetedAmount: serializer.fromJson<double>(json['budgetedAmount']),
      spentAmount: serializer.fromJson<double>(json['spentAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      iconCode: serializer.fromJson<String?>(json['iconCode']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localStatus: serializer.fromJson<String>(json['localStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'budgetedAmount': serializer.toJson<double>(budgetedAmount),
      'spentAmount': serializer.toJson<double>(spentAmount),
      'currency': serializer.toJson<String>(currency),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'iconCode': serializer.toJson<String?>(iconCode),
      'colorHex': serializer.toJson<String?>(colorHex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localStatus': serializer.toJson<String>(localStatus),
    };
  }

  EnvelopesTableData copyWith({
    String? id,
    String? familyId,
    String? name,
    String? category,
    double? budgetedAmount,
    double? spentAmount,
    String? currency,
    bool? isActive,
    int? sortOrder,
    Value<String?> iconCode = const Value.absent(),
    Value<String?> colorHex = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    String? localStatus,
  }) => EnvelopesTableData(
    id: id ?? this.id,
    familyId: familyId ?? this.familyId,
    name: name ?? this.name,
    category: category ?? this.category,
    budgetedAmount: budgetedAmount ?? this.budgetedAmount,
    spentAmount: spentAmount ?? this.spentAmount,
    currency: currency ?? this.currency,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    iconCode: iconCode.present ? iconCode.value : this.iconCode,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    localStatus: localStatus ?? this.localStatus,
  );
  EnvelopesTableData copyWithCompanion(EnvelopesTableCompanion data) {
    return EnvelopesTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      budgetedAmount: data.budgetedAmount.present
          ? data.budgetedAmount.value
          : this.budgetedAmount,
      spentAmount: data.spentAmount.present
          ? data.spentAmount.value
          : this.spentAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      iconCode: data.iconCode.present ? data.iconCode.value : this.iconCode,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localStatus: data.localStatus.present
          ? data.localStatus.value
          : this.localStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopesTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('budgetedAmount: $budgetedAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('currency: $currency, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('iconCode: $iconCode, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localStatus: $localStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyId,
    name,
    category,
    budgetedAmount,
    spentAmount,
    currency,
    isActive,
    sortOrder,
    iconCode,
    colorHex,
    createdAt,
    updatedAt,
    isSynced,
    localStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvelopesTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.name == this.name &&
          other.category == this.category &&
          other.budgetedAmount == this.budgetedAmount &&
          other.spentAmount == this.spentAmount &&
          other.currency == this.currency &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder &&
          other.iconCode == this.iconCode &&
          other.colorHex == this.colorHex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.localStatus == this.localStatus);
}

class EnvelopesTableCompanion extends UpdateCompanion<EnvelopesTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> name;
  final Value<String> category;
  final Value<double> budgetedAmount;
  final Value<double> spentAmount;
  final Value<String> currency;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  final Value<String?> iconCode;
  final Value<String?> colorHex;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<String> localStatus;
  final Value<int> rowid;
  const EnvelopesTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.budgetedAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.iconCode = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnvelopesTableCompanion.insert({
    required String id,
    required String familyId,
    required String name,
    required String category,
    this.budgetedAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.iconCode = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyId = Value(familyId),
       name = Value(name),
       category = Value(category);
  static Insertable<EnvelopesTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? budgetedAmount,
    Expression<double>? spentAmount,
    Expression<String>? currency,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
    Expression<String>? iconCode,
    Expression<String>? colorHex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<String>? localStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (budgetedAmount != null) 'budgeted_amount': budgetedAmount,
      if (spentAmount != null) 'spent_amount': spentAmount,
      if (currency != null) 'currency': currency,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (iconCode != null) 'icon_code': iconCode,
      if (colorHex != null) 'color_hex': colorHex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localStatus != null) 'local_status': localStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnvelopesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? familyId,
    Value<String>? name,
    Value<String>? category,
    Value<double>? budgetedAmount,
    Value<double>? spentAmount,
    Value<String>? currency,
    Value<bool>? isActive,
    Value<int>? sortOrder,
    Value<String?>? iconCode,
    Value<String?>? colorHex,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<String>? localStatus,
    Value<int>? rowid,
  }) {
    return EnvelopesTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      category: category ?? this.category,
      budgetedAmount: budgetedAmount ?? this.budgetedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      iconCode: iconCode ?? this.iconCode,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      localStatus: localStatus ?? this.localStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (budgetedAmount.present) {
      map['budgeted_amount'] = Variable<double>(budgetedAmount.value);
    }
    if (spentAmount.present) {
      map['spent_amount'] = Variable<double>(spentAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (iconCode.present) {
      map['icon_code'] = Variable<String>(iconCode.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localStatus.present) {
      map['local_status'] = Variable<String>(localStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopesTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('budgetedAmount: $budgetedAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('currency: $currency, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('iconCode: $iconCode, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localStatus: $localStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
    'envelope_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByUserIdMeta = const VerificationMeta(
    'createdByUserId',
  );
  @override
  late final GeneratedColumn<String> createdByUserId = GeneratedColumn<String>(
    'created_by_user_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 3),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('CRC'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawSourceDataMeta = const VerificationMeta(
    'rawSourceData',
  );
  @override
  late final GeneratedColumn<String> rawSourceData = GeneratedColumn<String>(
    'raw_source_data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRecurringMeta = const VerificationMeta(
    'isRecurring',
  );
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
    'is_recurring',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_recurring" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _localStatusMeta = const VerificationMeta(
    'localStatus',
  );
  @override
  late final GeneratedColumn<String> localStatus = GeneratedColumn<String>(
    'local_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    envelopeId,
    createdByUserId,
    type,
    amount,
    currency,
    description,
    merchant,
    transactionDate,
    sourceType,
    rawSourceData,
    isRecurring,
    tags,
    createdAt,
    updatedAt,
    isSynced,
    localStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
        _createdByUserIdMeta,
        createdByUserId.isAcceptableOrUnknown(
          data['created_by_user_id']!,
          _createdByUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdByUserIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('raw_source_data')) {
      context.handle(
        _rawSourceDataMeta,
        rawSourceData.isAcceptableOrUnknown(
          data['raw_source_data']!,
          _rawSourceDataMeta,
        ),
      );
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
        _isRecurringMeta,
        isRecurring.isAcceptableOrUnknown(
          data['is_recurring']!,
          _isRecurringMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('local_status')) {
      context.handle(
        _localStatusMeta,
        localStatus.isAcceptableOrUnknown(
          data['local_status']!,
          _localStatusMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}envelope_id'],
      ),
      createdByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_user_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      ),
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      ),
      rawSourceData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_source_data'],
      ),
      isRecurring: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_recurring'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      localStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_status'],
      )!,
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final String id;
  final String familyId;
  final String? envelopeId;
  final String createdByUserId;
  final String type;
  final double amount;
  final String currency;
  final String description;
  final String? merchant;
  final DateTime transactionDate;
  final String? sourceType;
  final String? rawSourceData;
  final bool isRecurring;
  final String? tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  final String localStatus;
  const TransactionsTableData({
    required this.id,
    required this.familyId,
    this.envelopeId,
    required this.createdByUserId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    this.merchant,
    required this.transactionDate,
    this.sourceType,
    this.rawSourceData,
    required this.isRecurring,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    required this.localStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    if (!nullToAbsent || envelopeId != null) {
      map['envelope_id'] = Variable<String>(envelopeId);
    }
    map['created_by_user_id'] = Variable<String>(createdByUserId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || sourceType != null) {
      map['source_type'] = Variable<String>(sourceType);
    }
    if (!nullToAbsent || rawSourceData != null) {
      map['raw_source_data'] = Variable<String>(rawSourceData);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['local_status'] = Variable<String>(localStatus);
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      envelopeId: envelopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(envelopeId),
      createdByUserId: Value(createdByUserId),
      type: Value(type),
      amount: Value(amount),
      currency: Value(currency),
      description: Value(description),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      transactionDate: Value(transactionDate),
      sourceType: sourceType == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceType),
      rawSourceData: rawSourceData == null && nullToAbsent
          ? const Value.absent()
          : Value(rawSourceData),
      isRecurring: Value(isRecurring),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
      localStatus: Value(localStatus),
    );
  }

  factory TransactionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      envelopeId: serializer.fromJson<String?>(json['envelopeId']),
      createdByUserId: serializer.fromJson<String>(json['createdByUserId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      description: serializer.fromJson<String>(json['description']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      sourceType: serializer.fromJson<String?>(json['sourceType']),
      rawSourceData: serializer.fromJson<String?>(json['rawSourceData']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      tags: serializer.fromJson<String?>(json['tags']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      localStatus: serializer.fromJson<String>(json['localStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'envelopeId': serializer.toJson<String?>(envelopeId),
      'createdByUserId': serializer.toJson<String>(createdByUserId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'description': serializer.toJson<String>(description),
      'merchant': serializer.toJson<String?>(merchant),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'sourceType': serializer.toJson<String?>(sourceType),
      'rawSourceData': serializer.toJson<String?>(rawSourceData),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'tags': serializer.toJson<String?>(tags),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'localStatus': serializer.toJson<String>(localStatus),
    };
  }

  TransactionsTableData copyWith({
    String? id,
    String? familyId,
    Value<String?> envelopeId = const Value.absent(),
    String? createdByUserId,
    String? type,
    double? amount,
    String? currency,
    String? description,
    Value<String?> merchant = const Value.absent(),
    DateTime? transactionDate,
    Value<String?> sourceType = const Value.absent(),
    Value<String?> rawSourceData = const Value.absent(),
    bool? isRecurring,
    Value<String?> tags = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
    String? localStatus,
  }) => TransactionsTableData(
    id: id ?? this.id,
    familyId: familyId ?? this.familyId,
    envelopeId: envelopeId.present ? envelopeId.value : this.envelopeId,
    createdByUserId: createdByUserId ?? this.createdByUserId,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    description: description ?? this.description,
    merchant: merchant.present ? merchant.value : this.merchant,
    transactionDate: transactionDate ?? this.transactionDate,
    sourceType: sourceType.present ? sourceType.value : this.sourceType,
    rawSourceData: rawSourceData.present
        ? rawSourceData.value
        : this.rawSourceData,
    isRecurring: isRecurring ?? this.isRecurring,
    tags: tags.present ? tags.value : this.tags,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
    localStatus: localStatus ?? this.localStatus,
  );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      description: data.description.present
          ? data.description.value
          : this.description,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      rawSourceData: data.rawSourceData.present
          ? data.rawSourceData.value
          : this.rawSourceData,
      isRecurring: data.isRecurring.present
          ? data.isRecurring.value
          : this.isRecurring,
      tags: data.tags.present ? data.tags.value : this.tags,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      localStatus: data.localStatus.present
          ? data.localStatus.value
          : this.localStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('description: $description, ')
          ..write('merchant: $merchant, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('sourceType: $sourceType, ')
          ..write('rawSourceData: $rawSourceData, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localStatus: $localStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyId,
    envelopeId,
    createdByUserId,
    type,
    amount,
    currency,
    description,
    merchant,
    transactionDate,
    sourceType,
    rawSourceData,
    isRecurring,
    tags,
    createdAt,
    updatedAt,
    isSynced,
    localStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.envelopeId == this.envelopeId &&
          other.createdByUserId == this.createdByUserId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.description == this.description &&
          other.merchant == this.merchant &&
          other.transactionDate == this.transactionDate &&
          other.sourceType == this.sourceType &&
          other.rawSourceData == this.rawSourceData &&
          other.isRecurring == this.isRecurring &&
          other.tags == this.tags &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced &&
          other.localStatus == this.localStatus);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String?> envelopeId;
  final Value<String> createdByUserId;
  final Value<String> type;
  final Value<double> amount;
  final Value<String> currency;
  final Value<String> description;
  final Value<String?> merchant;
  final Value<DateTime> transactionDate;
  final Value<String?> sourceType;
  final Value<String?> rawSourceData;
  final Value<bool> isRecurring;
  final Value<String?> tags;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<String> localStatus;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.createdByUserId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.description = const Value.absent(),
    this.merchant = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.rawSourceData = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    required String familyId,
    this.envelopeId = const Value.absent(),
    required String createdByUserId,
    required String type,
    required double amount,
    this.currency = const Value.absent(),
    required String description,
    this.merchant = const Value.absent(),
    required DateTime transactionDate,
    this.sourceType = const Value.absent(),
    this.rawSourceData = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.tags = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.localStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyId = Value(familyId),
       createdByUserId = Value(createdByUserId),
       type = Value(type),
       amount = Value(amount),
       description = Value(description),
       transactionDate = Value(transactionDate);
  static Insertable<TransactionsTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? envelopeId,
    Expression<String>? createdByUserId,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<String>? description,
    Expression<String>? merchant,
    Expression<DateTime>? transactionDate,
    Expression<String>? sourceType,
    Expression<String>? rawSourceData,
    Expression<bool>? isRecurring,
    Expression<String>? tags,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<String>? localStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (description != null) 'description': description,
      if (merchant != null) 'merchant': merchant,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (sourceType != null) 'source_type': sourceType,
      if (rawSourceData != null) 'raw_source_data': rawSourceData,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (tags != null) 'tags': tags,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (localStatus != null) 'local_status': localStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? familyId,
    Value<String?>? envelopeId,
    Value<String>? createdByUserId,
    Value<String>? type,
    Value<double>? amount,
    Value<String>? currency,
    Value<String>? description,
    Value<String?>? merchant,
    Value<DateTime>? transactionDate,
    Value<String?>? sourceType,
    Value<String?>? rawSourceData,
    Value<bool>? isRecurring,
    Value<String?>? tags,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<String>? localStatus,
    Value<int>? rowid,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      envelopeId: envelopeId ?? this.envelopeId,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      merchant: merchant ?? this.merchant,
      transactionDate: transactionDate ?? this.transactionDate,
      sourceType: sourceType ?? this.sourceType,
      rawSourceData: rawSourceData ?? this.rawSourceData,
      isRecurring: isRecurring ?? this.isRecurring,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      localStatus: localStatus ?? this.localStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<String>(createdByUserId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (rawSourceData.present) {
      map['raw_source_data'] = Variable<String>(rawSourceData.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (localStatus.present) {
      map['local_status'] = Variable<String>(localStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('createdByUserId: $createdByUserId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('description: $description, ')
          ..write('merchant: $merchant, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('sourceType: $sourceType, ')
          ..write('rawSourceData: $rawSourceData, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('tags: $tags, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('localStatus: $localStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamilyMembersTableTable extends FamilyMembersTable
    with TableInfo<$FamilyMembersTableTable, FamilyMembersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyMembersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _joinedAtMeta = const VerificationMeta(
    'joinedAt',
  );
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
    'joined_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    userId,
    role,
    isActive,
    joinedAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyMembersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('joined_at')) {
      context.handle(
        _joinedAtMeta,
        joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyMembersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyMembersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      joinedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}joined_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $FamilyMembersTableTable createAlias(String alias) {
    return $FamilyMembersTableTable(attachedDatabase, alias);
  }
}

class FamilyMembersTableData extends DataClass
    implements Insertable<FamilyMembersTableData> {
  final String id;
  final String familyId;
  final String userId;
  final String role;
  final bool isActive;
  final DateTime joinedAt;
  final DateTime updatedAt;
  final bool isSynced;
  const FamilyMembersTableData({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.role,
    required this.isActive,
    required this.joinedAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    map['is_active'] = Variable<bool>(isActive);
    map['joined_at'] = Variable<DateTime>(joinedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  FamilyMembersTableCompanion toCompanion(bool nullToAbsent) {
    return FamilyMembersTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      userId: Value(userId),
      role: Value(role),
      isActive: Value(isActive),
      joinedAt: Value(joinedAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory FamilyMembersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyMembersTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      joinedAt: serializer.fromJson<DateTime>(json['joinedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'isActive': serializer.toJson<bool>(isActive),
      'joinedAt': serializer.toJson<DateTime>(joinedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  FamilyMembersTableData copyWith({
    String? id,
    String? familyId,
    String? userId,
    String? role,
    bool? isActive,
    DateTime? joinedAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => FamilyMembersTableData(
    id: id ?? this.id,
    familyId: familyId ?? this.familyId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    isActive: isActive ?? this.isActive,
    joinedAt: joinedAt ?? this.joinedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  FamilyMembersTableData copyWithCompanion(FamilyMembersTableCompanion data) {
    return FamilyMembersTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMembersTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyId,
    userId,
    role,
    isActive,
    joinedAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyMembersTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.isActive == this.isActive &&
          other.joinedAt == this.joinedAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class FamilyMembersTableCompanion
    extends UpdateCompanion<FamilyMembersTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> userId;
  final Value<String> role;
  final Value<bool> isActive;
  final Value<DateTime> joinedAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const FamilyMembersTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.isActive = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamilyMembersTableCompanion.insert({
    required String id,
    required String familyId,
    required String userId,
    required String role,
    this.isActive = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyId = Value(familyId),
       userId = Value(userId),
       role = Value(role);
  static Insertable<FamilyMembersTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<bool>? isActive,
    Expression<DateTime>? joinedAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (isActive != null) 'is_active': isActive,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamilyMembersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? familyId,
    Value<String>? userId,
    Value<String>? role,
    Value<bool>? isActive,
    Value<DateTime>? joinedAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return FamilyMembersTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      joinedAt: joinedAt ?? this.joinedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMembersTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KakeiboReflectionsTableTable extends KakeiboReflectionsTable
    with TableInfo<$KakeiboReflectionsTableTable, KakeiboReflectionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KakeiboReflectionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _familyIdMeta = const VerificationMeta(
    'familyId',
  );
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
    'family_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _incomeTotalMeta = const VerificationMeta(
    'incomeTotal',
  );
  @override
  late final GeneratedColumn<double> incomeTotal = GeneratedColumn<double>(
    'income_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _expenseTotalMeta = const VerificationMeta(
    'expenseTotal',
  );
  @override
  late final GeneratedColumn<double> expenseTotal = GeneratedColumn<double>(
    'expense_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _savingsTargetMeta = const VerificationMeta(
    'savingsTarget',
  );
  @override
  late final GeneratedColumn<double> savingsTarget = GeneratedColumn<double>(
    'savings_target',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _savingsActualMeta = const VerificationMeta(
    'savingsActual',
  );
  @override
  late final GeneratedColumn<double> savingsActual = GeneratedColumn<double>(
    'savings_actual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _questionHowMuchMeta = const VerificationMeta(
    'questionHowMuch',
  );
  @override
  late final GeneratedColumn<String> questionHowMuch = GeneratedColumn<String>(
    'question_how_much',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionSaveMeta = const VerificationMeta(
    'questionSave',
  );
  @override
  late final GeneratedColumn<String> questionSave = GeneratedColumn<String>(
    'question_save',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionSpentMeta = const VerificationMeta(
    'questionSpent',
  );
  @override
  late final GeneratedColumn<String> questionSpent = GeneratedColumn<String>(
    'question_spent',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionImproveMeta = const VerificationMeta(
    'questionImprove',
  );
  @override
  late final GeneratedColumn<String> questionImprove = GeneratedColumn<String>(
    'question_improve',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aiInsightMeta = const VerificationMeta(
    'aiInsight',
  );
  @override
  late final GeneratedColumn<String> aiInsight = GeneratedColumn<String>(
    'ai_insight',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    familyId,
    userId,
    year,
    month,
    incomeTotal,
    expenseTotal,
    savingsTarget,
    savingsActual,
    questionHowMuch,
    questionSave,
    questionSpent,
    questionImprove,
    aiInsight,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kakeibo_reflections';
  @override
  VerificationContext validateIntegrity(
    Insertable<KakeiboReflectionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(
        _familyIdMeta,
        familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('income_total')) {
      context.handle(
        _incomeTotalMeta,
        incomeTotal.isAcceptableOrUnknown(
          data['income_total']!,
          _incomeTotalMeta,
        ),
      );
    }
    if (data.containsKey('expense_total')) {
      context.handle(
        _expenseTotalMeta,
        expenseTotal.isAcceptableOrUnknown(
          data['expense_total']!,
          _expenseTotalMeta,
        ),
      );
    }
    if (data.containsKey('savings_target')) {
      context.handle(
        _savingsTargetMeta,
        savingsTarget.isAcceptableOrUnknown(
          data['savings_target']!,
          _savingsTargetMeta,
        ),
      );
    }
    if (data.containsKey('savings_actual')) {
      context.handle(
        _savingsActualMeta,
        savingsActual.isAcceptableOrUnknown(
          data['savings_actual']!,
          _savingsActualMeta,
        ),
      );
    }
    if (data.containsKey('question_how_much')) {
      context.handle(
        _questionHowMuchMeta,
        questionHowMuch.isAcceptableOrUnknown(
          data['question_how_much']!,
          _questionHowMuchMeta,
        ),
      );
    }
    if (data.containsKey('question_save')) {
      context.handle(
        _questionSaveMeta,
        questionSave.isAcceptableOrUnknown(
          data['question_save']!,
          _questionSaveMeta,
        ),
      );
    }
    if (data.containsKey('question_spent')) {
      context.handle(
        _questionSpentMeta,
        questionSpent.isAcceptableOrUnknown(
          data['question_spent']!,
          _questionSpentMeta,
        ),
      );
    }
    if (data.containsKey('question_improve')) {
      context.handle(
        _questionImproveMeta,
        questionImprove.isAcceptableOrUnknown(
          data['question_improve']!,
          _questionImproveMeta,
        ),
      );
    }
    if (data.containsKey('ai_insight')) {
      context.handle(
        _aiInsightMeta,
        aiInsight.isAcceptableOrUnknown(data['ai_insight']!, _aiInsightMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KakeiboReflectionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KakeiboReflectionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      familyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      incomeTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}income_total'],
      )!,
      expenseTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}expense_total'],
      )!,
      savingsTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}savings_target'],
      )!,
      savingsActual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}savings_actual'],
      )!,
      questionHowMuch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_how_much'],
      ),
      questionSave: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_save'],
      ),
      questionSpent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_spent'],
      ),
      questionImprove: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_improve'],
      ),
      aiInsight: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ai_insight'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $KakeiboReflectionsTableTable createAlias(String alias) {
    return $KakeiboReflectionsTableTable(attachedDatabase, alias);
  }
}

class KakeiboReflectionsTableData extends DataClass
    implements Insertable<KakeiboReflectionsTableData> {
  final String id;
  final String familyId;
  final String userId;
  final int year;
  final int month;
  final double incomeTotal;
  final double expenseTotal;
  final double savingsTarget;
  final double savingsActual;
  final String? questionHowMuch;
  final String? questionSave;
  final String? questionSpent;
  final String? questionImprove;
  final String? aiInsight;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const KakeiboReflectionsTableData({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.year,
    required this.month,
    required this.incomeTotal,
    required this.expenseTotal,
    required this.savingsTarget,
    required this.savingsActual,
    this.questionHowMuch,
    this.questionSave,
    this.questionSpent,
    this.questionImprove,
    this.aiInsight,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['user_id'] = Variable<String>(userId);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['income_total'] = Variable<double>(incomeTotal);
    map['expense_total'] = Variable<double>(expenseTotal);
    map['savings_target'] = Variable<double>(savingsTarget);
    map['savings_actual'] = Variable<double>(savingsActual);
    if (!nullToAbsent || questionHowMuch != null) {
      map['question_how_much'] = Variable<String>(questionHowMuch);
    }
    if (!nullToAbsent || questionSave != null) {
      map['question_save'] = Variable<String>(questionSave);
    }
    if (!nullToAbsent || questionSpent != null) {
      map['question_spent'] = Variable<String>(questionSpent);
    }
    if (!nullToAbsent || questionImprove != null) {
      map['question_improve'] = Variable<String>(questionImprove);
    }
    if (!nullToAbsent || aiInsight != null) {
      map['ai_insight'] = Variable<String>(aiInsight);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  KakeiboReflectionsTableCompanion toCompanion(bool nullToAbsent) {
    return KakeiboReflectionsTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      userId: Value(userId),
      year: Value(year),
      month: Value(month),
      incomeTotal: Value(incomeTotal),
      expenseTotal: Value(expenseTotal),
      savingsTarget: Value(savingsTarget),
      savingsActual: Value(savingsActual),
      questionHowMuch: questionHowMuch == null && nullToAbsent
          ? const Value.absent()
          : Value(questionHowMuch),
      questionSave: questionSave == null && nullToAbsent
          ? const Value.absent()
          : Value(questionSave),
      questionSpent: questionSpent == null && nullToAbsent
          ? const Value.absent()
          : Value(questionSpent),
      questionImprove: questionImprove == null && nullToAbsent
          ? const Value.absent()
          : Value(questionImprove),
      aiInsight: aiInsight == null && nullToAbsent
          ? const Value.absent()
          : Value(aiInsight),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory KakeiboReflectionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KakeiboReflectionsTableData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      userId: serializer.fromJson<String>(json['userId']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      incomeTotal: serializer.fromJson<double>(json['incomeTotal']),
      expenseTotal: serializer.fromJson<double>(json['expenseTotal']),
      savingsTarget: serializer.fromJson<double>(json['savingsTarget']),
      savingsActual: serializer.fromJson<double>(json['savingsActual']),
      questionHowMuch: serializer.fromJson<String?>(json['questionHowMuch']),
      questionSave: serializer.fromJson<String?>(json['questionSave']),
      questionSpent: serializer.fromJson<String?>(json['questionSpent']),
      questionImprove: serializer.fromJson<String?>(json['questionImprove']),
      aiInsight: serializer.fromJson<String?>(json['aiInsight']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'userId': serializer.toJson<String>(userId),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'incomeTotal': serializer.toJson<double>(incomeTotal),
      'expenseTotal': serializer.toJson<double>(expenseTotal),
      'savingsTarget': serializer.toJson<double>(savingsTarget),
      'savingsActual': serializer.toJson<double>(savingsActual),
      'questionHowMuch': serializer.toJson<String?>(questionHowMuch),
      'questionSave': serializer.toJson<String?>(questionSave),
      'questionSpent': serializer.toJson<String?>(questionSpent),
      'questionImprove': serializer.toJson<String?>(questionImprove),
      'aiInsight': serializer.toJson<String?>(aiInsight),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  KakeiboReflectionsTableData copyWith({
    String? id,
    String? familyId,
    String? userId,
    int? year,
    int? month,
    double? incomeTotal,
    double? expenseTotal,
    double? savingsTarget,
    double? savingsActual,
    Value<String?> questionHowMuch = const Value.absent(),
    Value<String?> questionSave = const Value.absent(),
    Value<String?> questionSpent = const Value.absent(),
    Value<String?> questionImprove = const Value.absent(),
    Value<String?> aiInsight = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => KakeiboReflectionsTableData(
    id: id ?? this.id,
    familyId: familyId ?? this.familyId,
    userId: userId ?? this.userId,
    year: year ?? this.year,
    month: month ?? this.month,
    incomeTotal: incomeTotal ?? this.incomeTotal,
    expenseTotal: expenseTotal ?? this.expenseTotal,
    savingsTarget: savingsTarget ?? this.savingsTarget,
    savingsActual: savingsActual ?? this.savingsActual,
    questionHowMuch: questionHowMuch.present
        ? questionHowMuch.value
        : this.questionHowMuch,
    questionSave: questionSave.present ? questionSave.value : this.questionSave,
    questionSpent: questionSpent.present
        ? questionSpent.value
        : this.questionSpent,
    questionImprove: questionImprove.present
        ? questionImprove.value
        : this.questionImprove,
    aiInsight: aiInsight.present ? aiInsight.value : this.aiInsight,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  KakeiboReflectionsTableData copyWithCompanion(
    KakeiboReflectionsTableCompanion data,
  ) {
    return KakeiboReflectionsTableData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      userId: data.userId.present ? data.userId.value : this.userId,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      incomeTotal: data.incomeTotal.present
          ? data.incomeTotal.value
          : this.incomeTotal,
      expenseTotal: data.expenseTotal.present
          ? data.expenseTotal.value
          : this.expenseTotal,
      savingsTarget: data.savingsTarget.present
          ? data.savingsTarget.value
          : this.savingsTarget,
      savingsActual: data.savingsActual.present
          ? data.savingsActual.value
          : this.savingsActual,
      questionHowMuch: data.questionHowMuch.present
          ? data.questionHowMuch.value
          : this.questionHowMuch,
      questionSave: data.questionSave.present
          ? data.questionSave.value
          : this.questionSave,
      questionSpent: data.questionSpent.present
          ? data.questionSpent.value
          : this.questionSpent,
      questionImprove: data.questionImprove.present
          ? data.questionImprove.value
          : this.questionImprove,
      aiInsight: data.aiInsight.present ? data.aiInsight.value : this.aiInsight,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KakeiboReflectionsTableData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('userId: $userId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('incomeTotal: $incomeTotal, ')
          ..write('expenseTotal: $expenseTotal, ')
          ..write('savingsTarget: $savingsTarget, ')
          ..write('savingsActual: $savingsActual, ')
          ..write('questionHowMuch: $questionHowMuch, ')
          ..write('questionSave: $questionSave, ')
          ..write('questionSpent: $questionSpent, ')
          ..write('questionImprove: $questionImprove, ')
          ..write('aiInsight: $aiInsight, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    familyId,
    userId,
    year,
    month,
    incomeTotal,
    expenseTotal,
    savingsTarget,
    savingsActual,
    questionHowMuch,
    questionSave,
    questionSpent,
    questionImprove,
    aiInsight,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KakeiboReflectionsTableData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.userId == this.userId &&
          other.year == this.year &&
          other.month == this.month &&
          other.incomeTotal == this.incomeTotal &&
          other.expenseTotal == this.expenseTotal &&
          other.savingsTarget == this.savingsTarget &&
          other.savingsActual == this.savingsActual &&
          other.questionHowMuch == this.questionHowMuch &&
          other.questionSave == this.questionSave &&
          other.questionSpent == this.questionSpent &&
          other.questionImprove == this.questionImprove &&
          other.aiInsight == this.aiInsight &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class KakeiboReflectionsTableCompanion
    extends UpdateCompanion<KakeiboReflectionsTableData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> userId;
  final Value<int> year;
  final Value<int> month;
  final Value<double> incomeTotal;
  final Value<double> expenseTotal;
  final Value<double> savingsTarget;
  final Value<double> savingsActual;
  final Value<String?> questionHowMuch;
  final Value<String?> questionSave;
  final Value<String?> questionSpent;
  final Value<String?> questionImprove;
  final Value<String?> aiInsight;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const KakeiboReflectionsTableCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.userId = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.incomeTotal = const Value.absent(),
    this.expenseTotal = const Value.absent(),
    this.savingsTarget = const Value.absent(),
    this.savingsActual = const Value.absent(),
    this.questionHowMuch = const Value.absent(),
    this.questionSave = const Value.absent(),
    this.questionSpent = const Value.absent(),
    this.questionImprove = const Value.absent(),
    this.aiInsight = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KakeiboReflectionsTableCompanion.insert({
    required String id,
    required String familyId,
    required String userId,
    required int year,
    required int month,
    this.incomeTotal = const Value.absent(),
    this.expenseTotal = const Value.absent(),
    this.savingsTarget = const Value.absent(),
    this.savingsActual = const Value.absent(),
    this.questionHowMuch = const Value.absent(),
    this.questionSave = const Value.absent(),
    this.questionSpent = const Value.absent(),
    this.questionImprove = const Value.absent(),
    this.aiInsight = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       familyId = Value(familyId),
       userId = Value(userId),
       year = Value(year),
       month = Value(month);
  static Insertable<KakeiboReflectionsTableData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? userId,
    Expression<int>? year,
    Expression<int>? month,
    Expression<double>? incomeTotal,
    Expression<double>? expenseTotal,
    Expression<double>? savingsTarget,
    Expression<double>? savingsActual,
    Expression<String>? questionHowMuch,
    Expression<String>? questionSave,
    Expression<String>? questionSpent,
    Expression<String>? questionImprove,
    Expression<String>? aiInsight,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (userId != null) 'user_id': userId,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (incomeTotal != null) 'income_total': incomeTotal,
      if (expenseTotal != null) 'expense_total': expenseTotal,
      if (savingsTarget != null) 'savings_target': savingsTarget,
      if (savingsActual != null) 'savings_actual': savingsActual,
      if (questionHowMuch != null) 'question_how_much': questionHowMuch,
      if (questionSave != null) 'question_save': questionSave,
      if (questionSpent != null) 'question_spent': questionSpent,
      if (questionImprove != null) 'question_improve': questionImprove,
      if (aiInsight != null) 'ai_insight': aiInsight,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KakeiboReflectionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? familyId,
    Value<String>? userId,
    Value<int>? year,
    Value<int>? month,
    Value<double>? incomeTotal,
    Value<double>? expenseTotal,
    Value<double>? savingsTarget,
    Value<double>? savingsActual,
    Value<String?>? questionHowMuch,
    Value<String?>? questionSave,
    Value<String?>? questionSpent,
    Value<String?>? questionImprove,
    Value<String?>? aiInsight,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return KakeiboReflectionsTableCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      userId: userId ?? this.userId,
      year: year ?? this.year,
      month: month ?? this.month,
      incomeTotal: incomeTotal ?? this.incomeTotal,
      expenseTotal: expenseTotal ?? this.expenseTotal,
      savingsTarget: savingsTarget ?? this.savingsTarget,
      savingsActual: savingsActual ?? this.savingsActual,
      questionHowMuch: questionHowMuch ?? this.questionHowMuch,
      questionSave: questionSave ?? this.questionSave,
      questionSpent: questionSpent ?? this.questionSpent,
      questionImprove: questionImprove ?? this.questionImprove,
      aiInsight: aiInsight ?? this.aiInsight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (incomeTotal.present) {
      map['income_total'] = Variable<double>(incomeTotal.value);
    }
    if (expenseTotal.present) {
      map['expense_total'] = Variable<double>(expenseTotal.value);
    }
    if (savingsTarget.present) {
      map['savings_target'] = Variable<double>(savingsTarget.value);
    }
    if (savingsActual.present) {
      map['savings_actual'] = Variable<double>(savingsActual.value);
    }
    if (questionHowMuch.present) {
      map['question_how_much'] = Variable<String>(questionHowMuch.value);
    }
    if (questionSave.present) {
      map['question_save'] = Variable<String>(questionSave.value);
    }
    if (questionSpent.present) {
      map['question_spent'] = Variable<String>(questionSpent.value);
    }
    if (questionImprove.present) {
      map['question_improve'] = Variable<String>(questionImprove.value);
    }
    if (aiInsight.present) {
      map['ai_insight'] = Variable<String>(aiInsight.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KakeiboReflectionsTableCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('userId: $userId, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('incomeTotal: $incomeTotal, ')
          ..write('expenseTotal: $expenseTotal, ')
          ..write('savingsTarget: $savingsTarget, ')
          ..write('savingsActual: $savingsActual, ')
          ..write('questionHowMuch: $questionHowMuch, ')
          ..write('questionSave: $questionSave, ')
          ..write('questionSpent: $questionSpent, ')
          ..write('questionImprove: $questionImprove, ')
          ..write('aiInsight: $aiInsight, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableName_Meta = const VerificationMeta(
    'tableName_',
  );
  @override
  late final GeneratedColumn<String> tableName_ = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _processedAtMeta = const VerificationMeta(
    'processedAt',
  );
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
    'processed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    operationType,
    tableName_,
    recordId,
    payload,
    status,
    attemptCount,
    lastError,
    createdAt,
    processedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _tableName_Meta,
        tableName_.isAcceptableOrUnknown(data['table_name']!, _tableName_Meta),
      );
    } else if (isInserting) {
      context.missing(_tableName_Meta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('processed_at')) {
      context.handle(
        _processedAtMeta,
        processedAt.isAcceptableOrUnknown(
          data['processed_at']!,
          _processedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      tableName_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      processedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}processed_at'],
      ),
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueTableData extends DataClass
    implements Insertable<SyncQueueTableData> {
  final int id;
  final String operationType;
  final String tableName_;
  final String recordId;
  final String payload;
  final String status;
  final int attemptCount;
  final String? lastError;
  final DateTime createdAt;
  final DateTime? processedAt;
  const SyncQueueTableData({
    required this.id,
    required this.operationType,
    required this.tableName_,
    required this.recordId,
    required this.payload,
    required this.status,
    required this.attemptCount,
    this.lastError,
    required this.createdAt,
    this.processedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation_type'] = Variable<String>(operationType);
    map['table_name'] = Variable<String>(tableName_);
    map['record_id'] = Variable<String>(recordId);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      operationType: Value(operationType),
      tableName_: Value(tableName_),
      recordId: Value(recordId),
      payload: Value(payload),
      status: Value(status),
      attemptCount: Value(attemptCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
    );
  }

  factory SyncQueueTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueTableData(
      id: serializer.fromJson<int>(json['id']),
      operationType: serializer.fromJson<String>(json['operationType']),
      tableName_: serializer.fromJson<String>(json['tableName_']),
      recordId: serializer.fromJson<String>(json['recordId']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operationType': serializer.toJson<String>(operationType),
      'tableName_': serializer.toJson<String>(tableName_),
      'recordId': serializer.toJson<String>(recordId),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
    };
  }

  SyncQueueTableData copyWith({
    int? id,
    String? operationType,
    String? tableName_,
    String? recordId,
    String? payload,
    String? status,
    int? attemptCount,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> processedAt = const Value.absent(),
  }) => SyncQueueTableData(
    id: id ?? this.id,
    operationType: operationType ?? this.operationType,
    tableName_: tableName_ ?? this.tableName_,
    recordId: recordId ?? this.recordId,
    payload: payload ?? this.payload,
    status: status ?? this.status,
    attemptCount: attemptCount ?? this.attemptCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    processedAt: processedAt.present ? processedAt.value : this.processedAt,
  );
  SyncQueueTableData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueTableData(
      id: data.id.present ? data.id.value : this.id,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      tableName_: data.tableName_.present
          ? data.tableName_.value
          : this.tableName_,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableData(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('tableName_: $tableName_, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('processedAt: $processedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    operationType,
    tableName_,
    recordId,
    payload,
    status,
    attemptCount,
    lastError,
    createdAt,
    processedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueTableData &&
          other.id == this.id &&
          other.operationType == this.operationType &&
          other.tableName_ == this.tableName_ &&
          other.recordId == this.recordId &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.attemptCount == this.attemptCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.processedAt == this.processedAt);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueTableData> {
  final Value<int> id;
  final Value<String> operationType;
  final Value<String> tableName_;
  final Value<String> recordId;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> attemptCount;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime?> processedAt;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.operationType = const Value.absent(),
    this.tableName_ = const Value.absent(),
    this.recordId = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.processedAt = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    this.id = const Value.absent(),
    required String operationType,
    required String tableName_,
    required String recordId,
    required String payload,
    this.status = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.processedAt = const Value.absent(),
  }) : operationType = Value(operationType),
       tableName_ = Value(tableName_),
       recordId = Value(recordId),
       payload = Value(payload);
  static Insertable<SyncQueueTableData> custom({
    Expression<int>? id,
    Expression<String>? operationType,
    Expression<String>? tableName_,
    Expression<String>? recordId,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? attemptCount,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? processedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operationType != null) 'operation_type': operationType,
      if (tableName_ != null) 'table_name': tableName_,
      if (recordId != null) 'record_id': recordId,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (processedAt != null) 'processed_at': processedAt,
    });
  }

  SyncQueueTableCompanion copyWith({
    Value<int>? id,
    Value<String>? operationType,
    Value<String>? tableName_,
    Value<String>? recordId,
    Value<String>? payload,
    Value<String>? status,
    Value<int>? attemptCount,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime?>? processedAt,
  }) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      tableName_: tableName_ ?? this.tableName_,
      recordId: recordId ?? this.recordId,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (tableName_.present) {
      map['table_name'] = Variable<String>(tableName_.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('tableName_: $tableName_, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('processedAt: $processedAt')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTableTable extends UserProfilesTable
    with TableInfo<$UserProfilesTableTable, UserProfilesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 36,
      maxTextLength: 36,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 255),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('viewer'),
  );
  static const VerificationMeta _preferredCurrencyMeta = const VerificationMeta(
    'preferredCurrency',
  );
  @override
  late final GeneratedColumn<String> preferredCurrency =
      GeneratedColumn<String>(
        'preferred_currency',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 3),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('CRC'),
      );
  static const VerificationMeta _biometricEnabledMeta = const VerificationMeta(
    'biometricEnabled',
  );
  @override
  late final GeneratedColumn<bool> biometricEnabled = GeneratedColumn<bool>(
    'biometric_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("biometric_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    displayName,
    avatarUrl,
    role,
    preferredCurrency,
    biometricEnabled,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfilesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('preferred_currency')) {
      context.handle(
        _preferredCurrencyMeta,
        preferredCurrency.isAcceptableOrUnknown(
          data['preferred_currency']!,
          _preferredCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('biometric_enabled')) {
      context.handle(
        _biometricEnabledMeta,
        biometricEnabled.isAcceptableOrUnknown(
          data['biometric_enabled']!,
          _biometricEnabledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfilesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfilesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      preferredCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_currency'],
      )!,
      biometricEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}biometric_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $UserProfilesTableTable createAlias(String alias) {
    return $UserProfilesTableTable(attachedDatabase, alias);
  }
}

class UserProfilesTableData extends DataClass
    implements Insertable<UserProfilesTableData> {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String role;
  final String preferredCurrency;
  final bool biometricEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const UserProfilesTableData({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    required this.role,
    required this.preferredCurrency,
    required this.biometricEnabled,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['role'] = Variable<String>(role);
    map['preferred_currency'] = Variable<String>(preferredCurrency);
    map['biometric_enabled'] = Variable<bool>(biometricEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  UserProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesTableCompanion(
      id: Value(id),
      email: Value(email),
      displayName: Value(displayName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      role: Value(role),
      preferredCurrency: Value(preferredCurrency),
      biometricEnabled: Value(biometricEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory UserProfilesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfilesTableData(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String>(json['displayName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      role: serializer.fromJson<String>(json['role']),
      preferredCurrency: serializer.fromJson<String>(json['preferredCurrency']),
      biometricEnabled: serializer.fromJson<bool>(json['biometricEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String>(displayName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'role': serializer.toJson<String>(role),
      'preferredCurrency': serializer.toJson<String>(preferredCurrency),
      'biometricEnabled': serializer.toJson<bool>(biometricEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  UserProfilesTableData copyWith({
    String? id,
    String? email,
    String? displayName,
    Value<String?> avatarUrl = const Value.absent(),
    String? role,
    String? preferredCurrency,
    bool? biometricEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => UserProfilesTableData(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    role: role ?? this.role,
    preferredCurrency: preferredCurrency ?? this.preferredCurrency,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  UserProfilesTableData copyWithCompanion(UserProfilesTableCompanion data) {
    return UserProfilesTableData(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      role: data.role.present ? data.role.value : this.role,
      preferredCurrency: data.preferredCurrency.present
          ? data.preferredCurrency.value
          : this.preferredCurrency,
      biometricEnabled: data.biometricEnabled.present
          ? data.biometricEnabled.value
          : this.biometricEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableData(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('role: $role, ')
          ..write('preferredCurrency: $preferredCurrency, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    displayName,
    avatarUrl,
    role,
    preferredCurrency,
    biometricEnabled,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfilesTableData &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.avatarUrl == this.avatarUrl &&
          other.role == this.role &&
          other.preferredCurrency == this.preferredCurrency &&
          other.biometricEnabled == this.biometricEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class UserProfilesTableCompanion
    extends UpdateCompanion<UserProfilesTableData> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> displayName;
  final Value<String?> avatarUrl;
  final Value<String> role;
  final Value<String> preferredCurrency;
  final Value<bool> biometricEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const UserProfilesTableCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.role = const Value.absent(),
    this.preferredCurrency = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesTableCompanion.insert({
    required String id,
    required String email,
    required String displayName,
    this.avatarUrl = const Value.absent(),
    this.role = const Value.absent(),
    this.preferredCurrency = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       displayName = Value(displayName);
  static Insertable<UserProfilesTableData> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? avatarUrl,
    Expression<String>? role,
    Expression<String>? preferredCurrency,
    Expression<bool>? biometricEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (role != null) 'role': role,
      if (preferredCurrency != null) 'preferred_currency': preferredCurrency,
      if (biometricEnabled != null) 'biometric_enabled': biometricEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? displayName,
    Value<String?>? avatarUrl,
    Value<String>? role,
    Value<String>? preferredCurrency,
    Value<bool>? biometricEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return UserProfilesTableCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (preferredCurrency.present) {
      map['preferred_currency'] = Variable<String>(preferredCurrency.value);
    }
    if (biometricEnabled.present) {
      map['biometric_enabled'] = Variable<bool>(biometricEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('role: $role, ')
          ..write('preferredCurrency: $preferredCurrency, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EnvelopesTableTable envelopesTable = $EnvelopesTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $FamilyMembersTableTable familyMembersTable =
      $FamilyMembersTableTable(this);
  late final $KakeiboReflectionsTableTable kakeiboReflectionsTable =
      $KakeiboReflectionsTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final $UserProfilesTableTable userProfilesTable =
      $UserProfilesTableTable(this);
  late final EnvelopesDao envelopesDao = EnvelopesDao(this as AppDatabase);
  late final TransactionsDao transactionsDao = TransactionsDao(
    this as AppDatabase,
  );
  late final SyncQueueDao syncQueueDao = SyncQueueDao(this as AppDatabase);
  late final UserProfilesDao userProfilesDao = UserProfilesDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    envelopesTable,
    transactionsTable,
    familyMembersTable,
    kakeiboReflectionsTable,
    syncQueueTable,
    userProfilesTable,
  ];
}

typedef $$EnvelopesTableTableCreateCompanionBuilder =
    EnvelopesTableCompanion Function({
      required String id,
      required String familyId,
      required String name,
      required String category,
      Value<double> budgetedAmount,
      Value<double> spentAmount,
      Value<String> currency,
      Value<bool> isActive,
      Value<int> sortOrder,
      Value<String?> iconCode,
      Value<String?> colorHex,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<String> localStatus,
      Value<int> rowid,
    });
typedef $$EnvelopesTableTableUpdateCompanionBuilder =
    EnvelopesTableCompanion Function({
      Value<String> id,
      Value<String> familyId,
      Value<String> name,
      Value<String> category,
      Value<double> budgetedAmount,
      Value<double> spentAmount,
      Value<String> currency,
      Value<bool> isActive,
      Value<int> sortOrder,
      Value<String?> iconCode,
      Value<String?> colorHex,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<String> localStatus,
      Value<int> rowid,
    });

class $$EnvelopesTableTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopesTableTable> {
  $$EnvelopesTableTableFilterComposer({
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

  ColumnFilters<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get budgetedAmount => $composableBuilder(
    column: $table.budgetedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconCode => $composableBuilder(
    column: $table.iconCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EnvelopesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopesTableTable> {
  $$EnvelopesTableTableOrderingComposer({
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

  ColumnOrderings<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get budgetedAmount => $composableBuilder(
    column: $table.budgetedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconCode => $composableBuilder(
    column: $table.iconCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnvelopesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopesTableTable> {
  $$EnvelopesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get budgetedAmount => $composableBuilder(
    column: $table.budgetedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get iconCode =>
      $composableBuilder(column: $table.iconCode, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => column,
  );
}

class $$EnvelopesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvelopesTableTable,
          EnvelopesTableData,
          $$EnvelopesTableTableFilterComposer,
          $$EnvelopesTableTableOrderingComposer,
          $$EnvelopesTableTableAnnotationComposer,
          $$EnvelopesTableTableCreateCompanionBuilder,
          $$EnvelopesTableTableUpdateCompanionBuilder,
          (
            EnvelopesTableData,
            BaseReferences<
              _$AppDatabase,
              $EnvelopesTableTable,
              EnvelopesTableData
            >,
          ),
          EnvelopesTableData,
          PrefetchHooks Function()
        > {
  $$EnvelopesTableTableTableManager(
    _$AppDatabase db,
    $EnvelopesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvelopesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvelopesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> budgetedAmount = const Value.absent(),
                Value<double> spentAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> iconCode = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnvelopesTableCompanion(
                id: id,
                familyId: familyId,
                name: name,
                category: category,
                budgetedAmount: budgetedAmount,
                spentAmount: spentAmount,
                currency: currency,
                isActive: isActive,
                sortOrder: sortOrder,
                iconCode: iconCode,
                colorHex: colorHex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                localStatus: localStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyId,
                required String name,
                required String category,
                Value<double> budgetedAmount = const Value.absent(),
                Value<double> spentAmount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> iconCode = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnvelopesTableCompanion.insert(
                id: id,
                familyId: familyId,
                name: name,
                category: category,
                budgetedAmount: budgetedAmount,
                spentAmount: spentAmount,
                currency: currency,
                isActive: isActive,
                sortOrder: sortOrder,
                iconCode: iconCode,
                colorHex: colorHex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                localStatus: localStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EnvelopesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvelopesTableTable,
      EnvelopesTableData,
      $$EnvelopesTableTableFilterComposer,
      $$EnvelopesTableTableOrderingComposer,
      $$EnvelopesTableTableAnnotationComposer,
      $$EnvelopesTableTableCreateCompanionBuilder,
      $$EnvelopesTableTableUpdateCompanionBuilder,
      (
        EnvelopesTableData,
        BaseReferences<_$AppDatabase, $EnvelopesTableTable, EnvelopesTableData>,
      ),
      EnvelopesTableData,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableTableCreateCompanionBuilder =
    TransactionsTableCompanion Function({
      required String id,
      required String familyId,
      Value<String?> envelopeId,
      required String createdByUserId,
      required String type,
      required double amount,
      Value<String> currency,
      required String description,
      Value<String?> merchant,
      required DateTime transactionDate,
      Value<String?> sourceType,
      Value<String?> rawSourceData,
      Value<bool> isRecurring,
      Value<String?> tags,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<String> localStatus,
      Value<int> rowid,
    });
typedef $$TransactionsTableTableUpdateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<String> id,
      Value<String> familyId,
      Value<String?> envelopeId,
      Value<String> createdByUserId,
      Value<String> type,
      Value<double> amount,
      Value<String> currency,
      Value<String> description,
      Value<String?> merchant,
      Value<DateTime> transactionDate,
      Value<String?> sourceType,
      Value<String?> rawSourceData,
      Value<bool> isRecurring,
      Value<String?> tags,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<String> localStatus,
      Value<int> rowid,
    });

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
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

  ColumnFilters<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawSourceData => $composableBuilder(
    column: $table.rawSourceData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawSourceData => $composableBuilder(
    column: $table.rawSourceData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawSourceData => $composableBuilder(
    column: $table.rawSourceData,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
    column: $table.isRecurring,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get localStatus => $composableBuilder(
    column: $table.localStatus,
    builder: (column) => column,
  );
}

class $$TransactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData,
          $$TransactionsTableTableFilterComposer,
          $$TransactionsTableTableOrderingComposer,
          $$TransactionsTableTableAnnotationComposer,
          $$TransactionsTableTableCreateCompanionBuilder,
          $$TransactionsTableTableUpdateCompanionBuilder,
          (
            TransactionsTableData,
            BaseReferences<
              _$AppDatabase,
              $TransactionsTableTable,
              TransactionsTableData
            >,
          ),
          TransactionsTableData,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableTableManager(
    _$AppDatabase db,
    $TransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyId = const Value.absent(),
                Value<String?> envelopeId = const Value.absent(),
                Value<String> createdByUserId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> sourceType = const Value.absent(),
                Value<String?> rawSourceData = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion(
                id: id,
                familyId: familyId,
                envelopeId: envelopeId,
                createdByUserId: createdByUserId,
                type: type,
                amount: amount,
                currency: currency,
                description: description,
                merchant: merchant,
                transactionDate: transactionDate,
                sourceType: sourceType,
                rawSourceData: rawSourceData,
                isRecurring: isRecurring,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                localStatus: localStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyId,
                Value<String?> envelopeId = const Value.absent(),
                required String createdByUserId,
                required String type,
                required double amount,
                Value<String> currency = const Value.absent(),
                required String description,
                Value<String?> merchant = const Value.absent(),
                required DateTime transactionDate,
                Value<String?> sourceType = const Value.absent(),
                Value<String?> rawSourceData = const Value.absent(),
                Value<bool> isRecurring = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String> localStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion.insert(
                id: id,
                familyId: familyId,
                envelopeId: envelopeId,
                createdByUserId: createdByUserId,
                type: type,
                amount: amount,
                currency: currency,
                description: description,
                merchant: merchant,
                transactionDate: transactionDate,
                sourceType: sourceType,
                rawSourceData: rawSourceData,
                isRecurring: isRecurring,
                tags: tags,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                localStatus: localStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTableTable,
      TransactionsTableData,
      $$TransactionsTableTableFilterComposer,
      $$TransactionsTableTableOrderingComposer,
      $$TransactionsTableTableAnnotationComposer,
      $$TransactionsTableTableCreateCompanionBuilder,
      $$TransactionsTableTableUpdateCompanionBuilder,
      (
        TransactionsTableData,
        BaseReferences<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData
        >,
      ),
      TransactionsTableData,
      PrefetchHooks Function()
    >;
typedef $$FamilyMembersTableTableCreateCompanionBuilder =
    FamilyMembersTableCompanion Function({
      required String id,
      required String familyId,
      required String userId,
      required String role,
      Value<bool> isActive,
      Value<DateTime> joinedAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$FamilyMembersTableTableUpdateCompanionBuilder =
    FamilyMembersTableCompanion Function({
      Value<String> id,
      Value<String> familyId,
      Value<String> userId,
      Value<String> role,
      Value<bool> isActive,
      Value<DateTime> joinedAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$FamilyMembersTableTableFilterComposer
    extends Composer<_$AppDatabase, $FamilyMembersTableTable> {
  $$FamilyMembersTableTableFilterComposer({
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

  ColumnFilters<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FamilyMembersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FamilyMembersTableTable> {
  $$FamilyMembersTableTableOrderingComposer({
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

  ColumnOrderings<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
    column: $table.joinedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamilyMembersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamilyMembersTableTable> {
  $$FamilyMembersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$FamilyMembersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamilyMembersTableTable,
          FamilyMembersTableData,
          $$FamilyMembersTableTableFilterComposer,
          $$FamilyMembersTableTableOrderingComposer,
          $$FamilyMembersTableTableAnnotationComposer,
          $$FamilyMembersTableTableCreateCompanionBuilder,
          $$FamilyMembersTableTableUpdateCompanionBuilder,
          (
            FamilyMembersTableData,
            BaseReferences<
              _$AppDatabase,
              $FamilyMembersTableTable,
              FamilyMembersTableData
            >,
          ),
          FamilyMembersTableData,
          PrefetchHooks Function()
        > {
  $$FamilyMembersTableTableTableManager(
    _$AppDatabase db,
    $FamilyMembersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyMembersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyMembersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyMembersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyMembersTableCompanion(
                id: id,
                familyId: familyId,
                userId: userId,
                role: role,
                isActive: isActive,
                joinedAt: joinedAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyId,
                required String userId,
                required String role,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> joinedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyMembersTableCompanion.insert(
                id: id,
                familyId: familyId,
                userId: userId,
                role: role,
                isActive: isActive,
                joinedAt: joinedAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FamilyMembersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamilyMembersTableTable,
      FamilyMembersTableData,
      $$FamilyMembersTableTableFilterComposer,
      $$FamilyMembersTableTableOrderingComposer,
      $$FamilyMembersTableTableAnnotationComposer,
      $$FamilyMembersTableTableCreateCompanionBuilder,
      $$FamilyMembersTableTableUpdateCompanionBuilder,
      (
        FamilyMembersTableData,
        BaseReferences<
          _$AppDatabase,
          $FamilyMembersTableTable,
          FamilyMembersTableData
        >,
      ),
      FamilyMembersTableData,
      PrefetchHooks Function()
    >;
typedef $$KakeiboReflectionsTableTableCreateCompanionBuilder =
    KakeiboReflectionsTableCompanion Function({
      required String id,
      required String familyId,
      required String userId,
      required int year,
      required int month,
      Value<double> incomeTotal,
      Value<double> expenseTotal,
      Value<double> savingsTarget,
      Value<double> savingsActual,
      Value<String?> questionHowMuch,
      Value<String?> questionSave,
      Value<String?> questionSpent,
      Value<String?> questionImprove,
      Value<String?> aiInsight,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$KakeiboReflectionsTableTableUpdateCompanionBuilder =
    KakeiboReflectionsTableCompanion Function({
      Value<String> id,
      Value<String> familyId,
      Value<String> userId,
      Value<int> year,
      Value<int> month,
      Value<double> incomeTotal,
      Value<double> expenseTotal,
      Value<double> savingsTarget,
      Value<double> savingsActual,
      Value<String?> questionHowMuch,
      Value<String?> questionSave,
      Value<String?> questionSpent,
      Value<String?> questionImprove,
      Value<String?> aiInsight,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$KakeiboReflectionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $KakeiboReflectionsTableTable> {
  $$KakeiboReflectionsTableTableFilterComposer({
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

  ColumnFilters<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get incomeTotal => $composableBuilder(
    column: $table.incomeTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get expenseTotal => $composableBuilder(
    column: $table.expenseTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get savingsTarget => $composableBuilder(
    column: $table.savingsTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get savingsActual => $composableBuilder(
    column: $table.savingsActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionHowMuch => $composableBuilder(
    column: $table.questionHowMuch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionSave => $composableBuilder(
    column: $table.questionSave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionSpent => $composableBuilder(
    column: $table.questionSpent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionImprove => $composableBuilder(
    column: $table.questionImprove,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aiInsight => $composableBuilder(
    column: $table.aiInsight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KakeiboReflectionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KakeiboReflectionsTableTable> {
  $$KakeiboReflectionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get familyId => $composableBuilder(
    column: $table.familyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get incomeTotal => $composableBuilder(
    column: $table.incomeTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get expenseTotal => $composableBuilder(
    column: $table.expenseTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get savingsTarget => $composableBuilder(
    column: $table.savingsTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get savingsActual => $composableBuilder(
    column: $table.savingsActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionHowMuch => $composableBuilder(
    column: $table.questionHowMuch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionSave => $composableBuilder(
    column: $table.questionSave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionSpent => $composableBuilder(
    column: $table.questionSpent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionImprove => $composableBuilder(
    column: $table.questionImprove,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aiInsight => $composableBuilder(
    column: $table.aiInsight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KakeiboReflectionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KakeiboReflectionsTableTable> {
  $$KakeiboReflectionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get familyId =>
      $composableBuilder(column: $table.familyId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<double> get incomeTotal => $composableBuilder(
    column: $table.incomeTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get expenseTotal => $composableBuilder(
    column: $table.expenseTotal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get savingsTarget => $composableBuilder(
    column: $table.savingsTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get savingsActual => $composableBuilder(
    column: $table.savingsActual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionHowMuch => $composableBuilder(
    column: $table.questionHowMuch,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionSave => $composableBuilder(
    column: $table.questionSave,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionSpent => $composableBuilder(
    column: $table.questionSpent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionImprove => $composableBuilder(
    column: $table.questionImprove,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aiInsight =>
      $composableBuilder(column: $table.aiInsight, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$KakeiboReflectionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KakeiboReflectionsTableTable,
          KakeiboReflectionsTableData,
          $$KakeiboReflectionsTableTableFilterComposer,
          $$KakeiboReflectionsTableTableOrderingComposer,
          $$KakeiboReflectionsTableTableAnnotationComposer,
          $$KakeiboReflectionsTableTableCreateCompanionBuilder,
          $$KakeiboReflectionsTableTableUpdateCompanionBuilder,
          (
            KakeiboReflectionsTableData,
            BaseReferences<
              _$AppDatabase,
              $KakeiboReflectionsTableTable,
              KakeiboReflectionsTableData
            >,
          ),
          KakeiboReflectionsTableData,
          PrefetchHooks Function()
        > {
  $$KakeiboReflectionsTableTableTableManager(
    _$AppDatabase db,
    $KakeiboReflectionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KakeiboReflectionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$KakeiboReflectionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$KakeiboReflectionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> familyId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<double> incomeTotal = const Value.absent(),
                Value<double> expenseTotal = const Value.absent(),
                Value<double> savingsTarget = const Value.absent(),
                Value<double> savingsActual = const Value.absent(),
                Value<String?> questionHowMuch = const Value.absent(),
                Value<String?> questionSave = const Value.absent(),
                Value<String?> questionSpent = const Value.absent(),
                Value<String?> questionImprove = const Value.absent(),
                Value<String?> aiInsight = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KakeiboReflectionsTableCompanion(
                id: id,
                familyId: familyId,
                userId: userId,
                year: year,
                month: month,
                incomeTotal: incomeTotal,
                expenseTotal: expenseTotal,
                savingsTarget: savingsTarget,
                savingsActual: savingsActual,
                questionHowMuch: questionHowMuch,
                questionSave: questionSave,
                questionSpent: questionSpent,
                questionImprove: questionImprove,
                aiInsight: aiInsight,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String familyId,
                required String userId,
                required int year,
                required int month,
                Value<double> incomeTotal = const Value.absent(),
                Value<double> expenseTotal = const Value.absent(),
                Value<double> savingsTarget = const Value.absent(),
                Value<double> savingsActual = const Value.absent(),
                Value<String?> questionHowMuch = const Value.absent(),
                Value<String?> questionSave = const Value.absent(),
                Value<String?> questionSpent = const Value.absent(),
                Value<String?> questionImprove = const Value.absent(),
                Value<String?> aiInsight = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KakeiboReflectionsTableCompanion.insert(
                id: id,
                familyId: familyId,
                userId: userId,
                year: year,
                month: month,
                incomeTotal: incomeTotal,
                expenseTotal: expenseTotal,
                savingsTarget: savingsTarget,
                savingsActual: savingsActual,
                questionHowMuch: questionHowMuch,
                questionSave: questionSave,
                questionSpent: questionSpent,
                questionImprove: questionImprove,
                aiInsight: aiInsight,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KakeiboReflectionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KakeiboReflectionsTableTable,
      KakeiboReflectionsTableData,
      $$KakeiboReflectionsTableTableFilterComposer,
      $$KakeiboReflectionsTableTableOrderingComposer,
      $$KakeiboReflectionsTableTableAnnotationComposer,
      $$KakeiboReflectionsTableTableCreateCompanionBuilder,
      $$KakeiboReflectionsTableTableUpdateCompanionBuilder,
      (
        KakeiboReflectionsTableData,
        BaseReferences<
          _$AppDatabase,
          $KakeiboReflectionsTableTable,
          KakeiboReflectionsTableData
        >,
      ),
      KakeiboReflectionsTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableTableCreateCompanionBuilder =
    SyncQueueTableCompanion Function({
      Value<int> id,
      required String operationType,
      required String tableName_,
      required String recordId,
      required String payload,
      Value<String> status,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime?> processedAt,
    });
typedef $$SyncQueueTableTableUpdateCompanionBuilder =
    SyncQueueTableCompanion Function({
      Value<int> id,
      Value<String> operationType,
      Value<String> tableName_,
      Value<String> recordId,
      Value<String> payload,
      Value<String> status,
      Value<int> attemptCount,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime?> processedAt,
    });

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tableName_ => $composableBuilder(
    column: $table.tableName_,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTableTable,
          SyncQueueTableData,
          $$SyncQueueTableTableFilterComposer,
          $$SyncQueueTableTableOrderingComposer,
          $$SyncQueueTableTableAnnotationComposer,
          $$SyncQueueTableTableCreateCompanionBuilder,
          $$SyncQueueTableTableUpdateCompanionBuilder,
          (
            SyncQueueTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncQueueTableTable,
              SyncQueueTableData
            >,
          ),
          SyncQueueTableData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableTableManager(
    _$AppDatabase db,
    $SyncQueueTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> tableName_ = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> processedAt = const Value.absent(),
              }) => SyncQueueTableCompanion(
                id: id,
                operationType: operationType,
                tableName_: tableName_,
                recordId: recordId,
                payload: payload,
                status: status,
                attemptCount: attemptCount,
                lastError: lastError,
                createdAt: createdAt,
                processedAt: processedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String operationType,
                required String tableName_,
                required String recordId,
                required String payload,
                Value<String> status = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> processedAt = const Value.absent(),
              }) => SyncQueueTableCompanion.insert(
                id: id,
                operationType: operationType,
                tableName_: tableName_,
                recordId: recordId,
                payload: payload,
                status: status,
                attemptCount: attemptCount,
                lastError: lastError,
                createdAt: createdAt,
                processedAt: processedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTableTable,
      SyncQueueTableData,
      $$SyncQueueTableTableFilterComposer,
      $$SyncQueueTableTableOrderingComposer,
      $$SyncQueueTableTableAnnotationComposer,
      $$SyncQueueTableTableCreateCompanionBuilder,
      $$SyncQueueTableTableUpdateCompanionBuilder,
      (
        SyncQueueTableData,
        BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>,
      ),
      SyncQueueTableData,
      PrefetchHooks Function()
    >;
typedef $$UserProfilesTableTableCreateCompanionBuilder =
    UserProfilesTableCompanion Function({
      required String id,
      required String email,
      required String displayName,
      Value<String?> avatarUrl,
      Value<String> role,
      Value<String> preferredCurrency,
      Value<bool> biometricEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$UserProfilesTableTableUpdateCompanionBuilder =
    UserProfilesTableCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> displayName,
      Value<String?> avatarUrl,
      Value<String> role,
      Value<String> preferredCurrency,
      Value<bool> biometricEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$UserProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredCurrency => $composableBuilder(
    column: $table.preferredCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredCurrency => $composableBuilder(
    column: $table.preferredCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get preferredCurrency => $composableBuilder(
    column: $table.preferredCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$UserProfilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTableTable,
          UserProfilesTableData,
          $$UserProfilesTableTableFilterComposer,
          $$UserProfilesTableTableOrderingComposer,
          $$UserProfilesTableTableAnnotationComposer,
          $$UserProfilesTableTableCreateCompanionBuilder,
          $$UserProfilesTableTableUpdateCompanionBuilder,
          (
            UserProfilesTableData,
            BaseReferences<
              _$AppDatabase,
              $UserProfilesTableTable,
              UserProfilesTableData
            >,
          ),
          UserProfilesTableData,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableTableManager(
    _$AppDatabase db,
    $UserProfilesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> preferredCurrency = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesTableCompanion(
                id: id,
                email: email,
                displayName: displayName,
                avatarUrl: avatarUrl,
                role: role,
                preferredCurrency: preferredCurrency,
                biometricEnabled: biometricEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String displayName,
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> preferredCurrency = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfilesTableCompanion.insert(
                id: id,
                email: email,
                displayName: displayName,
                avatarUrl: avatarUrl,
                role: role,
                preferredCurrency: preferredCurrency,
                biometricEnabled: biometricEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTableTable,
      UserProfilesTableData,
      $$UserProfilesTableTableFilterComposer,
      $$UserProfilesTableTableOrderingComposer,
      $$UserProfilesTableTableAnnotationComposer,
      $$UserProfilesTableTableCreateCompanionBuilder,
      $$UserProfilesTableTableUpdateCompanionBuilder,
      (
        UserProfilesTableData,
        BaseReferences<
          _$AppDatabase,
          $UserProfilesTableTable,
          UserProfilesTableData
        >,
      ),
      UserProfilesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EnvelopesTableTableTableManager get envelopesTable =>
      $$EnvelopesTableTableTableManager(_db, _db.envelopesTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$FamilyMembersTableTableTableManager get familyMembersTable =>
      $$FamilyMembersTableTableTableManager(_db, _db.familyMembersTable);
  $$KakeiboReflectionsTableTableTableManager get kakeiboReflectionsTable =>
      $$KakeiboReflectionsTableTableTableManager(
        _db,
        _db.kakeiboReflectionsTable,
      );
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
  $$UserProfilesTableTableTableManager get userProfilesTable =>
      $$UserProfilesTableTableTableManager(_db, _db.userProfilesTable);
}
