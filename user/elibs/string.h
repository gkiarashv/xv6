#ifndef ESTRING_H
#define ESTRING_H

#include "user/etypes.h"


u32 get_strlen(const u8 * str);
u8 compare_str(const u8 * s1 , const u8 * s2);
u8 compare_str_ic(const u8 * s1 , const u8 * s2);

#endif