/*
  Warnings:

  - You are about to drop the column `make` on the `BaseVehicle` table. All the data in the column will be lost.
  - You are about to drop the column `model` on the `BaseVehicle` table. All the data in the column will be lost.
  - You are about to drop the column `yearId` on the `BaseVehicle` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `Make` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `Model` table. All the data in the column will be lost.
  - You are about to drop the `PCdbPartType` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `QdbQualifierCode` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Qualifier` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `VCdbEngineBase` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `VCdbMake` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `VCdbModel` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[BaseVehicleID]` on the table `BaseVehicle` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[MakeID]` on the table `Make` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[ModelID]` on the table `Model` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `BaseVehicleID` to the `BaseVehicle` table without a default value. This is not possible if the table is not empty.
  - Added the required column `MakeID` to the `Make` table without a default value. This is not possible if the table is not empty.
  - Added the required column `ModelID` to the `Model` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "BaseVehicle" DROP CONSTRAINT "BaseVehicle_make_fkey";

-- DropForeignKey
ALTER TABLE "BaseVehicle" DROP CONSTRAINT "BaseVehicle_model_fkey";

-- DropForeignKey
ALTER TABLE "Qualifier" DROP CONSTRAINT "Qualifier_app_fkey";

-- DropForeignKey
ALTER TABLE "VCdbModel" DROP CONSTRAINT "VCdbModel_vcdbMake_fkey";

-- DropIndex
DROP INDEX "BaseVehicle_make_idx";

-- DropIndex
DROP INDEX "BaseVehicle_model_idx";

-- AlterTable
ALTER TABLE "BaseVehicle" DROP COLUMN "make",
DROP COLUMN "model",
DROP COLUMN "yearId",
ADD COLUMN     "BaseVehicleID" INTEGER NOT NULL,
ADD COLUMN     "MakeID" TEXT,
ADD COLUMN     "ModelID" TEXT,
ADD COLUMN     "YearID" TEXT;

-- AlterTable
ALTER TABLE "Make" DROP COLUMN "name",
ADD COLUMN     "MakeID" INTEGER NOT NULL,
ADD COLUMN     "MakeName" TEXT NOT NULL DEFAULT '';

-- AlterTable
ALTER TABLE "Model" DROP COLUMN "name",
ADD COLUMN     "ModelID" INTEGER NOT NULL,
ADD COLUMN     "ModelName" TEXT NOT NULL DEFAULT '',
ADD COLUMN     "VehicleTypeID" TEXT;

-- DropTable
DROP TABLE "PCdbPartType";

-- DropTable
DROP TABLE "QdbQualifierCode";

-- DropTable
DROP TABLE "Qualifier";

-- DropTable
DROP TABLE "VCdbEngineBase";

-- DropTable
DROP TABLE "VCdbMake";

-- DropTable
DROP TABLE "VCdbModel";

-- CreateTable
CREATE TABLE "Catalog" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "file_filesize" INTEGER,
    "file_filename" TEXT,
    "message" TEXT NOT NULL DEFAULT '',
    "createdAt" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MeasurementGroup" (
    "id" TEXT NOT NULL,
    "measurementGroupID" INTEGER NOT NULL,
    "measurementGroupName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "MeasurementGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MetaData" (
    "id" TEXT NOT NULL,
    "metaID" INTEGER NOT NULL,
    "metaName" TEXT NOT NULL DEFAULT '',
    "metaDescr" TEXT NOT NULL DEFAULT '',
    "metaFormat" TEXT NOT NULL DEFAULT '',
    "dataType" TEXT NOT NULL DEFAULT '',
    "minLength" INTEGER,
    "maxLength" INTEGER,

    CONSTRAINT "MetaData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MetaUOMCodeAssignment" (
    "id" TEXT NOT NULL,
    "metaUOMCodeAssignmentID" INTEGER NOT NULL,
    "paptID" INTEGER NOT NULL,
    "metaUOMID" INTEGER NOT NULL,

    CONSTRAINT "MetaUOMCodeAssignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MetaUOMCode" (
    "id" TEXT NOT NULL,
    "metaUOMID" INTEGER NOT NULL,
    "uomCode" TEXT NOT NULL DEFAULT '',
    "uomDescription" TEXT NOT NULL DEFAULT '',
    "uomLabel" TEXT NOT NULL DEFAULT '',
    "measurementGroupID" INTEGER NOT NULL,

    CONSTRAINT "MetaUOMCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartAttributeAssignment" (
    "id" TEXT NOT NULL,
    "paptID" INTEGER NOT NULL,
    "partTerminologyID" INTEGER NOT NULL,
    "paid" INTEGER NOT NULL,
    "metaID" INTEGER NOT NULL,

    CONSTRAINT "PartAttributeAssignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartAttributeStyle" (
    "id" TEXT NOT NULL,
    "styleID" INTEGER,
    "paptID" INTEGER,

    CONSTRAINT "PartAttributeStyle_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartAttribute" (
    "id" TEXT NOT NULL,
    "paid" INTEGER NOT NULL,
    "paName" TEXT NOT NULL DEFAULT '',
    "paDescr" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PartAttribute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartTypeStyle" (
    "id" TEXT NOT NULL,
    "styleID" INTEGER,
    "partTerminologyID" INTEGER,

    CONSTRAINT "PartTypeStyle_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Style" (
    "id" TEXT NOT NULL,
    "styleID" INTEGER,
    "styleName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Style_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ValidValueAssignment" (
    "id" TEXT NOT NULL,
    "validValueAssignmentID" INTEGER NOT NULL,
    "paptID" INTEGER NOT NULL,
    "validValueID" INTEGER NOT NULL,

    CONSTRAINT "ValidValueAssignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ValidValue" (
    "id" TEXT NOT NULL,
    "validValueID" INTEGER NOT NULL,
    "validValue" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "ValidValue_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PAVersion" (
    "id" TEXT NOT NULL,
    "pAdbVersion" TEXT NOT NULL DEFAULT '',
    "pAdbPublication" DATE,
    "pCdbPublication" DATE,

    CONSTRAINT "PAVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ACESCodedValue" (
    "id" TEXT NOT NULL,
    "Element" TEXT NOT NULL DEFAULT '',
    "Attribute" TEXT NOT NULL DEFAULT '',
    "CodedValue" TEXT NOT NULL DEFAULT '',
    "CodeDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "ACESCodedValue_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Alias" (
    "id" TEXT NOT NULL,
    "AliasID" INTEGER NOT NULL,
    "AliasName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Alias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Category" (
    "id" TEXT NOT NULL,
    "CategoryID" INTEGER NOT NULL,
    "CategoryName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CodeMaster" (
    "id" TEXT NOT NULL,
    "CodeMasterID" INTEGER NOT NULL,
    "CategoryID" TEXT,
    "SubCategoryID" TEXT,
    "PositionID" TEXT,
    "RevDate" TIMESTAMP(3),

    CONSTRAINT "CodeMaster_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PCChange" (
    "id" TEXT NOT NULL,
    "ChangeID" INTEGER NOT NULL,
    "RequestID" INTEGER NOT NULL,
    "ChangeReasonID" TEXT,
    "RevDate" TIMESTAMP(3),

    CONSTRAINT "PCChange_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PCChangeAttributeState" (
    "id" TEXT NOT NULL,
    "ChangeAttributeStateID" INTEGER NOT NULL,
    "ChangeAttributeState" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PCChangeAttributeState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PCChangeDetail" (
    "id" TEXT NOT NULL,
    "ChangeDetailID" INTEGER NOT NULL,
    "ChangeID" TEXT,
    "ChangeAttributeStateID" TEXT,
    "TableNameID" TEXT,
    "PrimaryKeyColumnName" TEXT NOT NULL DEFAULT '',
    "PrimaryKeyBefore" INTEGER,
    "PrimaryKeyAfter" INTEGER,
    "ColumnName" TEXT NOT NULL DEFAULT '',
    "ColumnValueBefore" TEXT NOT NULL DEFAULT '',
    "ColumnValueAfter" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PCChangeDetail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PCChangeReason" (
    "id" TEXT NOT NULL,
    "ChangeReasonID" INTEGER NOT NULL,
    "ChangeReason" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PCChangeReason_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PCChangeTableName" (
    "id" TEXT NOT NULL,
    "TableNameID" INTEGER NOT NULL,
    "TableName" TEXT NOT NULL DEFAULT '',
    "TableDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PCChangeTableName_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Part" (
    "id" TEXT NOT NULL,
    "PartTerminologyID" INTEGER NOT NULL,
    "PartTerminologyName" TEXT NOT NULL DEFAULT '',
    "PartsDescriptionID" TEXT,
    "RevDate" TIMESTAMP(3),

    CONSTRAINT "Part_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartsDescription" (
    "id" TEXT NOT NULL,
    "PartsDescriptionID" INTEGER NOT NULL,
    "PartsDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PartsDescription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartsRelationship" (
    "id" TEXT NOT NULL,
    "PartTerminology" TEXT,

    CONSTRAINT "PartsRelationship_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartsToAlias" (
    "id" TEXT NOT NULL,
    "PartTerminology" TEXT,
    "alias" TEXT,

    CONSTRAINT "PartsToAlias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartsToUse" (
    "id" TEXT NOT NULL,
    "PartTerminology" TEXT,
    "Use" TEXT,

    CONSTRAINT "PartsToUse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Position" (
    "id" TEXT NOT NULL,
    "PositionID" INTEGER NOT NULL,
    "Position" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Subcategory" (
    "id" TEXT NOT NULL,
    "SubCategoryID" INTEGER NOT NULL,
    "SubCategoryName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Subcategory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Use" (
    "id" TEXT NOT NULL,
    "UseID" INTEGER NOT NULL,
    "UseDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Use_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PIESCode" (
    "id" TEXT NOT NULL,
    "PIESCodeId" INTEGER NOT NULL,
    "CodeValue" TEXT NOT NULL DEFAULT '',
    "CodeFormat" TEXT NOT NULL DEFAULT '',
    "FieldFormat" TEXT NOT NULL DEFAULT '',
    "CodeDescription" TEXT NOT NULL DEFAULT '',
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PIESCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PIESExpiCode" (
    "id" TEXT NOT NULL,
    "PIESExpiCodeId" INTEGER NOT NULL,
    "ExpiCode" TEXT NOT NULL DEFAULT '',
    "ExpiCodeDescription" TEXT NOT NULL DEFAULT '',
    "PIESExpiGroupId" TEXT,

    CONSTRAINT "PIESExpiCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PIESExpiGroup" (
    "id" TEXT NOT NULL,
    "PIESExpiGroupId" INTEGER NOT NULL,
    "ExpiGroupCode" TEXT NOT NULL DEFAULT '',
    "ExpiGroupDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PIESExpiGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PIESField" (
    "id" TEXT NOT NULL,
    "PIESFieldId" INTEGER NOT NULL,
    "FieldName" TEXT NOT NULL DEFAULT '',
    "ReferenceFieldNumber" TEXT NOT NULL DEFAULT '',
    "PIESSegmentId" TEXT,

    CONSTRAINT "PIESField_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PIESReferenceFieldCode" (
    "id" TEXT NOT NULL,
    "PIESReferenceFieldCodeId" INTEGER NOT NULL,
    "PIESFieldId" TEXT,
    "PIESCodeId" TEXT,
    "PIESExpiCodeId" TEXT,
    "ReferenceNotes" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PIESReferenceFieldCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PIESSegment" (
    "id" TEXT NOT NULL,
    "PIESSegmentId" INTEGER NOT NULL,
    "SegmentAbb" TEXT NOT NULL DEFAULT '',
    "SegmentName" TEXT NOT NULL DEFAULT '',
    "SegmentDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PIESSegment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PCVersion" (
    "id" TEXT NOT NULL,
    "VersionDate" TIMESTAMP(3),

    CONSTRAINT "PCVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartsSupersession" (
    "id" TEXT NOT NULL,
    "OldPartTerminologyID" INTEGER NOT NULL,
    "OldPartTerminologyName" TEXT NOT NULL DEFAULT '',
    "NewPartTerminologyID" INTEGER NOT NULL,
    "NewPartTerminologyName" TEXT NOT NULL DEFAULT '',
    "RevDate" TIMESTAMP(3),

    CONSTRAINT "PartsSupersession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QChangeAttributeState" (
    "id" TEXT NOT NULL,
    "ChangeAttributeStateID" INTEGER NOT NULL,
    "ChangeAttributeState" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "QChangeAttributeState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QChangeDetail" (
    "id" TEXT NOT NULL,
    "ChangeDetailID" INTEGER NOT NULL,
    "ChangeID" TEXT,
    "ChangeAttributeStateID" TEXT,
    "TableNameID" TEXT,
    "PrimaryKeyColumnName" TEXT NOT NULL DEFAULT '',
    "PrimaryKeyBefore" INTEGER,
    "PrimaryKeyAfter" INTEGER,
    "ColumnName" TEXT NOT NULL DEFAULT '',
    "ColumnValueBefore" TEXT NOT NULL DEFAULT '',
    "ColumnValueAfter" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "QChangeDetail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QChangeReason" (
    "id" TEXT NOT NULL,
    "ChangeReasonID" INTEGER NOT NULL,
    "ChangeReason" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "QChangeReason_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QChange" (
    "id" TEXT NOT NULL,
    "ChangeID" INTEGER NOT NULL,
    "effectiveDate" TIMESTAMP(3),
    "reason" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "QChange_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QChangeTableName" (
    "id" TEXT NOT NULL,
    "TableNameID" INTEGER NOT NULL,
    "TableName" TEXT NOT NULL DEFAULT '',
    "TableDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "QChangeTableName_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GroupNumber" (
    "id" TEXT NOT NULL,
    "GroupNumberID" INTEGER NOT NULL,
    "GroupDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "GroupNumber_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QLanguage" (
    "id" TEXT NOT NULL,
    "LanguageID" INTEGER,
    "LanguageName" TEXT NOT NULL DEFAULT '',
    "DialectName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "QLanguage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QdbChange" (
    "id" TEXT NOT NULL,
    "VersionDate" TIMESTAMP(3),
    "QualifierID" INTEGER,
    "QualifierText" TEXT NOT NULL DEFAULT '',
    "Action" TEXT,

    CONSTRAINT "QdbChange_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QQualifier" (
    "id" TEXT NOT NULL,
    "QualifierID" INTEGER NOT NULL,
    "QualifierText" TEXT NOT NULL DEFAULT '',
    "ExampleText" TEXT NOT NULL DEFAULT '',
    "QualifierTypeID" TEXT,
    "NewQualifierID" INTEGER,
    "WhenModified" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "QQualifier_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QualifierGroup" (
    "id" TEXT NOT NULL,
    "QualifierGroupID" INTEGER NOT NULL,
    "GroupNumberID" TEXT,
    "QualifierID" TEXT,

    CONSTRAINT "QualifierGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QualifierTranslation" (
    "id" TEXT NOT NULL,
    "QualifierTranslationID" INTEGER NOT NULL,
    "QualifierID" TEXT,
    "LanguageID" TEXT,
    "TranslationText" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "QualifierTranslation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QualifierType" (
    "id" TEXT NOT NULL,
    "QualifierTypeID" INTEGER NOT NULL,
    "QualifierType" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "QualifierType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QVersion" (
    "id" TEXT NOT NULL,
    "VersionDate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "QVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Abbreviation" (
    "id" TEXT NOT NULL,
    "Abbreviation" TEXT NOT NULL DEFAULT '',
    "Description" TEXT NOT NULL DEFAULT '',
    "LongDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Abbreviation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Aspiration" (
    "id" TEXT NOT NULL,
    "AspirationID" INTEGER NOT NULL,
    "AspirationName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Aspiration_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AttachmentType" (
    "id" TEXT NOT NULL,
    "AttachmentTypeID" INTEGER NOT NULL,
    "AttachmentTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "AttachmentType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BedConfig" (
    "id" TEXT NOT NULL,
    "BedConfigID" INTEGER NOT NULL,
    "BedLengthID" TEXT,
    "BedTypeID" TEXT,

    CONSTRAINT "BedConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BodyType" (
    "id" TEXT NOT NULL,
    "BodyTypeID" INTEGER NOT NULL,
    "BodyTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "BodyType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BodyNumDoors" (
    "id" TEXT NOT NULL,
    "BodyNumDoorsID" INTEGER NOT NULL,
    "NumDoors" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "BodyNumDoors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BodyStyleConfig" (
    "id" TEXT NOT NULL,
    "BodyStyleConfigID" INTEGER NOT NULL,
    "BodyNumDoorsID" TEXT,
    "BodyTypeID" TEXT,

    CONSTRAINT "BodyStyleConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BrakeABS" (
    "id" TEXT NOT NULL,
    "BrakeABSID" INTEGER NOT NULL,
    "BrakeABSName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "BrakeABS_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BrakeConfig" (
    "id" TEXT NOT NULL,
    "BrakeConfigID" INTEGER NOT NULL,
    "FrontBrakeTypeID" TEXT,
    "RearBrakeTypeID" TEXT,
    "BrakeABSID" TEXT,
    "BrakeSystemID" TEXT,

    CONSTRAINT "BrakeConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BrakeSystem" (
    "id" TEXT NOT NULL,
    "BrakeSystemID" INTEGER NOT NULL,
    "BrakeSystemName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "BrakeSystem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BrakeType" (
    "id" TEXT NOT NULL,
    "BrakeTypeID" INTEGER NOT NULL,
    "BrakeTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "BrakeType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChangeAttributeState" (
    "id" TEXT NOT NULL,
    "ChangeAttributeStateID" INTEGER NOT NULL,
    "ChangeAttributeState" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "ChangeAttributeState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VCChangeDetail" (
    "id" TEXT NOT NULL,
    "ChangeDetailID" INTEGER NOT NULL,
    "ChangeID" TEXT,
    "ChangeAttributeStateID" TEXT,
    "TableNameID" TEXT,
    "PrimaryKeyColumnName" TEXT NOT NULL DEFAULT '',
    "PrimaryKeyBefore" INTEGER,
    "PrimaryKeyAfter" INTEGER,
    "ColumnName" TEXT NOT NULL DEFAULT '',
    "ColumnValueBefore" TEXT NOT NULL DEFAULT '',
    "ColumnValueAfter" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VCChangeDetail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VCChangeReason" (
    "id" TEXT NOT NULL,
    "ChangeReasonID" INTEGER NOT NULL,
    "ChangeReason" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VCChangeReason_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VCChange" (
    "id" TEXT NOT NULL,
    "ChangeID" INTEGER NOT NULL,
    "RequestID" INTEGER NOT NULL,
    "ChangeReasonID" TEXT,
    "RevDate" TIMESTAMP(3),

    CONSTRAINT "VCChange_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VCChangeTableName" (
    "id" TEXT NOT NULL,
    "TableNameID" INTEGER NOT NULL,
    "TableName" TEXT NOT NULL DEFAULT '',
    "TableDescription" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VCChangeTableName_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Class" (
    "id" TEXT NOT NULL,
    "ClassID" INTEGER NOT NULL,
    "ClassName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Class_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CylinderHeadType" (
    "id" TEXT NOT NULL,
    "CylinderHeadTypeID" INTEGER NOT NULL,
    "CylinderHeadTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "CylinderHeadType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DriveType" (
    "id" TEXT NOT NULL,
    "DriveTypeID" INTEGER NOT NULL,
    "DriveTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "DriveType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ElecControlled" (
    "id" TEXT NOT NULL,
    "ElecControlledID" INTEGER NOT NULL,
    "ElecControlledName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "ElecControlled_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngineBase" (
    "id" TEXT NOT NULL,
    "EngineBaseID" INTEGER NOT NULL,
    "MfrEngineCode" TEXT NOT NULL DEFAULT '',
    "EngineDesignation" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "EngineBase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngineBase2" (
    "id" TEXT NOT NULL,
    "EngineBaseID" INTEGER NOT NULL,
    "Cylinders" INTEGER,
    "DisplacementLiters" DOUBLE PRECISION,
    "DisplacementCC" INTEGER,
    "DisplacementCI" INTEGER,

    CONSTRAINT "EngineBase2_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngineBlock" (
    "id" TEXT NOT NULL,
    "EngineBlockConfigID" INTEGER NOT NULL,
    "EngineBlockConfigName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "EngineBlock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngineBoreStroke" (
    "id" TEXT NOT NULL,
    "EngineBaseID" INTEGER NOT NULL,
    "BoreInches" DOUBLE PRECISION,
    "StrokeInches" DOUBLE PRECISION,

    CONSTRAINT "EngineBoreStroke_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngineConfig" (
    "id" TEXT NOT NULL,
    "EngineConfigID" INTEGER NOT NULL,
    "EngineConfigName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "EngineConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngineConfig2" (
    "id" TEXT NOT NULL,
    "EngineConfigID" INTEGER NOT NULL,
    "EngineBaseID" INTEGER,
    "EngineBlockConfigID" INTEGER,
    "BoreInches" INTEGER,
    "StrokeInches" INTEGER,

    CONSTRAINT "EngineConfig2_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngineDesignation" (
    "id" TEXT NOT NULL,
    "EngineDesignationID" INTEGER NOT NULL,
    "EngineDesignationName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "EngineDesignation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngineVersion" (
    "id" TEXT NOT NULL,
    "EngineVersionID" INTEGER NOT NULL,
    "EngineVersion" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "EngineVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EngineVIN" (
    "id" TEXT NOT NULL,
    "EngineVINID" INTEGER NOT NULL,
    "EngineVIN" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "EngineVIN_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EnglishPhrase" (
    "id" TEXT NOT NULL,
    "EnglishPhraseID" INTEGER NOT NULL,
    "EnglishPhrase" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "EnglishPhrase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Equipment" (
    "id" TEXT NOT NULL,
    "EquipmentID" INTEGER NOT NULL,
    "EquipmentBaseID" TEXT,
    "RegionID" TEXT,
    "ProductionStart" TEXT NOT NULL DEFAULT '',
    "ProductionEnd" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Equipment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EquipmentBase" (
    "id" TEXT NOT NULL,
    "EquipmentBaseID" INTEGER NOT NULL,
    "MfrID" TEXT,
    "EquipmentModelID" TEXT,
    "VehicleTypeId" TEXT,

    CONSTRAINT "EquipmentBase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EquipmentModel" (
    "id" TEXT NOT NULL,
    "EquipmentModelID" INTEGER NOT NULL,
    "EquipmentModelName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "EquipmentModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EquipmentToEngineConfig" (
    "id" TEXT NOT NULL,
    "EquipmentToEngineConfigID" INTEGER NOT NULL,
    "EquipmentID" TEXT,
    "EngineConfigID" TEXT,

    CONSTRAINT "EquipmentToEngineConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FuelDeliveryConfig" (
    "id" TEXT NOT NULL,
    "FuelDeliveryConfigID" INTEGER NOT NULL,
    "FuelDeliveryTypeID" TEXT,
    "FuelDeliverySubTypeID" TEXT,
    "FuelSystemControlTypeID" TEXT,
    "FuelSystemDesignID" TEXT,

    CONSTRAINT "FuelDeliveryConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FuelDeliverySubType" (
    "id" TEXT NOT NULL,
    "FuelDeliverySubTypeID" INTEGER NOT NULL,
    "FuelDeliverySubTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "FuelDeliverySubType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FuelDeliveryType" (
    "id" TEXT NOT NULL,
    "FuelDeliveryTypeID" INTEGER NOT NULL,
    "FuelDeliveryTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "FuelDeliveryType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FuelSystemControlType" (
    "id" TEXT NOT NULL,
    "FuelSystemControlTypeID" INTEGER NOT NULL,
    "FuelSystemControlTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "FuelSystemControlType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FuelSystemDesign" (
    "id" TEXT NOT NULL,
    "FuelSystemDesignID" INTEGER NOT NULL,
    "FuelSystemDesignName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "FuelSystemDesign_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FuelType" (
    "id" TEXT NOT NULL,
    "FuelTypeID" INTEGER NOT NULL,
    "FuelTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "FuelType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IgnitionSystemType" (
    "id" TEXT NOT NULL,
    "IgnitionSystemTypeID" INTEGER NOT NULL,
    "IgnitionSystemTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "IgnitionSystemType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VCLanguage" (
    "id" TEXT NOT NULL,
    "LanguageID" INTEGER NOT NULL,
    "LanguageName" TEXT NOT NULL DEFAULT '',
    "DialectName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VCLanguage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LanguageTranslation" (
    "id" TEXT NOT NULL,
    "LanguageTranslationID" INTEGER NOT NULL,
    "EnglishPhraseID" TEXT,
    "LanguageID" TEXT,
    "Translation" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "LanguageTranslation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LanguageTranslationAttachment" (
    "id" TEXT NOT NULL,
    "LanguageTranslationAttachmentID" INTEGER NOT NULL,
    "LanguageTranslationID" TEXT,
    "AttachmentID" INTEGER NOT NULL,

    CONSTRAINT "LanguageTranslationAttachment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Mfr" (
    "id" TEXT NOT NULL,
    "MfrID" INTEGER NOT NULL,
    "MfrName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Mfr_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MfrBodyCode" (
    "id" TEXT NOT NULL,
    "MfrBodyCodeID" INTEGER NOT NULL,
    "MfrBodyCodeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "MfrBodyCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PowerOutput" (
    "id" TEXT NOT NULL,
    "PowerOutputID" INTEGER NOT NULL,
    "HorsePower" TEXT NOT NULL DEFAULT '',
    "KilowattPower" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PowerOutput_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PublicationStage" (
    "id" TEXT NOT NULL,
    "PublicationStageID" INTEGER NOT NULL,
    "PublicationStageName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PublicationStage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Region" (
    "id" TEXT NOT NULL,
    "RegionID" INTEGER NOT NULL,
    "ParentID" TEXT,
    "RegionAbbr" TEXT NOT NULL DEFAULT '',
    "RegionName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Region_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SpringType" (
    "id" TEXT NOT NULL,
    "SpringTypeID" INTEGER NOT NULL,
    "SpringTypeName" TEXT NOT NULL DEFAULT '',
    "frontConfigs" TEXT,
    "rearConfigs" TEXT,

    CONSTRAINT "SpringType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SpringTypeConfig" (
    "id" TEXT NOT NULL,
    "SpringTypeConfigID" INTEGER NOT NULL,

    CONSTRAINT "SpringTypeConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SteeringConfig" (
    "id" TEXT NOT NULL,
    "SteeringConfigID" INTEGER NOT NULL,
    "SteeringType" TEXT,
    "SteeringSystem" TEXT,

    CONSTRAINT "SteeringConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SteeringSystem" (
    "id" TEXT NOT NULL,
    "SteeringSystemID" INTEGER NOT NULL,
    "SteeringSystemName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "SteeringSystem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SteeringType" (
    "id" TEXT NOT NULL,
    "SteeringTypeID" INTEGER NOT NULL,
    "SteeringTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "SteeringType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubModel" (
    "id" TEXT NOT NULL,
    "SubModelID" INTEGER NOT NULL,
    "SubModelName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "SubModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transmission" (
    "id" TEXT NOT NULL,
    "TransmissionID" INTEGER NOT NULL,
    "TransmissionBaseID" INTEGER,
    "TransmissionBase" TEXT,
    "TransmissionMfrCodeID" INTEGER,
    "TransmissionMfrCode" TEXT,
    "TransmissionElecControlledID" INTEGER,
    "TransmissionElecControlled" TEXT,
    "TransmissionMfrID" INTEGER,
    "TransmissionMfr" TEXT,

    CONSTRAINT "Transmission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransmissionBase" (
    "id" TEXT NOT NULL,
    "TransmissionBaseID" INTEGER NOT NULL,
    "TransmissionType" TEXT,
    "TransmissionNumSpeeds" TEXT,
    "TransmissionControlType" TEXT,

    CONSTRAINT "TransmissionBase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransmissionControlType" (
    "id" TEXT NOT NULL,
    "TransmissionControlTypeID" INTEGER NOT NULL,
    "TransmissionControlTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "TransmissionControlType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransmissionMfrCode" (
    "id" TEXT NOT NULL,
    "TransmissionMfrCodeID" INTEGER NOT NULL,
    "TransmissionMfrCode" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "TransmissionMfrCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransmissionNumSpeed" (
    "id" TEXT NOT NULL,
    "TransmissionNumSpeedsID" INTEGER NOT NULL,
    "TransmissionNumSpeeds" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "TransmissionNumSpeed_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TransmissionType" (
    "id" TEXT NOT NULL,
    "TransmissionTypeID" INTEGER NOT NULL,
    "TransmissionTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "TransmissionType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Valve" (
    "id" TEXT NOT NULL,
    "ValvesID" INTEGER NOT NULL,
    "Valves" INTEGER NOT NULL,

    CONSTRAINT "Valve_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VCdbChange" (
    "id" TEXT NOT NULL,
    "ChangeID" INTEGER NOT NULL,
    "ChangeRequestID" INTEGER,
    "TableName" TEXT NOT NULL DEFAULT '',
    "VCdbRecordID" INTEGER,
    "ChangeType" TEXT NOT NULL DEFAULT '',
    "ChangeDate" TIMESTAMP(3),

    CONSTRAINT "VCdbChange_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Vehicle" (
    "id" TEXT NOT NULL,
    "VehicleID" INTEGER NOT NULL,
    "BaseVehicleID" TEXT,
    "TransmissionID" TEXT,
    "DriveTypeID" TEXT,
    "BodyNumDoorsID" TEXT,
    "BodyTypeID" TEXT,
    "BrakeSystemID" TEXT,
    "RegionID" TEXT,
    "BedLengthID" TEXT,
    "BedTypeID" TEXT,
    "WheelBaseID" TEXT,
    "MfrBodyCodeID" TEXT,
    "SteeringSystemID" TEXT,
    "SteeringTypeID" TEXT,
    "BrakeTypeID" TEXT,
    "SpringTypeID" TEXT,
    "FuelTypeID" TEXT,
    "EngineBaseID" TEXT,
    "TransmissionBaseID" TEXT,
    "Note" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Vehicle_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToBedConfig" (
    "id" TEXT NOT NULL,
    "VehicleToBedConfigID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "BedConfigID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToBedConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToBodyConfig" (
    "id" TEXT NOT NULL,
    "VehicleToBodyConfigID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "WheelBaseID" TEXT,
    "BedConfigID" TEXT,
    "BodyStyleConfigID" TEXT,
    "MfrBodyCodeID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToBodyConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToBodyStyleConfig" (
    "id" TEXT NOT NULL,
    "VehicleToBodyStyleConfigID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "BodyStyleConfigID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToBodyStyleConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToBrakeConfig" (
    "id" TEXT NOT NULL,
    "VehicleToBrakeConfigID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "BrakeConfigID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToBrakeConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToClass" (
    "id" TEXT NOT NULL,
    "VehicleToClassID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "ClassID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToClass_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToDriveType" (
    "id" TEXT NOT NULL,
    "VehicleToDriveTypeID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "DriveTypeID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToDriveType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToEngineConfig" (
    "id" TEXT NOT NULL,
    "VehicleToEngineConfigID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "EngineConfigID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToEngineConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToMfrBodyCode" (
    "id" TEXT NOT NULL,
    "VehicleToMfrBodyCodeID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "MfrBodyCodeID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToMfrBodyCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToSpringTypeConfig" (
    "id" TEXT NOT NULL,
    "VehicleToSpringTypeConfigID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "SpringTypeConfigID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToSpringTypeConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToSteeringConfig" (
    "id" TEXT NOT NULL,
    "VehicleToSteeringConfigID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "SteeringConfigID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToSteeringConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToTransmission" (
    "id" TEXT NOT NULL,
    "VehicleToTransmissionID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "TransmissionID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToTransmission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleToWheelbase" (
    "id" TEXT NOT NULL,
    "VehicleToWheelbaseID" INTEGER NOT NULL,
    "VehicleID" TEXT,
    "WheelbaseID" TEXT,
    "Source" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleToWheelbase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleType" (
    "id" TEXT NOT NULL,
    "VehicleTypeID" INTEGER NOT NULL,
    "VehicleTypeName" TEXT NOT NULL DEFAULT '',
    "VehicleTypeGroupID" TEXT,

    CONSTRAINT "VehicleType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VehicleTypeGroup" (
    "id" TEXT NOT NULL,
    "VehicleTypeGroupID" INTEGER NOT NULL,
    "VehicleTypeGroupName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VehicleTypeGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Version" (
    "id" TEXT NOT NULL,
    "VersionDate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Version_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WheelBase" (
    "id" TEXT NOT NULL,
    "WheelBaseID" INTEGER NOT NULL,
    "WheelBase" TEXT NOT NULL DEFAULT '',
    "WheelBaseMetric" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "WheelBase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Year" (
    "id" TEXT NOT NULL,
    "YearID" INTEGER NOT NULL,

    CONSTRAINT "Year_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BedLength" (
    "id" TEXT NOT NULL,
    "BedLengthID" INTEGER NOT NULL,
    "BedLength" TEXT NOT NULL DEFAULT '',
    "BedLengthMetric" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "BedLength_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BedType" (
    "id" TEXT NOT NULL,
    "BedTypeID" INTEGER NOT NULL,
    "BedTypeName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "BedType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PCdbPartTerminology" (
    "id" TEXT NOT NULL,
    "partTerminologyID" INTEGER NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "aaiaid" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PCdbPartTerminology_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "MeasurementGroup_measurementGroupID_key" ON "MeasurementGroup"("measurementGroupID");

-- CreateIndex
CREATE UNIQUE INDEX "MetaData_metaID_key" ON "MetaData"("metaID");

-- CreateIndex
CREATE UNIQUE INDEX "MetaUOMCodeAssignment_metaUOMCodeAssignmentID_key" ON "MetaUOMCodeAssignment"("metaUOMCodeAssignmentID");

-- CreateIndex
CREATE UNIQUE INDEX "MetaUOMCode_metaUOMID_key" ON "MetaUOMCode"("metaUOMID");

-- CreateIndex
CREATE UNIQUE INDEX "PartAttributeAssignment_paptID_key" ON "PartAttributeAssignment"("paptID");

-- CreateIndex
CREATE UNIQUE INDEX "PartAttribute_paid_key" ON "PartAttribute"("paid");

-- CreateIndex
CREATE UNIQUE INDEX "ValidValueAssignment_validValueAssignmentID_key" ON "ValidValueAssignment"("validValueAssignmentID");

-- CreateIndex
CREATE UNIQUE INDEX "ValidValue_validValueID_key" ON "ValidValue"("validValueID");

-- CreateIndex
CREATE UNIQUE INDEX "ValidValue_validValue_key" ON "ValidValue"("validValue");

-- CreateIndex
CREATE UNIQUE INDEX "Alias_AliasID_key" ON "Alias"("AliasID");

-- CreateIndex
CREATE UNIQUE INDEX "Category_CategoryID_key" ON "Category"("CategoryID");

-- CreateIndex
CREATE UNIQUE INDEX "CodeMaster_CodeMasterID_key" ON "CodeMaster"("CodeMasterID");

-- CreateIndex
CREATE INDEX "CodeMaster_CategoryID_idx" ON "CodeMaster"("CategoryID");

-- CreateIndex
CREATE INDEX "CodeMaster_SubCategoryID_idx" ON "CodeMaster"("SubCategoryID");

-- CreateIndex
CREATE INDEX "CodeMaster_PositionID_idx" ON "CodeMaster"("PositionID");

-- CreateIndex
CREATE UNIQUE INDEX "PCChange_ChangeID_key" ON "PCChange"("ChangeID");

-- CreateIndex
CREATE INDEX "PCChange_ChangeReasonID_idx" ON "PCChange"("ChangeReasonID");

-- CreateIndex
CREATE UNIQUE INDEX "PCChangeAttributeState_ChangeAttributeStateID_key" ON "PCChangeAttributeState"("ChangeAttributeStateID");

-- CreateIndex
CREATE UNIQUE INDEX "PCChangeDetail_ChangeDetailID_key" ON "PCChangeDetail"("ChangeDetailID");

-- CreateIndex
CREATE INDEX "PCChangeDetail_ChangeID_idx" ON "PCChangeDetail"("ChangeID");

-- CreateIndex
CREATE INDEX "PCChangeDetail_ChangeAttributeStateID_idx" ON "PCChangeDetail"("ChangeAttributeStateID");

-- CreateIndex
CREATE INDEX "PCChangeDetail_TableNameID_idx" ON "PCChangeDetail"("TableNameID");

-- CreateIndex
CREATE UNIQUE INDEX "PCChangeReason_ChangeReasonID_key" ON "PCChangeReason"("ChangeReasonID");

-- CreateIndex
CREATE UNIQUE INDEX "PCChangeTableName_TableNameID_key" ON "PCChangeTableName"("TableNameID");

-- CreateIndex
CREATE UNIQUE INDEX "Part_PartTerminologyID_key" ON "Part"("PartTerminologyID");

-- CreateIndex
CREATE INDEX "Part_PartsDescriptionID_idx" ON "Part"("PartsDescriptionID");

-- CreateIndex
CREATE UNIQUE INDEX "PartsDescription_PartsDescriptionID_key" ON "PartsDescription"("PartsDescriptionID");

-- CreateIndex
CREATE INDEX "PartsRelationship_PartTerminology_idx" ON "PartsRelationship"("PartTerminology");

-- CreateIndex
CREATE INDEX "PartsToAlias_PartTerminology_idx" ON "PartsToAlias"("PartTerminology");

-- CreateIndex
CREATE INDEX "PartsToAlias_alias_idx" ON "PartsToAlias"("alias");

-- CreateIndex
CREATE INDEX "PartsToUse_PartTerminology_idx" ON "PartsToUse"("PartTerminology");

-- CreateIndex
CREATE INDEX "PartsToUse_Use_idx" ON "PartsToUse"("Use");

-- CreateIndex
CREATE UNIQUE INDEX "Position_PositionID_key" ON "Position"("PositionID");

-- CreateIndex
CREATE UNIQUE INDEX "Subcategory_SubCategoryID_key" ON "Subcategory"("SubCategoryID");

-- CreateIndex
CREATE UNIQUE INDEX "Use_UseID_key" ON "Use"("UseID");

-- CreateIndex
CREATE UNIQUE INDEX "PIESCode_PIESCodeId_key" ON "PIESCode"("PIESCodeId");

-- CreateIndex
CREATE UNIQUE INDEX "PIESExpiCode_PIESExpiCodeId_key" ON "PIESExpiCode"("PIESExpiCodeId");

-- CreateIndex
CREATE INDEX "PIESExpiCode_PIESExpiGroupId_idx" ON "PIESExpiCode"("PIESExpiGroupId");

-- CreateIndex
CREATE UNIQUE INDEX "PIESExpiGroup_PIESExpiGroupId_key" ON "PIESExpiGroup"("PIESExpiGroupId");

-- CreateIndex
CREATE UNIQUE INDEX "PIESField_PIESFieldId_key" ON "PIESField"("PIESFieldId");

-- CreateIndex
CREATE INDEX "PIESField_PIESSegmentId_idx" ON "PIESField"("PIESSegmentId");

-- CreateIndex
CREATE UNIQUE INDEX "PIESReferenceFieldCode_PIESReferenceFieldCodeId_key" ON "PIESReferenceFieldCode"("PIESReferenceFieldCodeId");

-- CreateIndex
CREATE INDEX "PIESReferenceFieldCode_PIESFieldId_idx" ON "PIESReferenceFieldCode"("PIESFieldId");

-- CreateIndex
CREATE INDEX "PIESReferenceFieldCode_PIESCodeId_idx" ON "PIESReferenceFieldCode"("PIESCodeId");

-- CreateIndex
CREATE INDEX "PIESReferenceFieldCode_PIESExpiCodeId_idx" ON "PIESReferenceFieldCode"("PIESExpiCodeId");

-- CreateIndex
CREATE UNIQUE INDEX "PIESSegment_PIESSegmentId_key" ON "PIESSegment"("PIESSegmentId");

-- CreateIndex
CREATE UNIQUE INDEX "PartsSupersession_OldPartTerminologyID_key" ON "PartsSupersession"("OldPartTerminologyID");

-- CreateIndex
CREATE UNIQUE INDEX "PartsSupersession_NewPartTerminologyID_key" ON "PartsSupersession"("NewPartTerminologyID");

-- CreateIndex
CREATE UNIQUE INDEX "QChangeAttributeState_ChangeAttributeStateID_key" ON "QChangeAttributeState"("ChangeAttributeStateID");

-- CreateIndex
CREATE UNIQUE INDEX "QChangeDetail_ChangeDetailID_key" ON "QChangeDetail"("ChangeDetailID");

-- CreateIndex
CREATE INDEX "QChangeDetail_ChangeID_idx" ON "QChangeDetail"("ChangeID");

-- CreateIndex
CREATE INDEX "QChangeDetail_ChangeAttributeStateID_idx" ON "QChangeDetail"("ChangeAttributeStateID");

-- CreateIndex
CREATE INDEX "QChangeDetail_TableNameID_idx" ON "QChangeDetail"("TableNameID");

-- CreateIndex
CREATE UNIQUE INDEX "QChangeReason_ChangeReasonID_key" ON "QChangeReason"("ChangeReasonID");

-- CreateIndex
CREATE UNIQUE INDEX "QChange_ChangeID_key" ON "QChange"("ChangeID");

-- CreateIndex
CREATE UNIQUE INDEX "QChangeTableName_TableNameID_key" ON "QChangeTableName"("TableNameID");

-- CreateIndex
CREATE UNIQUE INDEX "GroupNumber_GroupNumberID_key" ON "GroupNumber"("GroupNumberID");

-- CreateIndex
CREATE UNIQUE INDEX "QQualifier_QualifierID_key" ON "QQualifier"("QualifierID");

-- CreateIndex
CREATE INDEX "QQualifier_QualifierTypeID_idx" ON "QQualifier"("QualifierTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "QualifierGroup_QualifierGroupID_key" ON "QualifierGroup"("QualifierGroupID");

-- CreateIndex
CREATE INDEX "QualifierGroup_GroupNumberID_idx" ON "QualifierGroup"("GroupNumberID");

-- CreateIndex
CREATE INDEX "QualifierGroup_QualifierID_idx" ON "QualifierGroup"("QualifierID");

-- CreateIndex
CREATE UNIQUE INDEX "QualifierTranslation_QualifierTranslationID_key" ON "QualifierTranslation"("QualifierTranslationID");

-- CreateIndex
CREATE INDEX "QualifierTranslation_QualifierID_idx" ON "QualifierTranslation"("QualifierID");

-- CreateIndex
CREATE INDEX "QualifierTranslation_LanguageID_idx" ON "QualifierTranslation"("LanguageID");

-- CreateIndex
CREATE UNIQUE INDEX "QualifierType_QualifierTypeID_key" ON "QualifierType"("QualifierTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "Abbreviation_Abbreviation_key" ON "Abbreviation"("Abbreviation");

-- CreateIndex
CREATE UNIQUE INDEX "Aspiration_AspirationID_key" ON "Aspiration"("AspirationID");

-- CreateIndex
CREATE UNIQUE INDEX "AttachmentType_AttachmentTypeID_key" ON "AttachmentType"("AttachmentTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "BedConfig_BedConfigID_key" ON "BedConfig"("BedConfigID");

-- CreateIndex
CREATE INDEX "BedConfig_BedLengthID_idx" ON "BedConfig"("BedLengthID");

-- CreateIndex
CREATE INDEX "BedConfig_BedTypeID_idx" ON "BedConfig"("BedTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "BodyType_BodyTypeID_key" ON "BodyType"("BodyTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "BodyNumDoors_BodyNumDoorsID_key" ON "BodyNumDoors"("BodyNumDoorsID");

-- CreateIndex
CREATE UNIQUE INDEX "BodyStyleConfig_BodyStyleConfigID_key" ON "BodyStyleConfig"("BodyStyleConfigID");

-- CreateIndex
CREATE INDEX "BodyStyleConfig_BodyNumDoorsID_idx" ON "BodyStyleConfig"("BodyNumDoorsID");

-- CreateIndex
CREATE INDEX "BodyStyleConfig_BodyTypeID_idx" ON "BodyStyleConfig"("BodyTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "BrakeABS_BrakeABSID_key" ON "BrakeABS"("BrakeABSID");

-- CreateIndex
CREATE UNIQUE INDEX "BrakeConfig_BrakeConfigID_key" ON "BrakeConfig"("BrakeConfigID");

-- CreateIndex
CREATE INDEX "BrakeConfig_FrontBrakeTypeID_idx" ON "BrakeConfig"("FrontBrakeTypeID");

-- CreateIndex
CREATE INDEX "BrakeConfig_RearBrakeTypeID_idx" ON "BrakeConfig"("RearBrakeTypeID");

-- CreateIndex
CREATE INDEX "BrakeConfig_BrakeABSID_idx" ON "BrakeConfig"("BrakeABSID");

-- CreateIndex
CREATE INDEX "BrakeConfig_BrakeSystemID_idx" ON "BrakeConfig"("BrakeSystemID");

-- CreateIndex
CREATE UNIQUE INDEX "BrakeSystem_BrakeSystemID_key" ON "BrakeSystem"("BrakeSystemID");

-- CreateIndex
CREATE UNIQUE INDEX "BrakeType_BrakeTypeID_key" ON "BrakeType"("BrakeTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "ChangeAttributeState_ChangeAttributeStateID_key" ON "ChangeAttributeState"("ChangeAttributeStateID");

-- CreateIndex
CREATE UNIQUE INDEX "VCChangeDetail_ChangeDetailID_key" ON "VCChangeDetail"("ChangeDetailID");

-- CreateIndex
CREATE INDEX "VCChangeDetail_ChangeID_idx" ON "VCChangeDetail"("ChangeID");

-- CreateIndex
CREATE INDEX "VCChangeDetail_ChangeAttributeStateID_idx" ON "VCChangeDetail"("ChangeAttributeStateID");

-- CreateIndex
CREATE INDEX "VCChangeDetail_TableNameID_idx" ON "VCChangeDetail"("TableNameID");

-- CreateIndex
CREATE UNIQUE INDEX "VCChangeReason_ChangeReasonID_key" ON "VCChangeReason"("ChangeReasonID");

-- CreateIndex
CREATE UNIQUE INDEX "VCChange_ChangeID_key" ON "VCChange"("ChangeID");

-- CreateIndex
CREATE INDEX "VCChange_ChangeReasonID_idx" ON "VCChange"("ChangeReasonID");

-- CreateIndex
CREATE UNIQUE INDEX "VCChangeTableName_TableNameID_key" ON "VCChangeTableName"("TableNameID");

-- CreateIndex
CREATE UNIQUE INDEX "Class_ClassID_key" ON "Class"("ClassID");

-- CreateIndex
CREATE INDEX "Class_ClassName_idx" ON "Class"("ClassName");

-- CreateIndex
CREATE UNIQUE INDEX "CylinderHeadType_CylinderHeadTypeID_key" ON "CylinderHeadType"("CylinderHeadTypeID");

-- CreateIndex
CREATE INDEX "CylinderHeadType_CylinderHeadTypeName_idx" ON "CylinderHeadType"("CylinderHeadTypeName");

-- CreateIndex
CREATE UNIQUE INDEX "DriveType_DriveTypeID_key" ON "DriveType"("DriveTypeID");

-- CreateIndex
CREATE INDEX "DriveType_DriveTypeName_idx" ON "DriveType"("DriveTypeName");

-- CreateIndex
CREATE UNIQUE INDEX "ElecControlled_ElecControlledID_key" ON "ElecControlled"("ElecControlledID");

-- CreateIndex
CREATE INDEX "ElecControlled_ElecControlledName_idx" ON "ElecControlled"("ElecControlledName");

-- CreateIndex
CREATE UNIQUE INDEX "EngineBase_EngineBaseID_key" ON "EngineBase"("EngineBaseID");

-- CreateIndex
CREATE UNIQUE INDEX "EngineBase2_EngineBaseID_key" ON "EngineBase2"("EngineBaseID");

-- CreateIndex
CREATE UNIQUE INDEX "EngineBlock_EngineBlockConfigID_key" ON "EngineBlock"("EngineBlockConfigID");

-- CreateIndex
CREATE INDEX "EngineBlock_EngineBlockConfigName_idx" ON "EngineBlock"("EngineBlockConfigName");

-- CreateIndex
CREATE UNIQUE INDEX "EngineConfig_EngineConfigID_key" ON "EngineConfig"("EngineConfigID");

-- CreateIndex
CREATE INDEX "EngineConfig_EngineConfigName_idx" ON "EngineConfig"("EngineConfigName");

-- CreateIndex
CREATE UNIQUE INDEX "EngineConfig2_EngineConfigID_key" ON "EngineConfig2"("EngineConfigID");

-- CreateIndex
CREATE UNIQUE INDEX "EngineDesignation_EngineDesignationID_key" ON "EngineDesignation"("EngineDesignationID");

-- CreateIndex
CREATE INDEX "EngineDesignation_EngineDesignationName_idx" ON "EngineDesignation"("EngineDesignationName");

-- CreateIndex
CREATE UNIQUE INDEX "EngineVersion_EngineVersionID_key" ON "EngineVersion"("EngineVersionID");

-- CreateIndex
CREATE INDEX "EngineVersion_EngineVersion_idx" ON "EngineVersion"("EngineVersion");

-- CreateIndex
CREATE UNIQUE INDEX "EngineVIN_EngineVINID_key" ON "EngineVIN"("EngineVINID");

-- CreateIndex
CREATE INDEX "EngineVIN_EngineVIN_idx" ON "EngineVIN"("EngineVIN");

-- CreateIndex
CREATE UNIQUE INDEX "EnglishPhrase_EnglishPhraseID_key" ON "EnglishPhrase"("EnglishPhraseID");

-- CreateIndex
CREATE UNIQUE INDEX "Equipment_EquipmentID_key" ON "Equipment"("EquipmentID");

-- CreateIndex
CREATE INDEX "Equipment_EquipmentBaseID_idx" ON "Equipment"("EquipmentBaseID");

-- CreateIndex
CREATE INDEX "Equipment_RegionID_idx" ON "Equipment"("RegionID");

-- CreateIndex
CREATE UNIQUE INDEX "EquipmentBase_EquipmentBaseID_key" ON "EquipmentBase"("EquipmentBaseID");

-- CreateIndex
CREATE INDEX "EquipmentBase_MfrID_idx" ON "EquipmentBase"("MfrID");

-- CreateIndex
CREATE INDEX "EquipmentBase_EquipmentModelID_idx" ON "EquipmentBase"("EquipmentModelID");

-- CreateIndex
CREATE INDEX "EquipmentBase_VehicleTypeId_idx" ON "EquipmentBase"("VehicleTypeId");

-- CreateIndex
CREATE UNIQUE INDEX "EquipmentModel_EquipmentModelID_key" ON "EquipmentModel"("EquipmentModelID");

-- CreateIndex
CREATE UNIQUE INDEX "EquipmentToEngineConfig_EquipmentToEngineConfigID_key" ON "EquipmentToEngineConfig"("EquipmentToEngineConfigID");

-- CreateIndex
CREATE INDEX "EquipmentToEngineConfig_EquipmentID_idx" ON "EquipmentToEngineConfig"("EquipmentID");

-- CreateIndex
CREATE INDEX "EquipmentToEngineConfig_EngineConfigID_idx" ON "EquipmentToEngineConfig"("EngineConfigID");

-- CreateIndex
CREATE UNIQUE INDEX "FuelDeliveryConfig_FuelDeliveryConfigID_key" ON "FuelDeliveryConfig"("FuelDeliveryConfigID");

-- CreateIndex
CREATE INDEX "FuelDeliveryConfig_FuelDeliveryTypeID_idx" ON "FuelDeliveryConfig"("FuelDeliveryTypeID");

-- CreateIndex
CREATE INDEX "FuelDeliveryConfig_FuelDeliverySubTypeID_idx" ON "FuelDeliveryConfig"("FuelDeliverySubTypeID");

-- CreateIndex
CREATE INDEX "FuelDeliveryConfig_FuelSystemControlTypeID_idx" ON "FuelDeliveryConfig"("FuelSystemControlTypeID");

-- CreateIndex
CREATE INDEX "FuelDeliveryConfig_FuelSystemDesignID_idx" ON "FuelDeliveryConfig"("FuelSystemDesignID");

-- CreateIndex
CREATE UNIQUE INDEX "FuelDeliverySubType_FuelDeliverySubTypeID_key" ON "FuelDeliverySubType"("FuelDeliverySubTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "FuelDeliveryType_FuelDeliveryTypeID_key" ON "FuelDeliveryType"("FuelDeliveryTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "FuelSystemControlType_FuelSystemControlTypeID_key" ON "FuelSystemControlType"("FuelSystemControlTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "FuelSystemDesign_FuelSystemDesignID_key" ON "FuelSystemDesign"("FuelSystemDesignID");

-- CreateIndex
CREATE UNIQUE INDEX "FuelType_FuelTypeID_key" ON "FuelType"("FuelTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "IgnitionSystemType_IgnitionSystemTypeID_key" ON "IgnitionSystemType"("IgnitionSystemTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "VCLanguage_LanguageID_key" ON "VCLanguage"("LanguageID");

-- CreateIndex
CREATE UNIQUE INDEX "LanguageTranslation_LanguageTranslationID_key" ON "LanguageTranslation"("LanguageTranslationID");

-- CreateIndex
CREATE INDEX "LanguageTranslation_EnglishPhraseID_idx" ON "LanguageTranslation"("EnglishPhraseID");

-- CreateIndex
CREATE INDEX "LanguageTranslation_LanguageID_idx" ON "LanguageTranslation"("LanguageID");

-- CreateIndex
CREATE UNIQUE INDEX "LanguageTranslationAttachment_LanguageTranslationAttachment_key" ON "LanguageTranslationAttachment"("LanguageTranslationAttachmentID");

-- CreateIndex
CREATE INDEX "LanguageTranslationAttachment_LanguageTranslationID_idx" ON "LanguageTranslationAttachment"("LanguageTranslationID");

-- CreateIndex
CREATE UNIQUE INDEX "Mfr_MfrID_key" ON "Mfr"("MfrID");

-- CreateIndex
CREATE UNIQUE INDEX "MfrBodyCode_MfrBodyCodeID_key" ON "MfrBodyCode"("MfrBodyCodeID");

-- CreateIndex
CREATE UNIQUE INDEX "PowerOutput_PowerOutputID_key" ON "PowerOutput"("PowerOutputID");

-- CreateIndex
CREATE UNIQUE INDEX "PublicationStage_PublicationStageID_key" ON "PublicationStage"("PublicationStageID");

-- CreateIndex
CREATE UNIQUE INDEX "Region_RegionID_key" ON "Region"("RegionID");

-- CreateIndex
CREATE INDEX "Region_ParentID_idx" ON "Region"("ParentID");

-- CreateIndex
CREATE UNIQUE INDEX "SpringType_SpringTypeID_key" ON "SpringType"("SpringTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "SpringType_frontConfigs_key" ON "SpringType"("frontConfigs");

-- CreateIndex
CREATE UNIQUE INDEX "SpringType_rearConfigs_key" ON "SpringType"("rearConfigs");

-- CreateIndex
CREATE UNIQUE INDEX "SpringTypeConfig_SpringTypeConfigID_key" ON "SpringTypeConfig"("SpringTypeConfigID");

-- CreateIndex
CREATE UNIQUE INDEX "SteeringConfig_SteeringConfigID_key" ON "SteeringConfig"("SteeringConfigID");

-- CreateIndex
CREATE INDEX "SteeringConfig_SteeringType_idx" ON "SteeringConfig"("SteeringType");

-- CreateIndex
CREATE INDEX "SteeringConfig_SteeringSystem_idx" ON "SteeringConfig"("SteeringSystem");

-- CreateIndex
CREATE UNIQUE INDEX "SteeringSystem_SteeringSystemID_key" ON "SteeringSystem"("SteeringSystemID");

-- CreateIndex
CREATE UNIQUE INDEX "SteeringType_SteeringTypeID_key" ON "SteeringType"("SteeringTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "SubModel_SubModelID_key" ON "SubModel"("SubModelID");

-- CreateIndex
CREATE UNIQUE INDEX "Transmission_TransmissionID_key" ON "Transmission"("TransmissionID");

-- CreateIndex
CREATE INDEX "Transmission_TransmissionBase_idx" ON "Transmission"("TransmissionBase");

-- CreateIndex
CREATE INDEX "Transmission_TransmissionMfrCode_idx" ON "Transmission"("TransmissionMfrCode");

-- CreateIndex
CREATE INDEX "Transmission_TransmissionElecControlled_idx" ON "Transmission"("TransmissionElecControlled");

-- CreateIndex
CREATE INDEX "Transmission_TransmissionMfr_idx" ON "Transmission"("TransmissionMfr");

-- CreateIndex
CREATE INDEX "TransmissionBase_TransmissionType_idx" ON "TransmissionBase"("TransmissionType");

-- CreateIndex
CREATE INDEX "TransmissionBase_TransmissionNumSpeeds_idx" ON "TransmissionBase"("TransmissionNumSpeeds");

-- CreateIndex
CREATE INDEX "TransmissionBase_TransmissionControlType_idx" ON "TransmissionBase"("TransmissionControlType");

-- CreateIndex
CREATE UNIQUE INDEX "TransmissionControlType_TransmissionControlTypeID_key" ON "TransmissionControlType"("TransmissionControlTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "TransmissionMfrCode_TransmissionMfrCodeID_key" ON "TransmissionMfrCode"("TransmissionMfrCodeID");

-- CreateIndex
CREATE UNIQUE INDEX "TransmissionNumSpeed_TransmissionNumSpeedsID_key" ON "TransmissionNumSpeed"("TransmissionNumSpeedsID");

-- CreateIndex
CREATE INDEX "TransmissionNumSpeed_TransmissionNumSpeeds_idx" ON "TransmissionNumSpeed"("TransmissionNumSpeeds");

-- CreateIndex
CREATE UNIQUE INDEX "TransmissionType_TransmissionTypeID_key" ON "TransmissionType"("TransmissionTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "Valve_ValvesID_key" ON "Valve"("ValvesID");

-- CreateIndex
CREATE UNIQUE INDEX "VCdbChange_ChangeID_key" ON "VCdbChange"("ChangeID");

-- CreateIndex
CREATE UNIQUE INDEX "Vehicle_VehicleID_key" ON "Vehicle"("VehicleID");

-- CreateIndex
CREATE INDEX "Vehicle_BaseVehicleID_idx" ON "Vehicle"("BaseVehicleID");

-- CreateIndex
CREATE INDEX "Vehicle_TransmissionID_idx" ON "Vehicle"("TransmissionID");

-- CreateIndex
CREATE INDEX "Vehicle_DriveTypeID_idx" ON "Vehicle"("DriveTypeID");

-- CreateIndex
CREATE INDEX "Vehicle_BodyNumDoorsID_idx" ON "Vehicle"("BodyNumDoorsID");

-- CreateIndex
CREATE INDEX "Vehicle_BodyTypeID_idx" ON "Vehicle"("BodyTypeID");

-- CreateIndex
CREATE INDEX "Vehicle_BrakeSystemID_idx" ON "Vehicle"("BrakeSystemID");

-- CreateIndex
CREATE INDEX "Vehicle_RegionID_idx" ON "Vehicle"("RegionID");

-- CreateIndex
CREATE INDEX "Vehicle_BedLengthID_idx" ON "Vehicle"("BedLengthID");

-- CreateIndex
CREATE INDEX "Vehicle_BedTypeID_idx" ON "Vehicle"("BedTypeID");

-- CreateIndex
CREATE INDEX "Vehicle_WheelBaseID_idx" ON "Vehicle"("WheelBaseID");

-- CreateIndex
CREATE INDEX "Vehicle_MfrBodyCodeID_idx" ON "Vehicle"("MfrBodyCodeID");

-- CreateIndex
CREATE INDEX "Vehicle_SteeringSystemID_idx" ON "Vehicle"("SteeringSystemID");

-- CreateIndex
CREATE INDEX "Vehicle_SteeringTypeID_idx" ON "Vehicle"("SteeringTypeID");

-- CreateIndex
CREATE INDEX "Vehicle_BrakeTypeID_idx" ON "Vehicle"("BrakeTypeID");

-- CreateIndex
CREATE INDEX "Vehicle_SpringTypeID_idx" ON "Vehicle"("SpringTypeID");

-- CreateIndex
CREATE INDEX "Vehicle_FuelTypeID_idx" ON "Vehicle"("FuelTypeID");

-- CreateIndex
CREATE INDEX "Vehicle_EngineBaseID_idx" ON "Vehicle"("EngineBaseID");

-- CreateIndex
CREATE INDEX "Vehicle_TransmissionBaseID_idx" ON "Vehicle"("TransmissionBaseID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToBedConfig_VehicleToBedConfigID_key" ON "VehicleToBedConfig"("VehicleToBedConfigID");

-- CreateIndex
CREATE INDEX "VehicleToBedConfig_VehicleID_idx" ON "VehicleToBedConfig"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToBedConfig_BedConfigID_idx" ON "VehicleToBedConfig"("BedConfigID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToBodyConfig_VehicleToBodyConfigID_key" ON "VehicleToBodyConfig"("VehicleToBodyConfigID");

-- CreateIndex
CREATE INDEX "VehicleToBodyConfig_VehicleID_idx" ON "VehicleToBodyConfig"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToBodyConfig_WheelBaseID_idx" ON "VehicleToBodyConfig"("WheelBaseID");

-- CreateIndex
CREATE INDEX "VehicleToBodyConfig_BedConfigID_idx" ON "VehicleToBodyConfig"("BedConfigID");

-- CreateIndex
CREATE INDEX "VehicleToBodyConfig_BodyStyleConfigID_idx" ON "VehicleToBodyConfig"("BodyStyleConfigID");

-- CreateIndex
CREATE INDEX "VehicleToBodyConfig_MfrBodyCodeID_idx" ON "VehicleToBodyConfig"("MfrBodyCodeID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToBodyStyleConfig_VehicleToBodyStyleConfigID_key" ON "VehicleToBodyStyleConfig"("VehicleToBodyStyleConfigID");

-- CreateIndex
CREATE INDEX "VehicleToBodyStyleConfig_VehicleID_idx" ON "VehicleToBodyStyleConfig"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToBodyStyleConfig_BodyStyleConfigID_idx" ON "VehicleToBodyStyleConfig"("BodyStyleConfigID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToBrakeConfig_VehicleToBrakeConfigID_key" ON "VehicleToBrakeConfig"("VehicleToBrakeConfigID");

-- CreateIndex
CREATE INDEX "VehicleToBrakeConfig_VehicleID_idx" ON "VehicleToBrakeConfig"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToBrakeConfig_BrakeConfigID_idx" ON "VehicleToBrakeConfig"("BrakeConfigID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToClass_VehicleToClassID_key" ON "VehicleToClass"("VehicleToClassID");

-- CreateIndex
CREATE INDEX "VehicleToClass_VehicleID_idx" ON "VehicleToClass"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToClass_ClassID_idx" ON "VehicleToClass"("ClassID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToDriveType_VehicleToDriveTypeID_key" ON "VehicleToDriveType"("VehicleToDriveTypeID");

-- CreateIndex
CREATE INDEX "VehicleToDriveType_VehicleID_idx" ON "VehicleToDriveType"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToDriveType_DriveTypeID_idx" ON "VehicleToDriveType"("DriveTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToEngineConfig_VehicleToEngineConfigID_key" ON "VehicleToEngineConfig"("VehicleToEngineConfigID");

-- CreateIndex
CREATE INDEX "VehicleToEngineConfig_VehicleID_idx" ON "VehicleToEngineConfig"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToEngineConfig_EngineConfigID_idx" ON "VehicleToEngineConfig"("EngineConfigID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToMfrBodyCode_VehicleToMfrBodyCodeID_key" ON "VehicleToMfrBodyCode"("VehicleToMfrBodyCodeID");

-- CreateIndex
CREATE INDEX "VehicleToMfrBodyCode_VehicleID_idx" ON "VehicleToMfrBodyCode"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToMfrBodyCode_MfrBodyCodeID_idx" ON "VehicleToMfrBodyCode"("MfrBodyCodeID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToSpringTypeConfig_VehicleToSpringTypeConfigID_key" ON "VehicleToSpringTypeConfig"("VehicleToSpringTypeConfigID");

-- CreateIndex
CREATE INDEX "VehicleToSpringTypeConfig_VehicleID_idx" ON "VehicleToSpringTypeConfig"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToSpringTypeConfig_SpringTypeConfigID_idx" ON "VehicleToSpringTypeConfig"("SpringTypeConfigID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToSteeringConfig_VehicleToSteeringConfigID_key" ON "VehicleToSteeringConfig"("VehicleToSteeringConfigID");

-- CreateIndex
CREATE INDEX "VehicleToSteeringConfig_VehicleID_idx" ON "VehicleToSteeringConfig"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToSteeringConfig_SteeringConfigID_idx" ON "VehicleToSteeringConfig"("SteeringConfigID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToTransmission_VehicleToTransmissionID_key" ON "VehicleToTransmission"("VehicleToTransmissionID");

-- CreateIndex
CREATE INDEX "VehicleToTransmission_VehicleID_idx" ON "VehicleToTransmission"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToTransmission_TransmissionID_idx" ON "VehicleToTransmission"("TransmissionID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleToWheelbase_VehicleToWheelbaseID_key" ON "VehicleToWheelbase"("VehicleToWheelbaseID");

-- CreateIndex
CREATE INDEX "VehicleToWheelbase_VehicleID_idx" ON "VehicleToWheelbase"("VehicleID");

-- CreateIndex
CREATE INDEX "VehicleToWheelbase_WheelbaseID_idx" ON "VehicleToWheelbase"("WheelbaseID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleType_VehicleTypeID_key" ON "VehicleType"("VehicleTypeID");

-- CreateIndex
CREATE INDEX "VehicleType_VehicleTypeGroupID_idx" ON "VehicleType"("VehicleTypeGroupID");

-- CreateIndex
CREATE UNIQUE INDEX "VehicleTypeGroup_VehicleTypeGroupID_key" ON "VehicleTypeGroup"("VehicleTypeGroupID");

-- CreateIndex
CREATE UNIQUE INDEX "WheelBase_WheelBaseID_key" ON "WheelBase"("WheelBaseID");

-- CreateIndex
CREATE UNIQUE INDEX "Year_YearID_key" ON "Year"("YearID");

-- CreateIndex
CREATE UNIQUE INDEX "BedLength_BedLengthID_key" ON "BedLength"("BedLengthID");

-- CreateIndex
CREATE UNIQUE INDEX "BedType_BedTypeID_key" ON "BedType"("BedTypeID");

-- CreateIndex
CREATE UNIQUE INDEX "PCdbPartTerminology_partTerminologyID_key" ON "PCdbPartTerminology"("partTerminologyID");

-- CreateIndex
CREATE INDEX "PCdbPartTerminology_aaiaid_idx" ON "PCdbPartTerminology"("aaiaid");

-- CreateIndex
CREATE UNIQUE INDEX "BaseVehicle_BaseVehicleID_key" ON "BaseVehicle"("BaseVehicleID");

-- CreateIndex
CREATE INDEX "BaseVehicle_YearID_idx" ON "BaseVehicle"("YearID");

-- CreateIndex
CREATE INDEX "BaseVehicle_MakeID_idx" ON "BaseVehicle"("MakeID");

-- CreateIndex
CREATE INDEX "BaseVehicle_ModelID_idx" ON "BaseVehicle"("ModelID");

-- CreateIndex
CREATE UNIQUE INDEX "Make_MakeID_key" ON "Make"("MakeID");

-- CreateIndex
CREATE UNIQUE INDEX "Model_ModelID_key" ON "Model"("ModelID");

-- CreateIndex
CREATE INDEX "Model_VehicleTypeID_idx" ON "Model"("VehicleTypeID");

-- AddForeignKey
ALTER TABLE "CodeMaster" ADD CONSTRAINT "CodeMaster_CategoryID_fkey" FOREIGN KEY ("CategoryID") REFERENCES "Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CodeMaster" ADD CONSTRAINT "CodeMaster_SubCategoryID_fkey" FOREIGN KEY ("SubCategoryID") REFERENCES "Subcategory"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CodeMaster" ADD CONSTRAINT "CodeMaster_PositionID_fkey" FOREIGN KEY ("PositionID") REFERENCES "Position"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PCChange" ADD CONSTRAINT "PCChange_ChangeReasonID_fkey" FOREIGN KEY ("ChangeReasonID") REFERENCES "PCChangeReason"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PCChangeDetail" ADD CONSTRAINT "PCChangeDetail_ChangeID_fkey" FOREIGN KEY ("ChangeID") REFERENCES "PCChange"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PCChangeDetail" ADD CONSTRAINT "PCChangeDetail_ChangeAttributeStateID_fkey" FOREIGN KEY ("ChangeAttributeStateID") REFERENCES "PCChangeAttributeState"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PCChangeDetail" ADD CONSTRAINT "PCChangeDetail_TableNameID_fkey" FOREIGN KEY ("TableNameID") REFERENCES "PCChangeTableName"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Part" ADD CONSTRAINT "Part_PartsDescriptionID_fkey" FOREIGN KEY ("PartsDescriptionID") REFERENCES "PartsDescription"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartsRelationship" ADD CONSTRAINT "PartsRelationship_PartTerminology_fkey" FOREIGN KEY ("PartTerminology") REFERENCES "PCdbPartTerminology"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartsToAlias" ADD CONSTRAINT "PartsToAlias_PartTerminology_fkey" FOREIGN KEY ("PartTerminology") REFERENCES "PCdbPartTerminology"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartsToAlias" ADD CONSTRAINT "PartsToAlias_alias_fkey" FOREIGN KEY ("alias") REFERENCES "Alias"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartsToUse" ADD CONSTRAINT "PartsToUse_PartTerminology_fkey" FOREIGN KEY ("PartTerminology") REFERENCES "PCdbPartTerminology"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartsToUse" ADD CONSTRAINT "PartsToUse_Use_fkey" FOREIGN KEY ("Use") REFERENCES "Use"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PIESExpiCode" ADD CONSTRAINT "PIESExpiCode_PIESExpiGroupId_fkey" FOREIGN KEY ("PIESExpiGroupId") REFERENCES "PIESExpiGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PIESField" ADD CONSTRAINT "PIESField_PIESSegmentId_fkey" FOREIGN KEY ("PIESSegmentId") REFERENCES "PIESSegment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PIESReferenceFieldCode" ADD CONSTRAINT "PIESReferenceFieldCode_PIESFieldId_fkey" FOREIGN KEY ("PIESFieldId") REFERENCES "PIESField"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PIESReferenceFieldCode" ADD CONSTRAINT "PIESReferenceFieldCode_PIESCodeId_fkey" FOREIGN KEY ("PIESCodeId") REFERENCES "PIESCode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PIESReferenceFieldCode" ADD CONSTRAINT "PIESReferenceFieldCode_PIESExpiCodeId_fkey" FOREIGN KEY ("PIESExpiCodeId") REFERENCES "PIESExpiCode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QChangeDetail" ADD CONSTRAINT "QChangeDetail_ChangeID_fkey" FOREIGN KEY ("ChangeID") REFERENCES "QChange"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QChangeDetail" ADD CONSTRAINT "QChangeDetail_ChangeAttributeStateID_fkey" FOREIGN KEY ("ChangeAttributeStateID") REFERENCES "QChangeAttributeState"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QChangeDetail" ADD CONSTRAINT "QChangeDetail_TableNameID_fkey" FOREIGN KEY ("TableNameID") REFERENCES "QChangeTableName"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QQualifier" ADD CONSTRAINT "QQualifier_QualifierTypeID_fkey" FOREIGN KEY ("QualifierTypeID") REFERENCES "QualifierType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QualifierGroup" ADD CONSTRAINT "QualifierGroup_GroupNumberID_fkey" FOREIGN KEY ("GroupNumberID") REFERENCES "GroupNumber"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QualifierGroup" ADD CONSTRAINT "QualifierGroup_QualifierID_fkey" FOREIGN KEY ("QualifierID") REFERENCES "QQualifier"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QualifierTranslation" ADD CONSTRAINT "QualifierTranslation_QualifierID_fkey" FOREIGN KEY ("QualifierID") REFERENCES "QQualifier"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "QualifierTranslation" ADD CONSTRAINT "QualifierTranslation_LanguageID_fkey" FOREIGN KEY ("LanguageID") REFERENCES "QLanguage"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaseVehicle" ADD CONSTRAINT "BaseVehicle_YearID_fkey" FOREIGN KEY ("YearID") REFERENCES "Year"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaseVehicle" ADD CONSTRAINT "BaseVehicle_MakeID_fkey" FOREIGN KEY ("MakeID") REFERENCES "Make"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaseVehicle" ADD CONSTRAINT "BaseVehicle_ModelID_fkey" FOREIGN KEY ("ModelID") REFERENCES "Model"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BedConfig" ADD CONSTRAINT "BedConfig_BedLengthID_fkey" FOREIGN KEY ("BedLengthID") REFERENCES "BedLength"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BedConfig" ADD CONSTRAINT "BedConfig_BedTypeID_fkey" FOREIGN KEY ("BedTypeID") REFERENCES "BedType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BodyStyleConfig" ADD CONSTRAINT "BodyStyleConfig_BodyNumDoorsID_fkey" FOREIGN KEY ("BodyNumDoorsID") REFERENCES "BodyNumDoors"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BodyStyleConfig" ADD CONSTRAINT "BodyStyleConfig_BodyTypeID_fkey" FOREIGN KEY ("BodyTypeID") REFERENCES "BodyType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BrakeConfig" ADD CONSTRAINT "BrakeConfig_FrontBrakeTypeID_fkey" FOREIGN KEY ("FrontBrakeTypeID") REFERENCES "BrakeType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BrakeConfig" ADD CONSTRAINT "BrakeConfig_RearBrakeTypeID_fkey" FOREIGN KEY ("RearBrakeTypeID") REFERENCES "BrakeType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BrakeConfig" ADD CONSTRAINT "BrakeConfig_BrakeABSID_fkey" FOREIGN KEY ("BrakeABSID") REFERENCES "BrakeABS"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BrakeConfig" ADD CONSTRAINT "BrakeConfig_BrakeSystemID_fkey" FOREIGN KEY ("BrakeSystemID") REFERENCES "BrakeSystem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VCChangeDetail" ADD CONSTRAINT "VCChangeDetail_ChangeID_fkey" FOREIGN KEY ("ChangeID") REFERENCES "VCChange"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VCChangeDetail" ADD CONSTRAINT "VCChangeDetail_ChangeAttributeStateID_fkey" FOREIGN KEY ("ChangeAttributeStateID") REFERENCES "ChangeAttributeState"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VCChangeDetail" ADD CONSTRAINT "VCChangeDetail_TableNameID_fkey" FOREIGN KEY ("TableNameID") REFERENCES "VCChangeTableName"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VCChange" ADD CONSTRAINT "VCChange_ChangeReasonID_fkey" FOREIGN KEY ("ChangeReasonID") REFERENCES "VCChangeReason"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Equipment" ADD CONSTRAINT "Equipment_EquipmentBaseID_fkey" FOREIGN KEY ("EquipmentBaseID") REFERENCES "EquipmentBase"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Equipment" ADD CONSTRAINT "Equipment_RegionID_fkey" FOREIGN KEY ("RegionID") REFERENCES "Region"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EquipmentBase" ADD CONSTRAINT "EquipmentBase_MfrID_fkey" FOREIGN KEY ("MfrID") REFERENCES "Mfr"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EquipmentBase" ADD CONSTRAINT "EquipmentBase_EquipmentModelID_fkey" FOREIGN KEY ("EquipmentModelID") REFERENCES "EquipmentModel"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EquipmentBase" ADD CONSTRAINT "EquipmentBase_VehicleTypeId_fkey" FOREIGN KEY ("VehicleTypeId") REFERENCES "VehicleType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EquipmentToEngineConfig" ADD CONSTRAINT "EquipmentToEngineConfig_EquipmentID_fkey" FOREIGN KEY ("EquipmentID") REFERENCES "Equipment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EquipmentToEngineConfig" ADD CONSTRAINT "EquipmentToEngineConfig_EngineConfigID_fkey" FOREIGN KEY ("EngineConfigID") REFERENCES "EngineConfig2"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FuelDeliveryConfig" ADD CONSTRAINT "FuelDeliveryConfig_FuelDeliveryTypeID_fkey" FOREIGN KEY ("FuelDeliveryTypeID") REFERENCES "FuelDeliveryType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FuelDeliveryConfig" ADD CONSTRAINT "FuelDeliveryConfig_FuelDeliverySubTypeID_fkey" FOREIGN KEY ("FuelDeliverySubTypeID") REFERENCES "FuelDeliverySubType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FuelDeliveryConfig" ADD CONSTRAINT "FuelDeliveryConfig_FuelSystemControlTypeID_fkey" FOREIGN KEY ("FuelSystemControlTypeID") REFERENCES "FuelSystemControlType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FuelDeliveryConfig" ADD CONSTRAINT "FuelDeliveryConfig_FuelSystemDesignID_fkey" FOREIGN KEY ("FuelSystemDesignID") REFERENCES "FuelSystemDesign"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LanguageTranslation" ADD CONSTRAINT "LanguageTranslation_EnglishPhraseID_fkey" FOREIGN KEY ("EnglishPhraseID") REFERENCES "EnglishPhrase"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LanguageTranslation" ADD CONSTRAINT "LanguageTranslation_LanguageID_fkey" FOREIGN KEY ("LanguageID") REFERENCES "VCLanguage"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LanguageTranslationAttachment" ADD CONSTRAINT "LanguageTranslationAttachment_LanguageTranslationID_fkey" FOREIGN KEY ("LanguageTranslationID") REFERENCES "LanguageTranslation"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Model" ADD CONSTRAINT "Model_VehicleTypeID_fkey" FOREIGN KEY ("VehicleTypeID") REFERENCES "VehicleType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Region" ADD CONSTRAINT "Region_ParentID_fkey" FOREIGN KEY ("ParentID") REFERENCES "Region"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpringType" ADD CONSTRAINT "SpringType_frontConfigs_fkey" FOREIGN KEY ("frontConfigs") REFERENCES "SpringTypeConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SpringType" ADD CONSTRAINT "SpringType_rearConfigs_fkey" FOREIGN KEY ("rearConfigs") REFERENCES "SpringTypeConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SteeringConfig" ADD CONSTRAINT "SteeringConfig_SteeringType_fkey" FOREIGN KEY ("SteeringType") REFERENCES "SteeringType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SteeringConfig" ADD CONSTRAINT "SteeringConfig_SteeringSystem_fkey" FOREIGN KEY ("SteeringSystem") REFERENCES "SteeringSystem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transmission" ADD CONSTRAINT "Transmission_TransmissionBase_fkey" FOREIGN KEY ("TransmissionBase") REFERENCES "TransmissionBase"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transmission" ADD CONSTRAINT "Transmission_TransmissionMfrCode_fkey" FOREIGN KEY ("TransmissionMfrCode") REFERENCES "TransmissionMfrCode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transmission" ADD CONSTRAINT "Transmission_TransmissionElecControlled_fkey" FOREIGN KEY ("TransmissionElecControlled") REFERENCES "ElecControlled"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transmission" ADD CONSTRAINT "Transmission_TransmissionMfr_fkey" FOREIGN KEY ("TransmissionMfr") REFERENCES "Mfr"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TransmissionBase" ADD CONSTRAINT "TransmissionBase_TransmissionType_fkey" FOREIGN KEY ("TransmissionType") REFERENCES "TransmissionType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TransmissionBase" ADD CONSTRAINT "TransmissionBase_TransmissionNumSpeeds_fkey" FOREIGN KEY ("TransmissionNumSpeeds") REFERENCES "TransmissionNumSpeed"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TransmissionBase" ADD CONSTRAINT "TransmissionBase_TransmissionControlType_fkey" FOREIGN KEY ("TransmissionControlType") REFERENCES "TransmissionControlType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_BaseVehicleID_fkey" FOREIGN KEY ("BaseVehicleID") REFERENCES "BaseVehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_TransmissionID_fkey" FOREIGN KEY ("TransmissionID") REFERENCES "Transmission"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_DriveTypeID_fkey" FOREIGN KEY ("DriveTypeID") REFERENCES "DriveType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_BodyNumDoorsID_fkey" FOREIGN KEY ("BodyNumDoorsID") REFERENCES "BodyNumDoors"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_BodyTypeID_fkey" FOREIGN KEY ("BodyTypeID") REFERENCES "BodyType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_BrakeSystemID_fkey" FOREIGN KEY ("BrakeSystemID") REFERENCES "BrakeSystem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_RegionID_fkey" FOREIGN KEY ("RegionID") REFERENCES "Region"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_BedLengthID_fkey" FOREIGN KEY ("BedLengthID") REFERENCES "BedLength"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_BedTypeID_fkey" FOREIGN KEY ("BedTypeID") REFERENCES "BedType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_WheelBaseID_fkey" FOREIGN KEY ("WheelBaseID") REFERENCES "WheelBase"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_MfrBodyCodeID_fkey" FOREIGN KEY ("MfrBodyCodeID") REFERENCES "MfrBodyCode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_SteeringSystemID_fkey" FOREIGN KEY ("SteeringSystemID") REFERENCES "SteeringSystem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_SteeringTypeID_fkey" FOREIGN KEY ("SteeringTypeID") REFERENCES "SteeringType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_BrakeTypeID_fkey" FOREIGN KEY ("BrakeTypeID") REFERENCES "BrakeType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_SpringTypeID_fkey" FOREIGN KEY ("SpringTypeID") REFERENCES "SpringType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_FuelTypeID_fkey" FOREIGN KEY ("FuelTypeID") REFERENCES "FuelType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_EngineBaseID_fkey" FOREIGN KEY ("EngineBaseID") REFERENCES "EngineBase"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Vehicle" ADD CONSTRAINT "Vehicle_TransmissionBaseID_fkey" FOREIGN KEY ("TransmissionBaseID") REFERENCES "TransmissionBase"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBedConfig" ADD CONSTRAINT "VehicleToBedConfig_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBedConfig" ADD CONSTRAINT "VehicleToBedConfig_BedConfigID_fkey" FOREIGN KEY ("BedConfigID") REFERENCES "BedConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBodyConfig" ADD CONSTRAINT "VehicleToBodyConfig_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBodyConfig" ADD CONSTRAINT "VehicleToBodyConfig_WheelBaseID_fkey" FOREIGN KEY ("WheelBaseID") REFERENCES "WheelBase"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBodyConfig" ADD CONSTRAINT "VehicleToBodyConfig_BedConfigID_fkey" FOREIGN KEY ("BedConfigID") REFERENCES "BedConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBodyConfig" ADD CONSTRAINT "VehicleToBodyConfig_BodyStyleConfigID_fkey" FOREIGN KEY ("BodyStyleConfigID") REFERENCES "BodyStyleConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBodyConfig" ADD CONSTRAINT "VehicleToBodyConfig_MfrBodyCodeID_fkey" FOREIGN KEY ("MfrBodyCodeID") REFERENCES "MfrBodyCode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBodyStyleConfig" ADD CONSTRAINT "VehicleToBodyStyleConfig_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBodyStyleConfig" ADD CONSTRAINT "VehicleToBodyStyleConfig_BodyStyleConfigID_fkey" FOREIGN KEY ("BodyStyleConfigID") REFERENCES "BodyStyleConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBrakeConfig" ADD CONSTRAINT "VehicleToBrakeConfig_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToBrakeConfig" ADD CONSTRAINT "VehicleToBrakeConfig_BrakeConfigID_fkey" FOREIGN KEY ("BrakeConfigID") REFERENCES "BrakeConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToClass" ADD CONSTRAINT "VehicleToClass_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToClass" ADD CONSTRAINT "VehicleToClass_ClassID_fkey" FOREIGN KEY ("ClassID") REFERENCES "Class"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToDriveType" ADD CONSTRAINT "VehicleToDriveType_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToDriveType" ADD CONSTRAINT "VehicleToDriveType_DriveTypeID_fkey" FOREIGN KEY ("DriveTypeID") REFERENCES "DriveType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToEngineConfig" ADD CONSTRAINT "VehicleToEngineConfig_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToEngineConfig" ADD CONSTRAINT "VehicleToEngineConfig_EngineConfigID_fkey" FOREIGN KEY ("EngineConfigID") REFERENCES "EngineConfig2"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToMfrBodyCode" ADD CONSTRAINT "VehicleToMfrBodyCode_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToMfrBodyCode" ADD CONSTRAINT "VehicleToMfrBodyCode_MfrBodyCodeID_fkey" FOREIGN KEY ("MfrBodyCodeID") REFERENCES "MfrBodyCode"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToSpringTypeConfig" ADD CONSTRAINT "VehicleToSpringTypeConfig_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToSpringTypeConfig" ADD CONSTRAINT "VehicleToSpringTypeConfig_SpringTypeConfigID_fkey" FOREIGN KEY ("SpringTypeConfigID") REFERENCES "SpringTypeConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToSteeringConfig" ADD CONSTRAINT "VehicleToSteeringConfig_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToSteeringConfig" ADD CONSTRAINT "VehicleToSteeringConfig_SteeringConfigID_fkey" FOREIGN KEY ("SteeringConfigID") REFERENCES "SteeringConfig"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToTransmission" ADD CONSTRAINT "VehicleToTransmission_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToTransmission" ADD CONSTRAINT "VehicleToTransmission_TransmissionID_fkey" FOREIGN KEY ("TransmissionID") REFERENCES "Transmission"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToWheelbase" ADD CONSTRAINT "VehicleToWheelbase_VehicleID_fkey" FOREIGN KEY ("VehicleID") REFERENCES "Vehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleToWheelbase" ADD CONSTRAINT "VehicleToWheelbase_WheelbaseID_fkey" FOREIGN KEY ("WheelbaseID") REFERENCES "WheelBase"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VehicleType" ADD CONSTRAINT "VehicleType_VehicleTypeGroupID_fkey" FOREIGN KEY ("VehicleTypeGroupID") REFERENCES "VehicleTypeGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;
