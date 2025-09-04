import { list } from '@keystone-6/core';
import { timestamp, integer, text, select } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QdbChange = list({
  access: allowAll,
  fields: {
    VersionDate: timestamp(),
    QualifierID: integer(),
    QualifierText: text(),
    Action: select({ options: [{ label: 'Action', value: 'A' }] }),
  },
});
