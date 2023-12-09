// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'framedata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrameData _$FrameDataFromJson(Map<String, dynamic> json) => FrameData()
  ..moveName = json['moveName'] as String
  ..command1 = json['command1'] as String
  ..command2 = json['command2'] as String
  ..command3 = json['command3'] as String
  ..command4 = json['command4'] as String
  ..air = json['air'] as int
  ..startUp = json['startUp'] as int
  ..active = json['active'] as int
  ..recovery = json['recovery'] as int
  ..hitStun = json['hitStun'] as int
  ..blockStun = json['blockStun'] as int
  ..cancelType = json['cancelType'] as String
  ..damage = json['damage'] as int
  ..scaling = json['scaling'] as int
  ..dGageUp = json['dGageUp'] as int
  ..dGageDown = json['dGageDown'] as int
  ..dGageCounter = json['dGageCounter'] as int
  ..sGageUp = json['sGageUp'] as int
  ..properties = json['properties'] as String
  ..detail = json['detail'] as String;

Map<String, dynamic> _$FrameDataToJson(FrameData instance) => <String, dynamic>{
      'moveName': instance.moveName,
      'command1': instance.command1,
      'command2': instance.command2,
      'command3': instance.command3,
      'command4': instance.command4,
      'air': instance.air,
      'startUp': instance.startUp,
      'active': instance.active,
      'recovery': instance.recovery,
      'hitStun': instance.hitStun,
      'blockStun': instance.blockStun,
      'cancelType': instance.cancelType,
      'damage': instance.damage,
      'scaling': instance.scaling,
      'dGageUp': instance.dGageUp,
      'dGageDown': instance.dGageDown,
      'dGageCounter': instance.dGageCounter,
      'sGageUp': instance.sGageUp,
      'properties': instance.properties,
      'detail': instance.detail,
    };
