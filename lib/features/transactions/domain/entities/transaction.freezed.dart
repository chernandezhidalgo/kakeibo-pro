// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  String get familyId => throw _privateConstructorUsedError;
  String? get envelopeId => throw _privateConstructorUsedError;
  String? get accountId => throw _privateConstructorUsedError;
  String get registeredBy => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get merchantName => throw _privateConstructorUsedError;
  DateTime get transactionDate => throw _privateConstructorUsedError;
  TransactionType get transactionType => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  TransactionSource get source => throw _privateConstructorUsedError;
  int? get dayOfWeek => throw _privateConstructorUsedError;
  int? get weekOfMonth => throw _privateConstructorUsedError;
  String? get emotionalTag => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    String id,
    String familyId,
    String? envelopeId,
    String? accountId,
    String registeredBy,
    double amount,
    String currency,
    String description,
    String? merchantName,
    DateTime transactionDate,
    TransactionType transactionType,
    TransactionStatus status,
    TransactionSource source,
    int? dayOfWeek,
    int? weekOfMonth,
    String? emotionalTag,
    double confidenceScore,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? envelopeId = freezed,
    Object? accountId = freezed,
    Object? registeredBy = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = null,
    Object? merchantName = freezed,
    Object? transactionDate = null,
    Object? transactionType = null,
    Object? status = null,
    Object? source = null,
    Object? dayOfWeek = freezed,
    Object? weekOfMonth = freezed,
    Object? emotionalTag = freezed,
    Object? confidenceScore = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            familyId: null == familyId
                ? _value.familyId
                : familyId // ignore: cast_nullable_to_non_nullable
                      as String,
            envelopeId: freezed == envelopeId
                ? _value.envelopeId
                : envelopeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            accountId: freezed == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            registeredBy: null == registeredBy
                ? _value.registeredBy
                : registeredBy // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            merchantName: freezed == merchantName
                ? _value.merchantName
                : merchantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            transactionDate: null == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            transactionType: null == transactionType
                ? _value.transactionType
                : transactionType // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TransactionStatus,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as TransactionSource,
            dayOfWeek: freezed == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                      as int?,
            weekOfMonth: freezed == weekOfMonth
                ? _value.weekOfMonth
                : weekOfMonth // ignore: cast_nullable_to_non_nullable
                      as int?,
            emotionalTag: freezed == emotionalTag
                ? _value.emotionalTag
                : emotionalTag // ignore: cast_nullable_to_non_nullable
                      as String?,
            confidenceScore: null == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String familyId,
    String? envelopeId,
    String? accountId,
    String registeredBy,
    double amount,
    String currency,
    String description,
    String? merchantName,
    DateTime transactionDate,
    TransactionType transactionType,
    TransactionStatus status,
    TransactionSource source,
    int? dayOfWeek,
    int? weekOfMonth,
    String? emotionalTag,
    double confidenceScore,
  });
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? envelopeId = freezed,
    Object? accountId = freezed,
    Object? registeredBy = null,
    Object? amount = null,
    Object? currency = null,
    Object? description = null,
    Object? merchantName = freezed,
    Object? transactionDate = null,
    Object? transactionType = null,
    Object? status = null,
    Object? source = null,
    Object? dayOfWeek = freezed,
    Object? weekOfMonth = freezed,
    Object? emotionalTag = freezed,
    Object? confidenceScore = null,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        familyId: null == familyId
            ? _value.familyId
            : familyId // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeId: freezed == envelopeId
            ? _value.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        accountId: freezed == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        registeredBy: null == registeredBy
            ? _value.registeredBy
            : registeredBy // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        merchantName: freezed == merchantName
            ? _value.merchantName
            : merchantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        transactionDate: null == transactionDate
            ? _value.transactionDate
            : transactionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        transactionType: null == transactionType
            ? _value.transactionType
            : transactionType // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TransactionStatus,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as TransactionSource,
        dayOfWeek: freezed == dayOfWeek
            ? _value.dayOfWeek
            : dayOfWeek // ignore: cast_nullable_to_non_nullable
                  as int?,
        weekOfMonth: freezed == weekOfMonth
            ? _value.weekOfMonth
            : weekOfMonth // ignore: cast_nullable_to_non_nullable
                  as int?,
        emotionalTag: freezed == emotionalTag
            ? _value.emotionalTag
            : emotionalTag // ignore: cast_nullable_to_non_nullable
                  as String?,
        confidenceScore: null == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl({
    required this.id,
    required this.familyId,
    this.envelopeId,
    this.accountId,
    required this.registeredBy,
    required this.amount,
    this.currency = 'CRC',
    required this.description,
    this.merchantName,
    required this.transactionDate,
    required this.transactionType,
    required this.status,
    required this.source,
    this.dayOfWeek,
    this.weekOfMonth,
    this.emotionalTag,
    this.confidenceScore = 1.0,
  });

  @override
  final String id;
  @override
  final String familyId;
  @override
  final String? envelopeId;
  @override
  final String? accountId;
  @override
  final String registeredBy;
  @override
  final double amount;
  @override
  @JsonKey()
  final String currency;
  @override
  final String description;
  @override
  final String? merchantName;
  @override
  final DateTime transactionDate;
  @override
  final TransactionType transactionType;
  @override
  final TransactionStatus status;
  @override
  final TransactionSource source;
  @override
  final int? dayOfWeek;
  @override
  final int? weekOfMonth;
  @override
  final String? emotionalTag;
  @override
  @JsonKey()
  final double confidenceScore;

  @override
  String toString() {
    return 'Transaction(id: $id, familyId: $familyId, envelopeId: $envelopeId, accountId: $accountId, registeredBy: $registeredBy, amount: $amount, currency: $currency, description: $description, merchantName: $merchantName, transactionDate: $transactionDate, transactionType: $transactionType, status: $status, source: $source, dayOfWeek: $dayOfWeek, weekOfMonth: $weekOfMonth, emotionalTag: $emotionalTag, confidenceScore: $confidenceScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.registeredBy, registeredBy) ||
                other.registeredBy == registeredBy) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.weekOfMonth, weekOfMonth) ||
                other.weekOfMonth == weekOfMonth) &&
            (identical(other.emotionalTag, emotionalTag) ||
                other.emotionalTag == emotionalTag) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    familyId,
    envelopeId,
    accountId,
    registeredBy,
    amount,
    currency,
    description,
    merchantName,
    transactionDate,
    transactionType,
    status,
    source,
    dayOfWeek,
    weekOfMonth,
    emotionalTag,
    confidenceScore,
  );

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);
}

abstract class _Transaction implements Transaction {
  const factory _Transaction({
    required final String id,
    required final String familyId,
    final String? envelopeId,
    final String? accountId,
    required final String registeredBy,
    required final double amount,
    final String currency,
    required final String description,
    final String? merchantName,
    required final DateTime transactionDate,
    required final TransactionType transactionType,
    required final TransactionStatus status,
    required final TransactionSource source,
    final int? dayOfWeek,
    final int? weekOfMonth,
    final String? emotionalTag,
    final double confidenceScore,
  }) = _$TransactionImpl;

  @override
  String get id;
  @override
  String get familyId;
  @override
  String? get envelopeId;
  @override
  String? get accountId;
  @override
  String get registeredBy;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get description;
  @override
  String? get merchantName;
  @override
  DateTime get transactionDate;
  @override
  TransactionType get transactionType;
  @override
  TransactionStatus get status;
  @override
  TransactionSource get source;
  @override
  int? get dayOfWeek;
  @override
  int? get weekOfMonth;
  @override
  String? get emotionalTag;
  @override
  double get confidenceScore;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
