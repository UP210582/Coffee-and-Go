import { list } from '@keystone-6/core';
import { timestamp } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QVersion = list({
  access: allowAll,
  fields: {
    VersionDate: timestamp({ validation: { isRequired: true } }),
  },
});
