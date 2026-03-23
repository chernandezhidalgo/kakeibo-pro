// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FamilyMember {
  String get id => throw _privateConstructorUsedError;
  String get familyId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  FamilyMemberRole get role => throw _privateConstructorUsedError;
  String get avatarEmoji => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyMemberCopyWith<FamilyMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyMemberCopyWith<$Res> {
  factory $FamilyMemberCopyWith(
    FamilyMember value,
    $Res Function(FamilyMember) then,
  ) = _$FamilyMemberCopyWithImpl<$Res, FamilyMember>;
  @useResult
  $Res call({
    String id,
    String familyId,
    String userId,
    String displayName,
    FamilyMemberRole role,
    String avatarEmoji,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class _$FamilyMemberCopyWithImpl<$Res, $Val extends FamilyMember>
    implements $FamilyMemberCopyWith<$Res> {
  _$FamilyMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
    Object? avatarEmoji = null,
    Object? isActive = null,
    Object? createdAt = null,
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
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as FamilyMemberRole,
            avatarEmoji: null == avatarEmoji
                ? _value.avatarEmoji
                : avatarEmoji // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FamilyMemberImplCopyWith<$Res>
    implements $FamilyMemberCopyWith<$Res> {
  factory _$$FamilyMemberImplCopyWith(
    _$FamilyMemberImpl value,
    $Res Function(_$FamilyMemberImpl) then,
  ) = __$$FamilyMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String familyId,
    String userId,
    String displayName,
    FamilyMemberRole role,
    String avatarEmoji,
    bool isActive,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$FamilyMemberImplCopyWithImpl<$Res>
    extends _$FamilyMemberCopyWithImpl<$Res, _$FamilyMemberImpl>
    implements _$$FamilyMemberImplCopyWith<$Res> {
  __$$FamilyMemberImplCopyWithImpl(
    _$FamilyMemberImpl _value,
    $Res Function(_$FamilyMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? familyId = null,
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
    Object? avatarEmoji = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$FamilyMemberImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        familyId: null == familyId
            ? _value.familyId
            : familyId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as FamilyMemberRole,
        avatarEmoji: null == avatarEmoji
            ? _value.avatarEmoji
            : avatarEmoji // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$FamilyMemberImpl implements _FamilyMember {
  const _$FamilyMemberImpl({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.displayName,
    required this.role,
    this.avatarEmoji = '👤',
    required this.isActive,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final String familyId;
  @override
  final String userId;
  @override
  final String displayName;
  @override
  final FamilyMemberRole role;
  @override
  @JsonKey()
  final String avatarEmoji;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'FamilyMember(id: $id, familyId: $familyId, userId: $userId, displayName: $displayName, role: $role, avatarEmoji: $avatarEmoji, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.familyId, familyId) ||
                other.familyId == familyId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.avatarEmoji, avatarEmoji) ||
                other.avatarEmoji == avatarEmoji) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    familyId,
    userId,
    displayName,
    role,
    avatarEmoji,
    isActive,
    createdAt,
  );

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      __$$FamilyMemberImplCopyWithImpl<_$FamilyMemberImpl>(this, _$identity);
}

abstract class _FamilyMember implements FamilyMember {
  const factory _FamilyMember({
    required final String id,
    required final String familyId,
    required final String userId,
    required final String displayName,
    required final FamilyMemberRole role,
    final String avatarEmoji,
    required final bool isActive,
    required final DateTime createdAt,
  }) = _$FamilyMemberImpl;

  @override
  String get id;
  @override
  String get familyId;
  @override
  String get userId;
  @override
  String get displayName;
  @override
  FamilyMemberRole get role;
  @override
  String get avatarEmoji;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;

  /// Create a copy of FamilyMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyMemberImplCopyWith<_$FamilyMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
