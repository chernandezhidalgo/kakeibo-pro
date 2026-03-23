// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'envelope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Envelope {
  String get id => throw _privateConstructorUsedError;
  String get familyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  KakeiboCategory get kakeiboCategory => throw _privateConstructorUsedError;
  double get monthlyBudget => throw _privateConstructorUsedError;
  double get currentSpent => throw _privateConstructorUsedError;
  String get colorHex => throw _privateConstructorUsedError;
  String get iconEmoji => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isEditable => throw _privateConstructorUsedError;

  /// Create a copy of Envelope
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnvelopeCopyWith<Envelope> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnvelopeCopyWith<$Res> {
  factory $EnvelopeCopyWith(Envelope value, $Res Function(Envelope) then) =
      _$EnvelopeCopyWithImpl<$Res, Envelope>;
  @useResult
  $Res call({
    String id,
    String familyId,
    String name,
    String? description,
    KakeiboCategory kakeiboCategory,
    double monthlyBudget,
    double currentSpent,
    String colorHex,
    String iconEmoji,
    int sortOrder,
    bool isActive,
    bool isEditable,
  });
}

/// @nodoc
class _$EnvelopeCopyWithImpl<$Res, $Val extends Envelope>
    implements $EnvelopeCopyWith<$Res> {
  _$EnvelopeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Envelope
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? name = null,
    Object? description = freezed,
    Object? kakeiboCategory = null,
    Object? monthlyBudget = null,
    Object? currentSpent = null,
    Object? colorHex = null,
    Object? iconEmoji = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? isEditable = null,
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
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            kakeiboCategory: null == kakeiboCategory
                ? _value.kakeiboCategory
                : kakeiboCategory // ignore: cast_nullable_to_non_nullable
                      as KakeiboCategory,
            monthlyBudget: null == monthlyBudget
                ? _value.monthlyBudget
                : monthlyBudget // ignore: cast_nullable_to_non_nullable
                      as double,
            currentSpent: null == currentSpent
                ? _value.currentSpent
                : currentSpent // ignore: cast_nullable_to_non_nullable
                      as double,
            colorHex: null == colorHex
                ? _value.colorHex
                : colorHex // ignore: cast_nullable_to_non_nullable
                      as String,
            iconEmoji: null == iconEmoji
                ? _value.iconEmoji
                : iconEmoji // ignore: cast_nullable_to_non_nullable
                      as String,
            sortOrder: null == sortOrder
                ? _value.sortOrder
                : sortOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isEditable: null == isEditable
                ? _value.isEditable
                : isEditable // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EnvelopeImplCopyWith<$Res>
    implements $EnvelopeCopyWith<$Res> {
  factory _$$EnvelopeImplCopyWith(
    _$EnvelopeImpl value,
    $Res Function(_$EnvelopeImpl) then,
  ) = __$$EnvelopeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String familyId,
    String name,
    String? description,
    KakeiboCategory kakeiboCategory,
    double monthlyBudget,
    double currentSpent,
    String colorHex,
    String iconEmoji,
    int sortOrder,
    bool isActive,
    bool isEditable,
  });
}

/// @nodoc
class __$$EnvelopeImplCopyWithImpl<$Res>
    extends _$EnvelopeCopyWithImpl<$Res, _$EnvelopeImpl>
    implements _$$EnvelopeImplCopyWith<$Res> {
  __$$EnvelopeImplCopyWithImpl(
    _$EnvelopeImpl _value,
    $Res Function(_$EnvelopeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Envelope
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? name = null,
    Object? description = freezed,
    Object? kakeiboCategory = null,
    Object? monthlyBudget = null,
    Object? currentSpent = null,
    Object? colorHex = null,
    Object? iconEmoji = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? isEditable = null,
  }) {
    return _then(
      _$EnvelopeImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        familyId: null == familyId
            ? _value.familyId
            : familyId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        kakeiboCategory: null == kakeiboCategory
            ? _value.kakeiboCategory
            : kakeiboCategory // ignore: cast_nullable_to_non_nullable
                  as KakeiboCategory,
        monthlyBudget: null == monthlyBudget
            ? _value.monthlyBudget
            : monthlyBudget // ignore: cast_nullable_to_non_nullable
                  as double,
        currentSpent: null == currentSpent
            ? _value.currentSpent
            : currentSpent // ignore: cast_nullable_to_non_nullable
                  as double,
        colorHex: null == colorHex
            ? _value.colorHex
            : colorHex // ignore: cast_nullable_to_non_nullable
                  as String,
        iconEmoji: null == iconEmoji
            ? _value.iconEmoji
            : iconEmoji // ignore: cast_nullable_to_non_nullable
                  as String,
        sortOrder: null == sortOrder
            ? _value.sortOrder
            : sortOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isEditable: null == isEditable
            ? _value.isEditable
            : isEditable // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$EnvelopeImpl implements _Envelope {
  const _$EnvelopeImpl({
    required this.id,
    required this.familyId,
    required this.name,
    this.description,
    required this.kakeiboCategory,
    required this.monthlyBudget,
    required this.currentSpent,
    this.colorHex = '#5b9cf6',
    this.iconEmoji = '💰',
    required this.sortOrder,
    required this.isActive,
    required this.isEditable,
  });

  @override
  final String id;
  @override
  final String familyId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final KakeiboCategory kakeiboCategory;
  @override
  final double monthlyBudget;
  @override
  final double currentSpent;
  @override
  @JsonKey()
  final String colorHex;
  @override
  @JsonKey()
  final String iconEmoji;
  @override
  final int sortOrder;
  @override
  final bool isActive;
  @override
  final bool isEditable;

  @override
  String toString() {
    return 'Envelope(id: $id, familyId: $familyId, name: $name, description: $description, kakeiboCategory: $kakeiboCategory, monthlyBudget: $monthlyBudget, currentSpent: $currentSpent, colorHex: $colorHex, iconEmoji: $iconEmoji, sortOrder: $sortOrder, isActive: $isActive, isEditable: $isEditable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnvelopeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.kakeiboCategory, kakeiboCategory) ||
                other.kakeiboCategory == kakeiboCategory) &&
            (identical(other.monthlyBudget, monthlyBudget) ||
                other.monthlyBudget == monthlyBudget) &&
            (identical(other.currentSpent, currentSpent) ||
                other.currentSpent == currentSpent) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.iconEmoji, iconEmoji) ||
                other.iconEmoji == iconEmoji) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    familyId,
    name,
    description,
    kakeiboCategory,
    monthlyBudget,
    currentSpent,
    colorHex,
    iconEmoji,
    sortOrder,
    isActive,
    isEditable,
  );

  /// Create a copy of Envelope
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnvelopeImplCopyWith<_$EnvelopeImpl> get copyWith =>
      __$$EnvelopeImplCopyWithImpl<_$EnvelopeImpl>(this, _$identity);
}

abstract class _Envelope implements Envelope {
  const factory _Envelope({
    required final String id,
    required final String familyId,
    required final String name,
    final String? description,
    required final KakeiboCategory kakeiboCategory,
    required final double monthlyBudget,
    required final double currentSpent,
    final String colorHex,
    final String iconEmoji,
    required final int sortOrder,
    required final bool isActive,
    required final bool isEditable,
  }) = _$EnvelopeImpl;

  @override
  String get id;
  @override
  String get familyId;
  @override
  String get name;
  @override
  String? get description;
  @override
  KakeiboCategory get kakeiboCategory;
  @override
  double get monthlyBudget;
  @override
  double get currentSpent;
  @override
  String get colorHex;
  @override
  String get iconEmoji;
  @override
  int get sortOrder;
  @override
  bool get isActive;
  @override
  bool get isEditable;

  /// Create a copy of Envelope
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnvelopeImplCopyWith<_$EnvelopeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
