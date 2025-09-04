import { list } from '@keystone-6/core';
import { text, calendarDay } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PAVersion = list({
  access: allowAll,
  fields: {
    pAdbVersion: text(),
    pAdbPublication: calendarDay(),
    pCdbPublication: calendarDay(),
  },
});
