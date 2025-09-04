import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';

export const AcesDigitalFileInformation = list({
  access: {
    operation: { query: () => true, create: () => true, update: () => true, delete: () => true },
  },
  fields: {
    action: text({ db: { isNullable: true } }),
    languageCode: text({ db: { isNullable: true } }),
    assetName: text({ db: { isNullable: true } }),
    fileName: text({ db: { isNullable: true } }),
    assetDetailType: text({ db: { isNullable: true } }),
    fileType: text({ db: { isNullable: true } }),
    representation: text({ db: { isNullable: true } }),
    fileSize: integer({ db: { isNullable: true } }),
    resolution: integer({ db: { isNullable: true } }),
    colorMode: text({ db: { isNullable: true } }),
    background: text({ db: { isNullable: true } }),
    orientationView: text({ db: { isNullable: true } }),
    assetHeight: integer({ db: { isNullable: true } }),
    assetWidth: integer({ db: { isNullable: true } }),
    uom: text({ db: { isNullable: true } }),
    assetDescription: text({ db: { isNullable: true } }),
    filePath: text({ db: { isNullable: true } }),
    uri: text({ db: { isNullable: true } }),
    fileDateModified: text({ db: { isNullable: true } }),
    effectiveDate: text({ db: { isNullable: true } }),
    expirationDate: text({ db: { isNullable: true } }),
    country: text({ db: { isNullable: true } }),
    rawJSON: text({ db: { isNullable: true } }),
  },
});
