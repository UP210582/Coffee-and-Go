import { config } from '@keystone-6/core';
import { lists } from './schema';
import express from 'express';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import dotenv from 'dotenv';
import { XMLParser } from 'fast-xml-parser';

dotenv.config();

// === CONFIGURACIÓN DE CARPETA DE UPLOADS ===
const UPLOAD_DIR = path.join(__dirname, 'public', 'uploads');
if (!fs.existsSync(UPLOAD_DIR)) {
  console.log(`📂 Creando carpeta de uploads en: ${UPLOAD_DIR}`);
  fs.mkdirSync(UPLOAD_DIR, { recursive: true });
}

// === CONFIGURACIÓN DE MULTER ===
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, UPLOAD_DIR),
  filename: (req, file, cb) => {
    const timestamp = Date.now();
    const safeName = file.originalname.replace(/\s+/g, '_');
    cb(null, `${timestamp}_${safeName}`);
  },
});
const upload = multer({ storage });

// Helpers de parseo/normalización
function asArray<T>(val: T | T[] | undefined): T[] {
  if (!val) return [];
  return Array.isArray(val) ? val : [val];
}
function getAttr(obj: any, name: string) {
  return obj?.[`@_${name}`];
}
function intOrNull(v: any) {
  const n = parseInt(String(v ?? ''), 10);
  return Number.isFinite(n) ? n : null;
}

export default config({
  db: {
    provider: 'postgresql',
    url: process.env.DATABASE_URL!,
  },
  lists,
  server: {
    port: 8000,
    extendExpressApp: (app, context) => {
      app.post('/upload', upload.array('files'), async (req, res) => {
        try {
          const { catalogType } = req.body;
          const files = req.files as Express.Multer.File[];

          if (!catalogType) return res.status(400).json({ message: 'El campo catalogType es obligatorio' });
          if (!files || files.length === 0) return res.status(400).json({ message: 'No se enviaron archivos' });

          // Parser XML
          const parser = new XMLParser({
            ignoreAttributes: false,
            allowBooleanAttributes: true,
            parseTagValue: false,
            parseAttributeValue: false,
            trimValues: true,
          });

          let summary = { 
            newRecords: 0, 
            editedRecords: 0, 
            deletedRecords: 0,
            newItems: [] as any[],
            editedItems: [] as any[],
            deletedItems: [] as any[],
          };
          let createdCount = 0;

          for (const file of files) {
            // 1) Log en Catalog
            await context.db.Catalog.createOne({
              data: {
                type: catalogType,
                message: `Archivo ${file.originalname} subido correctamente`,
                filePath: `/uploads/${file.filename}`,
                originalFilename: file.originalname,
              },
            });
            createdCount++;

            // 2) Parsear si es ACES
            if (catalogType === 'ACES') {
              const xml = fs.readFileSync(file.path, 'utf8');
              const data = parser.parse(xml);

              const aces = data?.ACES || {};
              // === APPS ===
              const Apps = asArray<any>(aces.App);
              for (const A of Apps) {
                const action = getAttr(A, 'action') || 'A';
                const externalId = getAttr(A, 'id') || null;

                const baseVehicleId = getAttr(A?.BaseVehicle, 'id') || null;

                const yearsFrom = intOrNull(getAttr(A?.Years, 'from'));
                const yearsTo = intOrNull(getAttr(A?.Years, 'to'));
                const makeId = getAttr(A?.Make, 'id') || null;
                const modelId = getAttr(A?.Model, 'id') || null;
                const subModelId = getAttr(A?.SubModel, 'id') || null;

                const engineBaseId = (A?.EngineBase && getAttr(A.EngineBase, 'id')) || null;
                const engineBlockId = (A?.EngineBlock && getAttr(A.EngineBlock, 'id')) || null;
                const engineVINId = (A?.EngineVIN && getAttr(A.EngineVIN, 'id')) || null;

                const mfrId = (A?.Mfr && getAttr(A.Mfr, 'id')) || null;
                const equipmentModelId = (A?.EquipmentModel && getAttr(A.EquipmentModel, 'id')) || null;
                const equipmentBaseId = (A?.EquipmentBase && getAttr(A.EquipmentBase, 'id')) || null;
                const vehicleTypeId = (A?.VehicleType && getAttr(A.VehicleType, 'id')) || null;

                const positionId = (A?.Position && getAttr(A.Position, 'id')) || null;

                const qty = intOrNull(A?.Qty ?? null);
                const partTypeId = (A?.PartType && getAttr(A.PartType, 'id')) || null;

                let partNumber: string | null = null;
                if (typeof A?.Part === 'string') {
                  partNumber = A.Part;
                } else if (A?.Part && typeof A.Part === 'object') {
                  partNumber = String(A.Part?.['#text'] ?? A.Part?._ ?? '') || null;
                }

                const notesArr = asArray<string>(A?.Note);
                const notes = notesArr.filter(Boolean).join(' | ') || null;

                if (action === 'M' && externalId) {
                  try {
                    await context.query.AcesApp.updateMany({
                      data: [{ where: { externalId }, data: {
                        action, baseVehicleId, yearsFrom, yearsTo, makeId, modelId, subModelId,
                        engineBaseId, engineBlockId, engineVINId, mfrId, equipmentModelId,
                        vehicleTypeId, equipmentBaseId, positionId, qty, partTypeId, partNumber,
                        notes, rawJSON: JSON.stringify(A),
                      }}]
                    });
                    summary.editedRecords++;
                    summary.editedItems.push({ externalId, partNumber, baseVehicleId });
                  } catch {
                    const created = await context.db.AcesApp.createOne({
                      data: {
                        action, externalId, baseVehicleId, yearsFrom, yearsTo, makeId, modelId, subModelId,
                        engineBaseId, engineBlockId, engineVINId, mfrId, equipmentModelId,
                        vehicleTypeId, equipmentBaseId, positionId, qty, partTypeId, partNumber,
                        notes, rawJSON: JSON.stringify(A),
                      },
                    });
                    summary.newRecords++;
                    summary.newItems.push(created);
                  }
                } else if (action === 'D' && externalId) {
                  try {
                    await context.db.AcesApp.deleteOne({ where: { externalId } as any });
                    summary.deletedRecords++;
                    summary.deletedItems.push({ externalId, partNumber, baseVehicleId });
                  } catch {}
                } else {
                  const created = await context.db.AcesApp.createOne({
                    data: {
                      action, externalId, baseVehicleId, yearsFrom, yearsTo, makeId, modelId, subModelId,
                      engineBaseId, engineBlockId, engineVINId, mfrId, equipmentModelId,
                      vehicleTypeId, equipmentBaseId, positionId, qty, partTypeId, partNumber,
                      notes, rawJSON: JSON.stringify(A),
                    },
                  });
                  summary.newRecords++;
                  summary.newItems.push(created);
                }
              }

              // === ASSET ===
              const Assets = asArray<any>(aces.Asset);
              for (const As of Assets) {
                const action = getAttr(As, 'action') || 'A';
                const externalId = getAttr(As, 'id') || null;

                const yearsFrom = intOrNull(getAttr(As?.Years, 'from'));
                const yearsTo = intOrNull(getAttr(As?.Years, 'to'));
                const makeId = getAttr(As?.Make, 'id') || null;
                const modelId = getAttr(As?.Model, 'id') || null;
                const subModelId = getAttr(As?.SubModel, 'id') || null;
                const engineBaseId = getAttr(As?.EngineBase, 'id') || null;

                const assetName = As?.AssetName ?? null;
                const notesArr = asArray<string>(As?.Note);
                const notes = notesArr.filter(Boolean).join(' | ') || null;

                if (action === 'M' && externalId) {
                  try {
                    await context.query.AcesAsset.updateMany({
                      data: [{ where: { externalId }, data: {
                        action, yearsFrom, yearsTo, makeId, modelId, subModelId, engineBaseId,
                        assetName, notes, rawJSON: JSON.stringify(As),
                      }}]
                    });
                    summary.editedRecords++;
                    summary.editedItems.push({ externalId, assetName });
                  } catch {
                    const created = await context.db.AcesAsset.createOne({
                      data: {
                        action, externalId, yearsFrom, yearsTo, makeId, modelId, subModelId, engineBaseId,
                        assetName, notes, rawJSON: JSON.stringify(As),
                      },
                    });
                    summary.newRecords++;
                    summary.newItems.push(created);
                  }
                } else if (action === 'D' && externalId) {
                  try {
                    await context.db.AcesAsset.deleteOne({ where: { externalId } as any });
                    summary.deletedRecords++;
                    summary.deletedItems.push({ externalId, assetName });
                  } catch {}
                } else {
                  const created = await context.db.AcesAsset.createOne({
                    data: {
                      action, externalId, yearsFrom, yearsTo, makeId, modelId, subModelId, engineBaseId,
                      assetName, notes, rawJSON: JSON.stringify(As),
                    },
                  });
                  summary.newRecords++;
                  summary.newItems.push(created);
                }
              }

              // === DIGITAL ASSETS ===
              const DigitalAsset = aces.DigitalAsset;
              if (DigitalAsset) {
                const DFI = asArray<any>(DigitalAsset.DigitalFileInformation);
                for (const d of DFI) {
                  const action = getAttr(d, 'action') || 'A';
                  const languageCode = getAttr(d, 'LanguageCode') || null;
                  const assetName = getAttr(d, 'AssetName') || null;
                  const fileName = d?.FileName ?? null;

                  const assetDetailType = d?.AssetDetailType ?? null;
                  const fileType = d?.FileType ?? null;
                  const representation = d?.Representation ?? null;
                  const fileSize = intOrNull(d?.FileSize);
                  const resolution = intOrNull(d?.Resolution);
                  const colorMode = d?.ColorMode ?? null;
                  const background = d?.Background ?? null;
                  const orientationView = d?.OrientationView ?? null;

                  const dims = d?.AssetDimensions || {};
                  const uom = getAttr(dims, 'UOM') || null;
                  const assetHeight = intOrNull(dims?.AssetHeight);
                  const assetWidth = intOrNull(dims?.AssetWidth);

                  const assetDescription = d?.AssetDescription ?? null;
                  const filePath = d?.FilePath ?? null;
                  const uri = d?.URI ?? null;
                  const fileDateModified = d?.FileDateModified ?? null;
                  const effectiveDate = d?.EffectiveDate ?? null;
                  const expirationDate = d?.ExpirationDate ?? null;
                  const country = d?.Country ?? null;

                  const pseudoId = `${assetName ?? ''}__${fileName ?? ''}`;

                  if (action === 'M' && pseudoId) {
                    try {
                      await context.query.AcesDigitalFileInformation.updateMany({
                        data: [{
                          where: { id: pseudoId } as any,
                          data: {
                            action, languageCode, assetName, fileName, assetDetailType, fileType,
                            representation, fileSize, resolution, colorMode, background,
                            orientationView, assetHeight, assetWidth, uom, assetDescription,
                            filePath, uri, fileDateModified, effectiveDate, expirationDate, country,
                            rawJSON: JSON.stringify(d),
                          }
                        }]
                      });
                      summary.editedRecords++;
                      summary.editedItems.push({ pseudoId, assetName, fileName });
                    } catch {
                      const created = await context.db.AcesDigitalFileInformation.createOne({
                        data: {
                          action, languageCode, assetName, fileName, assetDetailType, fileType,
                          representation, fileSize, resolution, colorMode, background,
                          orientationView, assetHeight, assetWidth, uom, assetDescription,
                          filePath, uri, fileDateModified, effectiveDate, expirationDate, country,
                          rawJSON: JSON.stringify(d),
                        },
                      });
                      summary.newRecords++;
                      summary.newItems.push(created);
                    }
                  } else if (action === 'D' && pseudoId) {
                    summary.deletedRecords++;
                    summary.deletedItems.push({ pseudoId, assetName, fileName });
                  } else {
                    const created = await context.db.AcesDigitalFileInformation.createOne({
                      data: {
                        action, languageCode, assetName, fileName, assetDetailType, fileType,
                        representation, fileSize, resolution, colorMode, background,
                        orientationView, assetHeight, assetWidth, uom, assetDescription,
                        filePath, uri, fileDateModified, effectiveDate, expirationDate, country,
                        rawJSON: JSON.stringify(d),
                      },
                    });
                    summary.newRecords++;
                    summary.newItems.push(created);
                  }
                }
              }
            }
          }

          res.json({
            message: `✅ Catálogo ${catalogType} procesado`,
            totalFiles: files.length,
            successfullyCreated: createdCount,
            failed: files.length - createdCount,
            summary,
          });

        } catch (error: any) {
          console.error('💥 Error en /upload:', error);
          res.status(500).json({ message: 'Error al subir/procesar el catálogo', error: error.message || error });
        }
      });
    },
  },
  storage: {
    my_local_files: {
      kind: 'local',
      type: 'file',
      generateUrl: filePath => `/uploads/${path.basename(filePath)}`,
      serverRoute: { path: '/uploads' },
      storagePath: UPLOAD_DIR,
    },
  },
});
