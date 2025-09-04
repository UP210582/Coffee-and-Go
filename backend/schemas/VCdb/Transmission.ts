// Transmission.ts
import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Transmission = list({
  access: allowAll,
  fields: {
    TransmissionID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),

    TransmissionBaseID: integer(),
    TransmissionBase: relationship({ ref: 'TransmissionBase.transmissions', many: false }),

    TransmissionMfrCodeID: integer(),
    TransmissionMfrCode: relationship({ ref: 'TransmissionMfrCode.transmissions', many: false }),

    TransmissionElecControlledID: integer(),
    TransmissionElecControlled: relationship({ ref: 'ElecControlled.transmissions', many: false }),

    TransmissionMfrID: integer(),
    TransmissionMfr: relationship({ ref: 'Mfr.transmissions', many: false }),
  },
});
