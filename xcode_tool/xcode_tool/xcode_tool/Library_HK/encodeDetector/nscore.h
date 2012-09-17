/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is Mozilla Universal charset detector code.
 *
 * The Initial Developer of the Original Code is
 * Netscape Communications Corporation.
 * Portions created by the Initial Developer are Copyright (C) 2001
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *          Kohei TAKETA <k-tak@void.in>
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */
#ifndef nsDummyCore_h__
#define nsDummyCore_h__

typedef bool PRBool;
typedef int PRInt32;
typedef unsigned int PRUint32;
typedef short PRInt16;
typedef unsigned short PRUint16;
typedef signed char PRInt8;
typedef unsigned char PRUint8;

#define PR_FALSE false
#define PR_TRUE true
#define nsnull 0


enum nsresult
{
    NS_OK = 0,
	NS_DONE = 1,
    NS_ERROR_OUT_OF_MEMORY = 2,
};

// #define strHK_BIG5					("Big5")
// #define strHK_GB18030				("gb18030")
// #define strHK_UTF8					("UTF-8")
// #define strHK_UNICODE_BIG_ENDIAN	("UNICODE BIG ENDIAN")
// #define strHK_UNICODE_LITTLE_ENDIAN	("UNICODE LITTLE ENDIAN")
// #define strHK_ENCODING_DEFAULT		("Default")

#define HK_ENCODING_BIG5					(1)
#define HK_ENCODING_GB18030                 (2)
#define HK_ENCODING_UTF8					(3)
#define HK_ENCODING_UNICODE_BIG_ENDIAN      (4)
#define HK_ENCODING_UNICODE_LITTLE_ENDIAN	(5)
#define HK_ENCODING_ENCODING_DEFAULT		(6)

#endif
