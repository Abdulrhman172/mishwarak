// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VehicleType _$VehicleTypeFromJson(Map<String, dynamic> json) {
  return _VehicleType.fromJson(json);
}

/// @nodoc
mixin _$VehicleType {
  String get id => throw _privateConstructorUsedError;
  VehicleCategory get category => throw _privateConstructorUsedError;
  String get nameAr => throw _privateConstructorUsedError;
  String get nameEn => throw _privateConstructorUsedError;
  String get descriptionAr => throw _privateConstructorUsedError;
  String get descriptionEn => throw _privateConstructorUsedError;
  int get seats => throw _privateConstructorUsedError;
  int get etaMinutes => throw _privateConstructorUsedError;
  int get price =>
      throw _privateConstructorUsedError; // السعر الأساسي بالريال اليمني
  /// يُضرب في المسافة ويُضاف للسعر الأساسي — راجع [FareCalculator].
  int get pricePerKm => throw _privateConstructorUsedError;
  int? get oldPrice => throw _privateConstructorUsedError;
  String? get badgeAr => throw _privateConstructorUsedError;
  String? get badgeEn => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this VehicleType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleTypeCopyWith<VehicleType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleTypeCopyWith<$Res> {
  factory $VehicleTypeCopyWith(
          VehicleType value, $Res Function(VehicleType) then) =
      _$VehicleTypeCopyWithImpl<$Res, VehicleType>;
  @useResult
  $Res call(
      {String id,
      VehicleCategory category,
      String nameAr,
      String nameEn,
      String descriptionAr,
      String descriptionEn,
      int seats,
      int etaMinutes,
      int price,
      int pricePerKm,
      int? oldPrice,
      String? badgeAr,
      String? badgeEn,
      String? imageUrl});
}

/// @nodoc
class _$VehicleTypeCopyWithImpl<$Res, $Val extends VehicleType>
    implements $VehicleTypeCopyWith<$Res> {
  _$VehicleTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? descriptionAr = null,
    Object? descriptionEn = null,
    Object? seats = null,
    Object? etaMinutes = null,
    Object? price = null,
    Object? pricePerKm = null,
    Object? oldPrice = freezed,
    Object? badgeAr = freezed,
    Object? badgeEn = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as VehicleCategory,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionAr: null == descriptionAr
          ? _value.descriptionAr
          : descriptionAr // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionEn: null == descriptionEn
          ? _value.descriptionEn
          : descriptionEn // ignore: cast_nullable_to_non_nullable
              as String,
      seats: null == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int,
      etaMinutes: null == etaMinutes
          ? _value.etaMinutes
          : etaMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerKm: null == pricePerKm
          ? _value.pricePerKm
          : pricePerKm // ignore: cast_nullable_to_non_nullable
              as int,
      oldPrice: freezed == oldPrice
          ? _value.oldPrice
          : oldPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      badgeAr: freezed == badgeAr
          ? _value.badgeAr
          : badgeAr // ignore: cast_nullable_to_non_nullable
              as String?,
      badgeEn: freezed == badgeEn
          ? _value.badgeEn
          : badgeEn // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VehicleTypeImplCopyWith<$Res>
    implements $VehicleTypeCopyWith<$Res> {
  factory _$$VehicleTypeImplCopyWith(
          _$VehicleTypeImpl value, $Res Function(_$VehicleTypeImpl) then) =
      __$$VehicleTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      VehicleCategory category,
      String nameAr,
      String nameEn,
      String descriptionAr,
      String descriptionEn,
      int seats,
      int etaMinutes,
      int price,
      int pricePerKm,
      int? oldPrice,
      String? badgeAr,
      String? badgeEn,
      String? imageUrl});
}

/// @nodoc
class __$$VehicleTypeImplCopyWithImpl<$Res>
    extends _$VehicleTypeCopyWithImpl<$Res, _$VehicleTypeImpl>
    implements _$$VehicleTypeImplCopyWith<$Res> {
  __$$VehicleTypeImplCopyWithImpl(
      _$VehicleTypeImpl _value, $Res Function(_$VehicleTypeImpl) _then)
      : super(_value, _then);

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? nameAr = null,
    Object? nameEn = null,
    Object? descriptionAr = null,
    Object? descriptionEn = null,
    Object? seats = null,
    Object? etaMinutes = null,
    Object? price = null,
    Object? pricePerKm = null,
    Object? oldPrice = freezed,
    Object? badgeAr = freezed,
    Object? badgeEn = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_$VehicleTypeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as VehicleCategory,
      nameAr: null == nameAr
          ? _value.nameAr
          : nameAr // ignore: cast_nullable_to_non_nullable
              as String,
      nameEn: null == nameEn
          ? _value.nameEn
          : nameEn // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionAr: null == descriptionAr
          ? _value.descriptionAr
          : descriptionAr // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionEn: null == descriptionEn
          ? _value.descriptionEn
          : descriptionEn // ignore: cast_nullable_to_non_nullable
              as String,
      seats: null == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int,
      etaMinutes: null == etaMinutes
          ? _value.etaMinutes
          : etaMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerKm: null == pricePerKm
          ? _value.pricePerKm
          : pricePerKm // ignore: cast_nullable_to_non_nullable
              as int,
      oldPrice: freezed == oldPrice
          ? _value.oldPrice
          : oldPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      badgeAr: freezed == badgeAr
          ? _value.badgeAr
          : badgeAr // ignore: cast_nullable_to_non_nullable
              as String?,
      badgeEn: freezed == badgeEn
          ? _value.badgeEn
          : badgeEn // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleTypeImpl extends _VehicleType {
  const _$VehicleTypeImpl(
      {required this.id,
      required this.category,
      required this.nameAr,
      required this.nameEn,
      required this.descriptionAr,
      required this.descriptionEn,
      required this.seats,
      required this.etaMinutes,
      required this.price,
      this.pricePerKm = 0,
      this.oldPrice,
      this.badgeAr,
      this.badgeEn,
      this.imageUrl})
      : super._();

  factory _$VehicleTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleTypeImplFromJson(json);

  @override
  final String id;
  @override
  final VehicleCategory category;
  @override
  final String nameAr;
  @override
  final String nameEn;
  @override
  final String descriptionAr;
  @override
  final String descriptionEn;
  @override
  final int seats;
  @override
  final int etaMinutes;
  @override
  final int price;
// السعر الأساسي بالريال اليمني
  /// يُضرب في المسافة ويُضاف للسعر الأساسي — راجع [FareCalculator].
  @override
  @JsonKey()
  final int pricePerKm;
  @override
  final int? oldPrice;
  @override
  final String? badgeAr;
  @override
  final String? badgeEn;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'VehicleType(id: $id, category: $category, nameAr: $nameAr, nameEn: $nameEn, descriptionAr: $descriptionAr, descriptionEn: $descriptionEn, seats: $seats, etaMinutes: $etaMinutes, price: $price, pricePerKm: $pricePerKm, oldPrice: $oldPrice, badgeAr: $badgeAr, badgeEn: $badgeEn, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleTypeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.nameAr, nameAr) || other.nameAr == nameAr) &&
            (identical(other.nameEn, nameEn) || other.nameEn == nameEn) &&
            (identical(other.descriptionAr, descriptionAr) ||
                other.descriptionAr == descriptionAr) &&
            (identical(other.descriptionEn, descriptionEn) ||
                other.descriptionEn == descriptionEn) &&
            (identical(other.seats, seats) || other.seats == seats) &&
            (identical(other.etaMinutes, etaMinutes) ||
                other.etaMinutes == etaMinutes) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.pricePerKm, pricePerKm) ||
                other.pricePerKm == pricePerKm) &&
            (identical(other.oldPrice, oldPrice) ||
                other.oldPrice == oldPrice) &&
            (identical(other.badgeAr, badgeAr) || other.badgeAr == badgeAr) &&
            (identical(other.badgeEn, badgeEn) || other.badgeEn == badgeEn) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      category,
      nameAr,
      nameEn,
      descriptionAr,
      descriptionEn,
      seats,
      etaMinutes,
      price,
      pricePerKm,
      oldPrice,
      badgeAr,
      badgeEn,
      imageUrl);

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleTypeImplCopyWith<_$VehicleTypeImpl> get copyWith =>
      __$$VehicleTypeImplCopyWithImpl<_$VehicleTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleTypeImplToJson(
      this,
    );
  }
}

abstract class _VehicleType extends VehicleType {
  const factory _VehicleType(
      {required final String id,
      required final VehicleCategory category,
      required final String nameAr,
      required final String nameEn,
      required final String descriptionAr,
      required final String descriptionEn,
      required final int seats,
      required final int etaMinutes,
      required final int price,
      final int pricePerKm,
      final int? oldPrice,
      final String? badgeAr,
      final String? badgeEn,
      final String? imageUrl}) = _$VehicleTypeImpl;
  const _VehicleType._() : super._();

  factory _VehicleType.fromJson(Map<String, dynamic> json) =
      _$VehicleTypeImpl.fromJson;

  @override
  String get id;
  @override
  VehicleCategory get category;
  @override
  String get nameAr;
  @override
  String get nameEn;
  @override
  String get descriptionAr;
  @override
  String get descriptionEn;
  @override
  int get seats;
  @override
  int get etaMinutes;
  @override
  int get price; // السعر الأساسي بالريال اليمني
  /// يُضرب في المسافة ويُضاف للسعر الأساسي — راجع [FareCalculator].
  @override
  int get pricePerKm;
  @override
  int? get oldPrice;
  @override
  String? get badgeAr;
  @override
  String? get badgeEn;
  @override
  String? get imageUrl;

  /// Create a copy of VehicleType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleTypeImplCopyWith<_$VehicleTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
