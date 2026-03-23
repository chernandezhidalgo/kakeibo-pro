// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) auth,
    required TResult Function(String message) network,
    required TResult Function(String message) database,
    required TResult Function(String message) biometric,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? auth,
    TResult? Function(String message)? network,
    TResult? Function(String message)? database,
    TResult? Function(String message)? biometric,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? auth,
    TResult Function(String message)? network,
    TResult Function(String message)? database,
    TResult Function(String message)? biometric,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthFailure value) auth,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(BiometricFailure value) biometric,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(BiometricFailure value)? biometric,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthFailure value)? auth,
    TResult Function(NetworkFailure value)? network,
    TResult Function(DatabaseFailure value)? database,
    TResult Function(BiometricFailure value)? biometric,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$AuthFailureImplCopyWith(
    _$AuthFailureImpl value,
    $Res Function(_$AuthFailureImpl) then,
  ) = __$$AuthFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$AuthFailureImpl>
    implements _$$AuthFailureImplCopyWith<$Res> {
  __$$AuthFailureImplCopyWithImpl(
    _$AuthFailureImpl _value,
    $Res Function(_$AuthFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$AuthFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthFailureImpl implements AuthFailure {
  const _$AuthFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.auth(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      __$$AuthFailureImplCopyWithImpl<_$AuthFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) auth,
    required TResult Function(String message) network,
    required TResult Function(String message) database,
    required TResult Function(String message) biometric,
  }) {
    return auth(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? auth,
    TResult? Function(String message)? network,
    TResult? Function(String message)? database,
    TResult? Function(String message)? biometric,
  }) {
    return auth?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? auth,
    TResult Function(String message)? network,
    TResult Function(String message)? database,
    TResult Function(String message)? biometric,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthFailure value) auth,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(BiometricFailure value) biometric,
  }) {
    return auth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(BiometricFailure value)? biometric,
  }) {
    return auth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthFailure value)? auth,
    TResult Function(NetworkFailure value)? network,
    TResult Function(DatabaseFailure value)? database,
    TResult Function(BiometricFailure value)? biometric,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(this);
    }
    return orElse();
  }
}

abstract class AuthFailure implements Failure {
  const factory AuthFailure(final String message) = _$AuthFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$NetworkFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.network(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) auth,
    required TResult Function(String message) network,
    required TResult Function(String message) database,
    required TResult Function(String message) biometric,
  }) {
    return network(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? auth,
    TResult? Function(String message)? network,
    TResult? Function(String message)? database,
    TResult? Function(String message)? biometric,
  }) {
    return network?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? auth,
    TResult Function(String message)? network,
    TResult Function(String message)? database,
    TResult Function(String message)? biometric,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthFailure value) auth,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(BiometricFailure value) biometric,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(BiometricFailure value)? biometric,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthFailure value)? auth,
    TResult Function(NetworkFailure value)? network,
    TResult Function(DatabaseFailure value)? database,
    TResult Function(BiometricFailure value)? biometric,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure(final String message) = _$NetworkFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DatabaseFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$DatabaseFailureImplCopyWith(
    _$DatabaseFailureImpl value,
    $Res Function(_$DatabaseFailureImpl) then,
  ) = __$$DatabaseFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DatabaseFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$DatabaseFailureImpl>
    implements _$$DatabaseFailureImplCopyWith<$Res> {
  __$$DatabaseFailureImplCopyWithImpl(
    _$DatabaseFailureImpl _value,
    $Res Function(_$DatabaseFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$DatabaseFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DatabaseFailureImpl implements DatabaseFailure {
  const _$DatabaseFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.database(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatabaseFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatabaseFailureImplCopyWith<_$DatabaseFailureImpl> get copyWith =>
      __$$DatabaseFailureImplCopyWithImpl<_$DatabaseFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) auth,
    required TResult Function(String message) network,
    required TResult Function(String message) database,
    required TResult Function(String message) biometric,
  }) {
    return database(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? auth,
    TResult? Function(String message)? network,
    TResult? Function(String message)? database,
    TResult? Function(String message)? biometric,
  }) {
    return database?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? auth,
    TResult Function(String message)? network,
    TResult Function(String message)? database,
    TResult Function(String message)? biometric,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthFailure value) auth,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(BiometricFailure value) biometric,
  }) {
    return database(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(BiometricFailure value)? biometric,
  }) {
    return database?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthFailure value)? auth,
    TResult Function(NetworkFailure value)? network,
    TResult Function(DatabaseFailure value)? database,
    TResult Function(BiometricFailure value)? biometric,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(this);
    }
    return orElse();
  }
}

abstract class DatabaseFailure implements Failure {
  const factory DatabaseFailure(final String message) = _$DatabaseFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatabaseFailureImplCopyWith<_$DatabaseFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BiometricFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$BiometricFailureImplCopyWith(
    _$BiometricFailureImpl value,
    $Res Function(_$BiometricFailureImpl) then,
  ) = __$$BiometricFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$BiometricFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$BiometricFailureImpl>
    implements _$$BiometricFailureImplCopyWith<$Res> {
  __$$BiometricFailureImplCopyWithImpl(
    _$BiometricFailureImpl _value,
    $Res Function(_$BiometricFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$BiometricFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$BiometricFailureImpl implements BiometricFailure {
  const _$BiometricFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.biometric(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiometricFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BiometricFailureImplCopyWith<_$BiometricFailureImpl> get copyWith =>
      __$$BiometricFailureImplCopyWithImpl<_$BiometricFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) auth,
    required TResult Function(String message) network,
    required TResult Function(String message) database,
    required TResult Function(String message) biometric,
  }) {
    return biometric(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? auth,
    TResult? Function(String message)? network,
    TResult? Function(String message)? database,
    TResult? Function(String message)? biometric,
  }) {
    return biometric?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? auth,
    TResult Function(String message)? network,
    TResult Function(String message)? database,
    TResult Function(String message)? biometric,
    required TResult orElse(),
  }) {
    if (biometric != null) {
      return biometric(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthFailure value) auth,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(BiometricFailure value) biometric,
  }) {
    return biometric(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(BiometricFailure value)? biometric,
  }) {
    return biometric?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthFailure value)? auth,
    TResult Function(NetworkFailure value)? network,
    TResult Function(DatabaseFailure value)? database,
    TResult Function(BiometricFailure value)? biometric,
    required TResult orElse(),
  }) {
    if (biometric != null) {
      return biometric(this);
    }
    return orElse();
  }
}

abstract class BiometricFailure implements Failure {
  const factory BiometricFailure(final String message) = _$BiometricFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BiometricFailureImplCopyWith<_$BiometricFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
