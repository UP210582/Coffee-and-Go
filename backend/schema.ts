import { PartType } from './schemas/PartType';
import { App } from './schemas/App';
import { DigitalAsset } from './schemas/DigitalAsset';
import { Asset } from './schemas/Asset';
import { User } from './schemas/User';
import { MeasurementGroup } from './schemas/PAdb/MeasurementGroup';
import { MetaData } from './schemas/PAdb/MetaData';
import { MetaUOMCodeAssignment } from './schemas/PAdb/MetaUOMCodeAssignment';
import { MetaUOMCode } from './schemas/PAdb/MetaUOMCode';
import { PartAttributeAssignment } from './schemas/PAdb/PartAttributeAssignment';
import { PartAttributeStyle } from './schemas/PAdb/PartAttributeStyle';
import { PartAttribute } from './schemas/PAdb/PartAttribute';
import { PartTypeStyle } from './schemas/PAdb/PartTypeStyle';
import { Style } from './schemas/PAdb/Style';
import { ValidValueAssignment } from './schemas/PAdb/ValidValueAssignment';
import { ValidValue } from './schemas/PAdb/ValidValue';
import { PAVersion } from './schemas/PAdb/Version'; 
import { ACESCodedValue } from './schemas/PCdb/ACESCodedValue';
import { Alias } from './schemas/PCdb/Alias';
import { Category } from './schemas/PCdb/Category';
import { CodeMaster } from './schemas/PCdb/CodeMaster';
import { PCChange } from './schemas/PCdb/Change';
import { PCChangeAttributeState } from './schemas/PCdb/ChangeAttributeState';
import { PCChangeDetail } from './schemas/PCdb/ChangeDetail';
import { PCChangeReason } from './schemas/PCdb/ChangeReason';
import { PCChangeTableName } from './schemas/PCdb/ChangeTableName';
import { Part } from './schemas/PCdb/Part';
import { PartsDescription } from './schemas/PCdb/PartsDescription';
import { PartsRelationship } from './schemas/PCdb/PartsRelationship';
import { PartsToAlias } from './schemas/PCdb/PartsToAlias';
import { PartsToUse } from './schemas/PCdb/PartsToUse';
import { Position } from './schemas/PCdb/Position';
import { Subcategory } from './schemas/PCdb/Subcategory';
import { Use } from './schemas/PCdb/Use';
import { PIESCode } from './schemas/PCdb/PIESCode';
import { PIESExpiCode } from './schemas/PCdb/PIESExpiCode';
import { PIESExpiGroup } from './schemas/PCdb/PIESExpiGroup';
import { PIESField } from './schemas/PCdb/PIESField';
import { PIESReferenceFieldCode } from './schemas/PCdb/PIESReferenceFieldCode';
import { PIESSegment } from './schemas/PCdb/PIESSegment';
import { PCVersion } from './schemas/PCdb/Version';
import { PartsSupersession } from './schemas/PCdb/PartsSupersession';
import { QChangeAttributeState } from './schemas/Qdb/ChangeAttributeState';
import { QChangeDetail } from './schemas/Qdb/ChangeDetail';
import { QChangeReason } from './schemas/Qdb/ChangeReason';
import { QChange } from './schemas/Qdb/Change';
import { QChangeTableName } from './schemas/Qdb/ChangeTableName';
import { GroupNumber } from './schemas/Qdb/GroupNumber';
import { QLanguage } from './schemas/Qdb/Language';
import { QdbChange } from './schemas/Qdb/QdbChange';
import { QQualifier } from './schemas/Qdb/Qualifier';
import { QualifierGroup } from './schemas/Qdb/QualifierGroup';
import { QualifierTranslation } from './schemas/Qdb/QualifierTranslation';
import { QualifierType } from './schemas/Qdb/QualifierType';
import { QVersion } from './schemas/Qdb/Version';
import { Abbreviation } from './schemas/VCdb/Abbreviation';
import { Aspiration } from './schemas/VCdb/Aspiration';
import { AttachmentType } from './schemas/VCdb/AttachmentType';
import { BaseVehicle } from './schemas/VCdb/BaseVehicle';
import { BedConfig } from './schemas/VCdb/BedConfig';
import { BodyType } from './schemas/VCdb/BodyType';
import {BodyNumDoors} from './schemas/VCdb/BodyNumDoor';
import { BodyStyleConfig } from './schemas/VCdb/BodyStyleConfig';
import { BrakeABS } from './schemas/VCdb/BrakeABS';
import { BrakeConfig } from './schemas/VCdb/BrakeConfig';
import { BrakeSystem } from './schemas/VCdb/BrakeSystem';
import { BrakeType } from './schemas/VCdb/BrakeType';
import { ChangeAttributeState } from './schemas/VCdb/ChangeAttributeState';
import { VCChangeDetail } from './schemas/VCdb/ChangeDetail';
import { VCChangeReason } from './schemas/VCdb/ChangeReason';
import { VCChange } from './schemas/VCdb/Change';
import { VCChangeTableName } from './schemas/VCdb/ChangeTableName';
import { Class } from './schemas/VCdb/Class';
import { CylinderHeadType } from './schemas/VCdb/CylinderHeadType';
import { DriveType } from './schemas/VCdb/DriveType';
import { ElecControlled } from './schemas/VCdb/ElecControlled';
import { EngineBase } from './schemas/VCdb/EngineBase';
import { EngineBase2 } from './schemas/VCdb/EngineBase2';
import { EngineBlock } from './schemas/VCdb/EngineBlock';
import { EngineBoreStroke } from './schemas/VCdb/EngineBoreStroke';
import { EngineConfig } from './schemas/VCdb/EngineConfig';
import { EngineConfig2 } from './schemas/VCdb/EngineConfig2';
import { EngineDesignation } from './schemas/VCdb/EngineDesignation';
import { EngineVersion } from './schemas/VCdb/EngineVersion';
import { EngineVIN } from './schemas/VCdb/EngineVIN';
import { EnglishPhrase } from './schemas/VCdb/EnglishPhrase';
import { Equipment } from './schemas/VCdb/Equipment';
import { EquipmentBase } from './schemas/VCdb/EquipmentBase';
import { EquipmentModel } from './schemas/VCdb/EquipmentModel';
import { EquipmentToEngineConfig } from './schemas/VCdb/EquipmentToEngineConfig';
import { FuelDeliveryConfig } from './schemas/VCdb/FuelDeliveryConfig';
import { FuelDeliverySubType } from './schemas/VCdb/FuelDeliverySubType';
import { FuelDeliveryType } from './schemas/VCdb/FuelDeliveryType';
import { FuelSystemControlType } from './schemas/VCdb/FuelSystemControlType';
import { FuelSystemDesign } from './schemas/VCdb/FuelSystemDesign';
import { FuelType } from './schemas/VCdb/FuelType';
import { IgnitionSystemType } from './schemas/VCdb/IgnitionSystemType';
import { VCLanguage } from './schemas/VCdb/Language';
import { LanguageTranslation } from './schemas/VCdb/LanguageTranslation';
import { LanguageTranslationAttachment } from './schemas/VCdb/LanguageTranslationAttachment';
import { Make } from './schemas/VCdb/Make';
import { Mfr } from './schemas/VCdb/Mfr';
import { MfrBodyCode } from './schemas/VCdb/MfrBodyCode';
import { Model } from './schemas/VCdb/Model';
import { PowerOutput } from './schemas/VCdb/PowerOutput';
import { PublicationStage } from './schemas/VCdb/PublicationStage';
import { Region } from './schemas/VCdb/Region';
import { SpringType } from './schemas/VCdb/SpringType';
import { SpringTypeConfig } from './schemas/VCdb/SpringTypeConfig';
import { SteeringConfig } from './schemas/VCdb/SteeringConfig';
import { SteeringSystem } from './schemas/VCdb/SteeringSystem';
import { SteeringType } from './schemas/VCdb/SteeringType';
import { SubModel } from './schemas/VCdb/SubModel';
import { Transmission } from './schemas/VCdb/Transmission';
import { TransmissionBase } from './schemas/VCdb/TransmissionBase';
import { TransmissionControlType } from './schemas/VCdb/TransmissionControlType';
import { TransmissionMfrCode } from './schemas/VCdb/TransmissionMfrCode';
import { TransmissionNumSpeed } from './schemas/VCdb/TransmissionNumSpeed';
import { TransmissionType } from './schemas/VCdb/TransmissionType';
import { Valve } from './schemas/VCdb/Valve';
import { VCdbChange } from './schemas/VCdb/VCdbChange';
import { Vehicle } from './schemas/VCdb/Vehicle';
import { VehicleToBedConfig } from './schemas/VCdb/VehicleToBedConfig';
import { VehicleToBodyConfig } from './schemas/VCdb/VehicleToBodyConfig';
import { VehicleToBodyStyleConfig } from './schemas/VCdb/VehicleToBodyStyleConfig';
import { VehicleToBrakeConfig } from './schemas/VCdb/VehicleToBrakeConfig';
import { VehicleToClass } from './schemas/VCdb/VehicleToClass';
import { VehicleToDriveType } from './schemas/VCdb/VehicleToDriveType';
import { VehicleToEngineConfig } from './schemas/VCdb/VehicleToEngineConfig';
import { VehicleToMfrBodyCode } from './schemas/VCdb/VehicleToMfrBodyCode';
import { VehicleToSpringTypeConfig } from './schemas/VCdb/VehicleToSpringTypeConfig';
import { VehicleToSteeringConfig } from './schemas/VCdb/VehicleToSteeringConfig';
import { VehicleToTransmission } from './schemas/VCdb/VehicleToTransmission';
import { VehicleToWheelbase } from './schemas/VCdb/VehicleToWheelBase';
import { VehicleType } from './schemas/VCdb/VehicleType';
import { VehicleTypeGroup } from './schemas/VCdb/VehicleTypeGroup';
import { Version } from './schemas/VCdb/Version';
import { WheelBase } from './schemas/VCdb/WheelBase';
import { Year } from './schemas/VCdb/Year';
import { BedLength } from './schemas/VCdb/BedLength';
import { BedType } from './schemas/VCdb/BedType';
import { PCdbPartTerminology } from './schemas/PCdb/PartTerminology';
import { Catalog } from './schemas/Catalog';
import { AcesApp } from './schemas/ACES/AcesApp';
import { AcesAsset } from './schemas/ACES/AcesAsset';
import { AcesDigitalFileInformation } from './schemas/ACES/AcesDigitalFileInformation';

export const lists = {
  App,
  Asset,
  User,
  DigitalAsset,
  PartType,
  Catalog,
  AcesApp,
  AcesAsset,
  AcesDigitalFileInformation,
  MeasurementGroup,
  MetaData,
  MetaUOMCodeAssignment,
  MetaUOMCode,
  PartAttributeAssignment,
  PartAttributeStyle,
  PartAttribute,
  PartTypeStyle,
  Style,
  ValidValueAssignment,
  ValidValue,
  PAVersion,
  ACESCodedValue,
  Alias,
  Category,
  CodeMaster,
  PCChange,
  PCChangeAttributeState,
  PCChangeDetail,
  PCChangeReason,
  PCChangeTableName,
  Part,
  PartsDescription,
  PartsRelationship,
  PartsToAlias,
  PartsToUse,
  Position,
  Subcategory,
  Use,
  PIESCode,
  PIESExpiCode,
  PIESExpiGroup,
  PIESField,
  PIESReferenceFieldCode,
  PIESSegment,
  PCVersion,
  PartsSupersession,
  QChangeAttributeState,
  QChangeDetail,
  QChangeReason,
  QChange,
  QChangeTableName,
  GroupNumber,
  QLanguage,
  QdbChange,
  QQualifier,
  QualifierGroup,
  QualifierTranslation,
  QualifierType,
  QVersion,
  Abbreviation,
  Aspiration,        
  AttachmentType,
  BaseVehicle,
  BedConfig,
  BodyType,
  BodyNumDoors,
  BodyStyleConfig,
  BrakeABS,
  BrakeConfig,
  BrakeSystem,
  BrakeType,
  ChangeAttributeState,
  VCChangeDetail,
  VCChangeReason,
  VCChange,
  VCChangeTableName,
  Class,
  CylinderHeadType,
  DriveType,
  ElecControlled,
  EngineBase,
  EngineBase2,
  EngineBlock,
  EngineBoreStroke,
  EngineConfig,
  EngineConfig2,
  EngineDesignation,
  EngineVersion,
  EngineVIN,
  EnglishPhrase,
  Equipment,
  EquipmentBase,
  EquipmentModel,
  EquipmentToEngineConfig,
  FuelDeliveryConfig,
  FuelDeliverySubType,
  FuelDeliveryType,
  FuelSystemControlType,
  FuelSystemDesign,
  FuelType,
  IgnitionSystemType,
  VCLanguage,
  LanguageTranslation,    
  LanguageTranslationAttachment,
  Make,
  Mfr,
  MfrBodyCode,
  Model,  
  PowerOutput,
  PublicationStage,
  Region,
  SpringType,
  SpringTypeConfig,
  SteeringConfig,
  SteeringSystem,
  SteeringType,
  SubModel,
  Transmission,
  TransmissionBase,
  TransmissionControlType,
  TransmissionMfrCode,
  TransmissionNumSpeed,
  TransmissionType,
  Valve,
  VCdbChange,
  Vehicle,
  VehicleToBedConfig,
  VehicleToBodyConfig,
  VehicleToBodyStyleConfig,
  VehicleToBrakeConfig,
  VehicleToClass,
  VehicleToDriveType,
  VehicleToEngineConfig,
  VehicleToMfrBodyCode,
  VehicleToSpringTypeConfig,
  VehicleToSteeringConfig,
  VehicleToTransmission,
  VehicleToWheelbase,
  VehicleType,
  VehicleTypeGroup,
  Version,
  WheelBase,
  Year,
  BedLength,
  BedType,
  PCdbPartTerminology
};
