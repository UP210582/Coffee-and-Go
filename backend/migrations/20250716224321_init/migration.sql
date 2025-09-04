/*
  Warnings:

  - You are about to drop the `Post` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Tag` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_Post_tags` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Post" DROP CONSTRAINT "Post_author_fkey";

-- DropForeignKey
ALTER TABLE "_Post_tags" DROP CONSTRAINT "_Post_tags_A_fkey";

-- DropForeignKey
ALTER TABLE "_Post_tags" DROP CONSTRAINT "_Post_tags_B_fkey";

-- DropTable
DROP TABLE "Post";

-- DropTable
DROP TABLE "Tag";

-- DropTable
DROP TABLE "_Post_tags";

-- CreateTable
CREATE TABLE "BaseVehicle" (
    "id" TEXT NOT NULL,
    "yearId" INTEGER,
    "make" TEXT,
    "model" TEXT,

    CONSTRAINT "BaseVehicle_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Make" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Make_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Model" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Model_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartType" (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PartType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "App" (
    "id" TEXT NOT NULL,
    "action" TEXT NOT NULL DEFAULT '',
    "qty" INTEGER,
    "baseVehicle" TEXT,
    "yearsFrom" INTEGER,
    "yearsTo" INTEGER,
    "make" TEXT,
    "model" TEXT,
    "submodelId" INTEGER,
    "engineBaseId" INTEGER,
    "engineBlockId" INTEGER,
    "positionId" INTEGER,
    "mfrId" INTEGER,
    "equipmentModelId" INTEGER,
    "vehicleTypeId" INTEGER,
    "productionStartYear" INTEGER,
    "productionEndYear" INTEGER,
    "partType" TEXT,
    "partNumber" TEXT NOT NULL DEFAULT '',
    "brandAAIAID" TEXT NOT NULL DEFAULT '',
    "subbrandAAIAID" TEXT NOT NULL DEFAULT '',
    "assetName" TEXT NOT NULL DEFAULT '',
    "assetItemOrder" INTEGER,
    "notes" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "App_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Qualifier" (
    "id" TEXT NOT NULL,
    "app" TEXT,
    "qualId" INTEGER,
    "paramValue1" TEXT NOT NULL DEFAULT '',
    "paramValue2" TEXT NOT NULL DEFAULT '',
    "text" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Qualifier_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DigitalAsset" (
    "id" TEXT NOT NULL,
    "assetName" TEXT NOT NULL DEFAULT '',
    "fileName" TEXT NOT NULL DEFAULT '',
    "fileType" TEXT NOT NULL DEFAULT '',
    "uri" TEXT NOT NULL DEFAULT '',
    "fileDateModified" TIMESTAMP(3),
    "effectiveDate" TIMESTAMP(3),
    "expirationDate" TIMESTAMP(3),

    CONSTRAINT "DigitalAsset_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Asset" (
    "id" TEXT NOT NULL,
    "yearsFrom" INTEGER,
    "yearsTo" INTEGER,
    "make" TEXT,
    "model" TEXT,
    "submodelId" INTEGER,
    "engineBaseId" INTEGER,
    "note" TEXT NOT NULL DEFAULT '',
    "assetName" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Asset_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "BaseVehicle_make_idx" ON "BaseVehicle"("make");

-- CreateIndex
CREATE INDEX "BaseVehicle_model_idx" ON "BaseVehicle"("model");

-- CreateIndex
CREATE INDEX "App_baseVehicle_idx" ON "App"("baseVehicle");

-- CreateIndex
CREATE INDEX "App_make_idx" ON "App"("make");

-- CreateIndex
CREATE INDEX "App_model_idx" ON "App"("model");

-- CreateIndex
CREATE INDEX "App_partType_idx" ON "App"("partType");

-- CreateIndex
CREATE INDEX "Qualifier_app_idx" ON "Qualifier"("app");

-- CreateIndex
CREATE UNIQUE INDEX "DigitalAsset_assetName_key" ON "DigitalAsset"("assetName");

-- CreateIndex
CREATE INDEX "Asset_make_idx" ON "Asset"("make");

-- CreateIndex
CREATE INDEX "Asset_model_idx" ON "Asset"("model");

-- AddForeignKey
ALTER TABLE "BaseVehicle" ADD CONSTRAINT "BaseVehicle_make_fkey" FOREIGN KEY ("make") REFERENCES "Make"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BaseVehicle" ADD CONSTRAINT "BaseVehicle_model_fkey" FOREIGN KEY ("model") REFERENCES "Model"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "App" ADD CONSTRAINT "App_baseVehicle_fkey" FOREIGN KEY ("baseVehicle") REFERENCES "BaseVehicle"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "App" ADD CONSTRAINT "App_make_fkey" FOREIGN KEY ("make") REFERENCES "Make"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "App" ADD CONSTRAINT "App_model_fkey" FOREIGN KEY ("model") REFERENCES "Model"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "App" ADD CONSTRAINT "App_partType_fkey" FOREIGN KEY ("partType") REFERENCES "PartType"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Qualifier" ADD CONSTRAINT "Qualifier_app_fkey" FOREIGN KEY ("app") REFERENCES "App"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_make_fkey" FOREIGN KEY ("make") REFERENCES "Make"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asset" ADD CONSTRAINT "Asset_model_fkey" FOREIGN KEY ("model") REFERENCES "Model"("id") ON DELETE SET NULL ON UPDATE CASCADE;
