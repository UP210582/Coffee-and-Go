import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToDriveType = list({
  access: allowAll,
  fields: {
    VehicleToDriveTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle' }),
    DriveTypeID: relationship({ ref: 'DriveType' }),
    Source: text(),
  },
});
