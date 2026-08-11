// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleTypeImpl _$$VehicleTypeImplFromJson(Map<String, dynamic> json) =>
    _$VehicleTypeImpl(
      id: json['id'] as String,
      category: $enumDecode(_$VehicleCategoryEnumMap, json['category']),
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      descriptionAr: json['descriptionAr'] as String,
      descriptionEn: json['descriptionEn'] as String,
      seats: (json['seats'] as num).toInt(),
      etaMinutes: (json['etaMinutes'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      oldPrice: (json['oldPrice'] as num?)?.toInt(),
      badgeAr: json['badgeAr'] as String?,
      badgeEn: json['badgeEn'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$VehicleTypeImplToJson(_$VehicleTypeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': _$VehicleCategoryEnumMap[instance.category]!,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'descriptionAr': instance.descriptionAr,
      'descriptionEn': instance.descriptionEn,
      'seats': instance.seats,
      'etaMinutes': instance.etaMinutes,
      'price': instance.price,
      'oldPrice': instance.oldPrice,
      'badgeAr': instance.badgeAr,
      'badgeEn': instance.badgeEn,
      'imageUrl': instance.imageUrl,
    };

const _$VehicleCategoryEnumMap = {
  VehicleCategory.economy: 'economy',
  VehicleCategory.comfort: 'comfort',
  VehicleCategory.xl: 'xl',
  VehicleCategory.women: 'women',
  VehicleCategory.vip: 'vip',
};
