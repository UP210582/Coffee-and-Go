// TransmissionBase.ts
import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const TransmissionBase = list({
  access: allowAll,
  fields: {
    TransmissionBaseID: integer({ validation: { isRequired: true } }),

    TransmissionType: relationship({ ref: 'TransmissionType.transmissionBases', db: { foreignKey: true } }),
    TransmissionNumSpeeds: relationship({ ref: 'TransmissionNumSpeed.transmissionBases', db: { foreignKey: true } }),
    TransmissionControlType: relationship({ ref: 'TransmissionControlType.transmissionBases', db: { foreignKey: true } }),

    transmissions: relationship({ ref: 'Transmission.TransmissionBase', many: true }),
  },
});
