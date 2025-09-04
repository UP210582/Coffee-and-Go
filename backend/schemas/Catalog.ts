import { list } from '@keystone-6/core';
import { text, select } from '@keystone-6/core/fields';

export const Catalog = list({
  access: {
    operation: {
      query: () => true,
      create: () => true,
      update: () => true,
      delete: () => true,
    },
  },
  fields: {
    type: select({
      options: [
        { label: 'ACES', value: 'ACES' },
        { label: 'PIES', value: 'PIES' },
      ],
      validation: { isRequired: true },
    }),
    message: text(),
    filePath: text(),           // ruta del archivo subido
    originalFilename: text(),   // nombre original
  },
});
