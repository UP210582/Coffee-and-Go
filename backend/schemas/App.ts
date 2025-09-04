import { list } from '@keystone-6/core';
import { text, integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const App = list({
    access: allowAll,
  fields: {
    action: text(),
    qty: integer(),
    baseVehicle: relationship({ ref: 'BaseVehicle' }),
    yearsFrom: integer(),
    yearsTo: integer(),
    make: relationship({ ref: 'Make' }),
    model: relationship({ ref: 'Model' }),
    submodelId: integer(),
    engineBaseId: integer(),
    engineBlockId: integer(),
    positionId: integer(),
    mfrId: integer(),
    equipmentModelId: integer(),
    vehicleTypeId: integer(),
    productionStartYear: integer(),
    productionEndYear: integer(),
    partType: relationship({ ref: 'PartType' }),
    partNumber: text(),
    brandAAIAID: text(),
    subbrandAAIAID: text(),
    assetName: text(),
    assetItemOrder: integer(),
    notes: text({ ui: { displayMode: 'textarea' } }),
  },
});
