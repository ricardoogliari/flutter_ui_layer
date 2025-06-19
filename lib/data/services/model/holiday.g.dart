// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Holiday _$HolidayFromJson(Map<String, dynamic> json) => Holiday(
  json['date'] as String?,
  json['localName'] as String?,
  json['name'] as String?,
  json['countryCode'] as String?,
);

Map<String, dynamic> _$HolidayToJson(Holiday instance) => <String, dynamic>{
  'date': instance.date,
  'localName': instance.localName,
  'name': instance.name,
  'countryCode': instance.countryCode,
};
