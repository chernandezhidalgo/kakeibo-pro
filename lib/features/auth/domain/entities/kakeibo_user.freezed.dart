// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kakeibo_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$KakeiboUser {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of KakeiboUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KakeiboUserCopyWith<KakeiboUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KakeiboUserCopyWith<$Res> {
  factory $KakeiboUserCopyWith(
    KakeiboUser value,
    $Res Function(KakeiboUser) then,
  ) = _$KakeiboUserCopyWithImpl<$Res, KakeiboUser>;
  @useResult
  $Res call({
    String id,
    String email,
    bool isEmailVerified,
    DateTime createdAt,
  });
}

/// @nodoc
class _$KakeiboUserCopyWithImpl<$Res, $Val extends KakeiboUser>
    implements $KakeiboUserCopyWith<$Res> {
  _$KakeiboUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KakeiboUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? isEmailVerified = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            isEmailVerified: null == isEmailVerified
                ? _value.isEmailVerified
                : isEmailVerified // ignore: cast_nullable_to_non_nullable
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
abstract class _$$KakeiboUserImplCopyWith<$Res>
    implements $KakeiboUserCopyWith<$Res> {
  factory _$$KakeiboUserImplCopyWith(
    _$KakeiboUserImpl value,
    $Res Function(_$KakeiboUserImpl) then,
  ) = __$$KakeiboUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    bool isEmailVerified,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$KakeiboUserImplCopyWithImpl<$Res>
    extends _$KakeiboUserCopyWithImpl<$Res, _$KakeiboUserImpl>
    implements _$$KakeiboUserImplCopyWith<$Res> {
  __$$KakeiboUserImplCopyWithImpl(
    _$KakeiboUserImpl _value,
    $Res Function(_$KakeiboUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KakeiboUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? isEmailVerified = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$KakeiboUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        isEmailVerified: null == isEmailVerified
            ? _value.isEmailVerified
            : isEmailVerified // ignore: cast_nullable_to_non_nullable
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

class _$KakeiboUserImpl implements _KakeiboUser {
  const _$KakeiboUserImpl({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final String email;
  @override
  final bool isEmailVerified;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'KakeiboUser(id: $id, email: $email, isEmailVerified: $isEmailVerified, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KakeiboUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, email, isEmailVerified, createdAt);

  /// Create a copy of KakeiboUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KakeiboUserImplCopyWith<_$KakeiboUserImpl> get copyWith =>
      __$$KakeiboUserImplCopyWithImpl<_$KakeiboUserImpl>(this, _$identity);
}

abstract class _KakeiboUser implements KakeiboUser {
  const factory _KakeiboUser({
    required final String id,
    required final String email,
    required final bool isEmailVerified,
    required final DateTime createdAt,
  }) = _$KakeiboUserImpl;

  @override
  String get id;
  @override
  String get email;
  @override
  bool get isEmailVerified;
  @override
  DateTime get createdAt;

  /// Create a copy of KakeiboUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KakeiboUserImplCopyWith<_$KakeiboUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
