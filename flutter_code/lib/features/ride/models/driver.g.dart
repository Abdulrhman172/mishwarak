// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverImpl _$$DriverImplFromJson(Map<String, dynamic> json) => _$DriverImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      rating: (json['rating'] as num).toDouble(),
      completedTrips: (json['completedTrips'] as num).toInt(),
      carModel: json['carModel'] as String,
      carColor: json['carColor'] as String,
      plateNumber: json['plateNumber'] as String,
      photoUrl: json['photoUrl'] as String?,
      isFemale: json['isFemale'] as bool? ?? false,
    );

Map<String, dynamic> _$$DriverImplToJson(_$DriverImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'rating': instance.rating,
      'completedTrips': instance.completedTrips,
      'carModel': instance.carModel,
      'carColor': instance.carColor,
      'plateNumber': instance.plateNumber,
      'photoUrl': instance.photoUrl,
      'isFemale': instance.isFemale,
    };

_$RideImpl _$$RideImplFromJson(Map<String, dynamic> json) => _$RideImpl(
      id: json['id'] as String,
      driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
      status: $enumDecode(_$RideStatusEnumMap, json['status']),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      pickupAddress: json['pickupAddress'] as String,
      destinationAddress: json['destinationAddress'] as String,
      pickupLat: (json['pickupLat'] as num).toDouble(),
      pickupLng: (json['pickupLng'] as num).toDouble(),
      destLat: (json['destLat'] as num).toDouble(),
      destLng: (json['destLng'] as num).toDouble(),
      fare: (json['fare'] as num).toInt(),
      distanceKm: (json['distanceKm'] as num).toInt(),
      paymentMethod: json['paymentMethod'] as String,
      tip: (json['tip'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RideImplToJson(_$RideImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'driver': instance.driver,
      'status': _$RideStatusEnumMap[instance.status]!,
      'requestedAt': instance.requestedAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'pickupAddress': instance.pickupAddress,
      'destinationAddress': instance.destinationAddress,
      'pickupLat': instance.pickupLat,
      'pickupLng': instance.pickupLng,
      'destLat': instance.destLat,
      'destLng': instance.destLng,
      'fare': instance.fare,
      'distanceKm': instance.distanceKm,
      'paymentMethod': instance.paymentMethod,
      'tip': instance.tip,
      'rating': instance.rating,
    };

const _$RideStatusEnumMap = {
  RideStatus.requested: 'requested',
  RideStatus.driverAssigned: 'driverAssigned',
  RideStatus.arriving: 'arriving',
  RideStatus.arrived: 'arrived',
  RideStatus.onTrip: 'onTrip',
  RideStatus.completed: 'completed',
  RideStatus.cancelled: 'cancelled',
};
