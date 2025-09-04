import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';

export const AcesApp = list({
  access: {
    operation: { query: () => true, create: () => true, update: () => true, delete: () => true },
  },
  fields: {
    action: text({ db: { isNullable: true } }),
    externalId: text({ db: { isNullable: true } }),
    baseVehicleId: text({ db: { isNullable: true } }),
    yearsFrom: integer({ db: { isNullable: true } }),
    yearsTo: integer({ db: { isNullable: true } }),
    makeId: text({ db: { isNullable: true } }),
    modelId: text({ db: { isNullable: true } }),
    subModelId: text({ db: { isNullable: true } }),
    engineBaseId: text({ db: { isNullable: true } }),
    engineBlockId: text({ db: { isNullable: true } }),
    engineVINId: text({ db: { isNullable: true } }),
    mfrId: text({ db: { isNullable: true } }),
    equipmentModelId: text({ db: { isNullable: true } }),
    vehicleTypeId: text({ db: { isNullable: true } }),
    equipmentBaseId: text({ db: { isNullable: true } }),
    positionId: text({ db: { isNullable: true } }),
    qty: integer({ db: { isNullable: true } }),
    partTypeId: text({ db: { isNullable: true } }),
    partNumber: text({ db: { isNullable: true } }),
    notes: text({ db: { isNullable: true } }),
    rawJSON: text({ db: { isNullable: true } }),
  },
});
