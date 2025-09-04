-- CreateTable
CREATE TABLE "VCdbMake" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT '',
    "aaiaid" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VCdbMake_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VCdbModel" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT '',
    "vcdbMake" TEXT,
    "aaiaid" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VCdbModel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VCdbEngineBase" (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "aaiaid" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "VCdbEngineBase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "QdbQualifierCode" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "QdbQualifierCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PCdbPartType" (
    "id" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "aaiaid" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PCdbPartType_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "VCdbMake_aaiaid_idx" ON "VCdbMake"("aaiaid");

-- CreateIndex
CREATE INDEX "VCdbModel_vcdbMake_idx" ON "VCdbModel"("vcdbMake");

-- CreateIndex
CREATE INDEX "VCdbModel_aaiaid_idx" ON "VCdbModel"("aaiaid");

-- CreateIndex
CREATE INDEX "VCdbEngineBase_aaiaid_idx" ON "VCdbEngineBase"("aaiaid");

-- CreateIndex
CREATE INDEX "QdbQualifierCode_code_idx" ON "QdbQualifierCode"("code");

-- CreateIndex
CREATE INDEX "PCdbPartType_aaiaid_idx" ON "PCdbPartType"("aaiaid");

-- AddForeignKey
ALTER TABLE "VCdbModel" ADD CONSTRAINT "VCdbModel_vcdbMake_fkey" FOREIGN KEY ("vcdbMake") REFERENCES "VCdbMake"("id") ON DELETE SET NULL ON UPDATE CASCADE;
