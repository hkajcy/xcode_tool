/*
 * Copyright (C) 2010 Andras Becsi <abecsi@inf.u-szeged.hu>, University of Szeged
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#ifndef HashTools_h
#define HashTools_h

struct PubIDInfo {
    enum eMode {
        eQuirks,
        eQuirks3,
        eAlmostStandards
    };

    const char* name;
    enum eMode mode_if_no_sysid;
    enum eMode mode_if_sysid;
};

struct NamedColor {
    const char* name;
    unsigned ARGBValue;
};

struct Property {
    const char* name;
    int id;
};

struct Value {
    const char* name;
    int id;
};

const struct PubIDInfo* findDoctypeEntry(register const char* str, register unsigned int len);
const struct NamedColor* findColor(register const char* str, register unsigned int len);
const struct Property* findProperty(register const char* str, register unsigned int len);
const struct Value* findValue(register const char* str, register unsigned int len);

inline int redChannel(unsigned color) { return (color >> 16) & 0xFF; }
inline int greenChannel(unsigned color) { return (color >> 8) & 0xFF; }
inline int blueChannel(unsigned color) { return color & 0xFF; }
inline int alphaChannel(unsigned color) { return (color >> 24) & 0xFF; }


#endif // HashTools_h
