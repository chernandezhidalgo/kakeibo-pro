// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$KakeiboFamily {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<FamilyMember> get members => throw _privateConstructorUsedError;

  /// Create a copy of KakeiboFamily
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KakeiboFamilyCopyWith<KakeiboFamily> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KakeiboFamilyCopyWith<$Res> {
  factory $KakeiboFamilyCopyWith(
    KakeiboFamily value,
    $Res Function(KakeiboFamily) then,
  ) = _$KakeiboFamilyCopyWithImpl<$Res, KakeiboFamily>;
  @useResult
  $Res call({
    String id,
    String name,
    DateTime createdAt,
    List<FamilyMember> members,
  });
}

/// @nodoc
class _$KakeiboFamilyCopyWithImpl<$Res, $Val extends KakeiboFamily>
    implements $KakeiboFamilyCopyWith<$Res> {
  _$KakeiboFamilyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KakeiboFamily
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? members = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            members: null == members
                ? _value.members
                : members // ignore: cast_nullable_to_non_nullable
                      as List<FamilyMember>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KakeiboFamilyImplCopyWith<$Res>
    implements $KakeiboFamilyCopyWith<$Res> {
  factory _$$KakeiboFamilyImplCopyWith(
    _$KakeiboFamilyImpl value,
    $Res Function(_$KakeiboFamilyImpl) then,
  ) = __$$KakeiboFamilyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    DateTime createdAt,
    List<FamilyMember> members,
  });
}

/// @nodoc
class __$$KakeiboFamilyImplCopyWithImpl<$Res>
    extends _$KakeiboFamilyCopyWithImpl<$Res, _$KakeiboFamilyImpl>
    implements _$$KakeiboFamilyImplCopyWith<$Res> {
  __$$KakeiboFamilyImplCopyWithImpl(
    _$KakeiboFamilyImpl _value,
    $Res Function(_$KakeiboFamilyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KakeiboFamily
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
    Object? members = null,
  }) {
    return _then(
      _$KakeiboFamilyImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        members: null == members
            ? _value._members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<FamilyMember>,
      ),
    );
  }
}

/// @nodoc

class _$KakeiboFamilyImpl implements _KakeiboFamily {
  const _$KakeiboFamilyImpl({
    required this.id,
    this.name = 'Familia Hernández-Romero',
    required this.createdAt,
    final List<FamilyMember> members = const [],
  }) : _members = members;

  @override
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  final DateTime createdAt;
  final List<FamilyMember> _members;
  @override
  @JsonKey()
  List<FamilyMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  String toString() {
    return 'KakeiboFamily(id: $id, name: $name, createdAt: $createdAt, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KakeiboFamilyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    createdAt,
    const DeepCollectionEquality().hash(_members),
  );

  /// Create a copy of KakeiboFamily
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KakeiboFamilyImplCopyWith<_$KakeiboFamilyImpl> get copyWith =>
      __$$KakeiboFamilyImplCopyWithImpl<_$KakeiboFamilyImpl>(this, _$identity);
}

abstract class _KakeiboFamily implements KakeiboFamily {
  const factory _KakeiboFamily({
    required final String id,
    final String name,
    required final DateTime createdAt,
    final List<FamilyMember> members,
  }) = _$KakeiboFamilyImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  DateTime get createdAt;
  @override
  List<FamilyMember> get members;

  /// Create a copy of KakeiboFamily
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KakeiboFamilyImplCopyWith<_$KakeiboFamilyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
