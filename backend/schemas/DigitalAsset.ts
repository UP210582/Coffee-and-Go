import { list } from '@keystone-6/core';
import { text, timestamp } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';


export const DigitalAsset = list({
    access:allowAll,            
  fields: {
    assetName: text({ validation: { isRequired: true }, isIndexed: 'unique' }),
    fileName: text(),
    fileType: text(),
    uri: text(),
    fileDateModified: timestamp(),
    effectiveDate: timestamp(),
    expirationDate: timestamp(),
  },
});
