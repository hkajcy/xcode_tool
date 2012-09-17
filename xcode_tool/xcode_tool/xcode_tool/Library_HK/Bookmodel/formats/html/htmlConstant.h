//
//  htmlConstance.h
//  DocinBookiPad
//
//  Created by  on 12-8-28.
//  Copyright (c) 2012年 Docin Ltd. All rights reserved.
//

#ifndef _HTMLCONSTANT_H_
#define _HTMLCONSTANT_H_

#define XML_NAMESPACE "http://www.w3.org/2000/xmlns/"
#define SVG_NAMESPACE "http://www.w3.org/2000/svg"
#define XHTML_NAMESPACE "http://www.w3.org/1999/xhtml"
#define XLINK_NAMESPACE "http://www.w3.org/1999/xlink"

#define NodeImpl_IdNSMask    0xffff0000
#define NodeImpl_IdLocalMask 0x0000ffff

#define xmlNamespace 4
#define svgNamespace 2
#define xhtmlNamespace 0
#define xlinkNamespace 3
#define emptyNamespace 1
#define anyNamespace 0xffff
#define anyLocalName 0xffff
#define emptyPrefix 0

#define ID_A 1
#define ID_ABBR 2
#define ATTR_ABBR ((emptyNamespace << 16) | 2)
#define ID_ACRONYM 3
#define ID_ADDRESS 4
#define ID_APPLET 5
#define ID_AREA 6
#define ID_AUDIO 7
#define ID_B 8
#define ID_BASE 9
#define ATTR_XML_BASE ((xmlNamespace << 16) | 9)
#define ID_BASEFONT 10
#define ID_BDO 11
#define ID_BIG 12
#define ID_BLOCKQUOTE 13
#define ID_BODY 14
#define ID_BR 15
#define ID_BUTTON 16
#define ID_CANVAS 17
#define ID_CAPTION 18
#define ID_CENTER 19
#define ID_CITE 20
#define ATTR_CITE ((emptyNamespace << 16) | 20)
#define ID_CODE 21
#define ATTR_CODE ((emptyNamespace << 16) | 21)
#define ID_COL 22
#define ID_COLGROUP 23
#define ID_DD 24
#define ID_DEL 25
#define ID_DFN 26
#define ID_DIR 27
#define ATTR_DIR ((emptyNamespace << 16) | 27)
#define ID_DIV 28
#define ID_DL 29
#define ID_DT 30
#define ID_EM 31
#define ID_EMBED 32
#define ID_FIELDSET 33
#define ID_FONT 34
#define ID_FORM 35
#define ID_FRAME 36
#define ATTR_FRAME ((emptyNamespace << 16) | 36)
#define ID_FRAMESET 37
#define ID_H1 38
#define ID_H2 39
#define ID_H3 40
#define ID_H4 41
#define ID_H5 42
#define ID_H6 43
#define ID_HEAD 44
#define ID_HR 45
#define ID_HTML 46
#define ATTR_HTML ((emptyNamespace << 16) | 46)
#define ID_I 47
#define ID_IFRAME 48
#define ID_ILAYER 49
#define ID_IMAGE 50
#define ID_IMG 51
#define ID_INPUT 52
#define ID_INS 53
#define ID_ISINDEX 54
#define ID_KBD 55
#define ID_KEYGEN 56
#define ID_LABEL 57
#define ATTR_LABEL ((emptyNamespace << 16) | 57)
#define ID_LAYER 58
#define ID_LEGEND 59
#define ID_LI 60
#define ID_LINK 61
#define ATTR_LINK ((emptyNamespace << 16) | 61)
#define ID_LISTING 62
#define ID_MAP 63
#define ID_MARQUEE 64
#define ID_MENU 65
#define ID_META 66
#define ID_NOBR 67
#define ID_NOEMBED 68
#define ID_NOFRAMES 69
#define ID_NOSCRIPT 70
#define ID_NOLAYER 71
#define ID_OBJECT 72
#define ATTR_OBJECT ((emptyNamespace << 16) | 72)
#define ID_OL 73
#define ID_OPTGROUP 74
#define ID_OPTION 75
#define ID_P 76
#define ID_PARAM 77
#define ID_PLAINTEXT 78
#define ID_PRE 79
#define ID_Q 80
#define ID_S 81
#define ID_SAMP 82
#define ID_SCRIPT 83
#define ID_SELECT 84
#define ID_SMALL 85
#define ID_SOURCE 86
#define ID_SPAN 87
#define ATTR_SPAN ((emptyNamespace << 16) | 87)
#define ID_STRIKE 88
#define ID_STRONG 89
#define ID_STYLE 90
#define ATTR_STYLE ((emptyNamespace << 16) | 90)
#define ID_SUB 91
#define ID_SUP 92
#define ID_TABLE 93
#define ID_TBODY 94
#define ID_TD 95
#define ID_TEXTAREA 96
#define ID_TFOOT 97
#define ID_TH 98
#define ID_THEAD 99
#define ID_TITLE 100
#define ATTR_XLINK_TITLE ((xlinkNamespace << 16) | 100)
#define ATTR_TITLE ((emptyNamespace << 16) | 100)
#define ID_TR 101
#define ID_TT 102
#define ID_U 103
#define ID_UL 104
#define ID_VAR 105
#define ID_VIDEO 106
#define ID_WBR 107
#define ID_XMP 108
#define ID_TEXT 109
#define ID_COMMENT 110
#define ATTR_ACCEPT_CHARSET ((emptyNamespace << 16) | 111)
#define ATTR_ACCEPT ((emptyNamespace << 16) | 112)
#define ATTR_ACCESSKEY ((emptyNamespace << 16) | 113)
#define ATTR_ALIGN ((emptyNamespace << 16) | 114)
#define ATTR_ALINK ((emptyNamespace << 16) | 115)
#define ATTR_AUTOCOMPLETE ((emptyNamespace << 16) | 116)
#define ATTR_AUTOPLAY ((emptyNamespace << 16) | 117)
#define ATTR_AXIS ((emptyNamespace << 16) | 118)
#define ATTR_BEHAVIOR ((emptyNamespace << 16) | 119)
#define ATTR_BGCOLOR ((emptyNamespace << 16) | 120)
#define ATTR_BGPROPERTIES ((emptyNamespace << 16) | 121)
#define ATTR_BORDER ((emptyNamespace << 16) | 122)
#define ATTR_BORDERCOLOR ((emptyNamespace << 16) | 123)
#define ATTR_CELLPADDING ((emptyNamespace << 16) | 124)
#define ATTR_CELLSPACING ((emptyNamespace << 16) | 125)
#define ATTR_CHAR ((emptyNamespace << 16) | 126)
#define ATTR_CHALLENGE ((emptyNamespace << 16) | 127)
#define ATTR_CHAROFF ((emptyNamespace << 16) | 128)
#define ATTR_CHARSET ((emptyNamespace << 16) | 129)
#define ATTR_CHECKED ((emptyNamespace << 16) | 130)
#define ATTR_CLEAR ((emptyNamespace << 16) | 131)
#define ATTR_CODETYPE ((emptyNamespace << 16) | 132)
#define ATTR_COLOR ((emptyNamespace << 16) | 133)
#define ATTR_COLS ((emptyNamespace << 16) | 134)
#define ATTR_COLSPAN ((emptyNamespace << 16) | 135)
#define ATTR_COMPACT ((emptyNamespace << 16) | 136)
#define ATTR_CONTENTEDITABLE ((emptyNamespace << 16) | 137)
#define ATTR_CONTROLS ((emptyNamespace << 16) | 138)
#define ATTR_COORDS ((emptyNamespace << 16) | 139)
#define ATTR_DECLARE ((emptyNamespace << 16) | 140)
#define ATTR_DEFER ((emptyNamespace << 16) | 141)
#define ATTR_DIRECTION ((emptyNamespace << 16) | 142)
#define ATTR_DISABLED ((emptyNamespace << 16) | 143)
#define ATTR_ENCTYPE ((emptyNamespace << 16) | 144)
#define ATTR_FACE ((emptyNamespace << 16) | 145)
#define ATTR_FRAMEBORDER ((emptyNamespace << 16) | 146)
#define ATTR_HEIGHT ((emptyNamespace << 16) | 147)
#define ATTR_HIDDEN ((emptyNamespace << 16) | 148)
#define ATTR_HREFLANG ((emptyNamespace << 16) | 149)
#define ATTR_HSPACE ((emptyNamespace << 16) | 150)
#define ATTR_HTTP_EQUIV ((emptyNamespace << 16) | 151)
#define ATTR_ISMAP ((emptyNamespace << 16) | 152)
#define ATTR_XML_LANG ((xmlNamespace << 16) | 153)
#define ATTR_LANG ((emptyNamespace << 16) | 153)
#define ATTR_LANGUAGE ((emptyNamespace << 16) | 154)
#define ATTR_LEFT ((emptyNamespace << 16) | 155)
#define ATTR_LEFTMARGIN ((emptyNamespace << 16) | 156)
#define ATTR_LOOP ((emptyNamespace << 16) | 157)
#define ATTR_MARGINHEIGHT ((emptyNamespace << 16) | 158)
#define ATTR_MARGINWIDTH ((emptyNamespace << 16) | 159)
#define ATTR_MAXLENGTH ((emptyNamespace << 16) | 160)
#define ATTR_MEDIA ((emptyNamespace << 16) | 161)
#define ATTR_METHOD ((emptyNamespace << 16) | 162)
#define ATTR_MULTIPLE ((emptyNamespace << 16) | 163)
#define ATTR_NOHREF ((emptyNamespace << 16) | 164)
#define ATTR_NORESIZE ((emptyNamespace << 16) | 165)
#define ATTR_NOSAVE ((emptyNamespace << 16) | 166)
#define ATTR_NOSHADE ((emptyNamespace << 16) | 167)
#define ATTR_NOWRAP ((emptyNamespace << 16) | 168)
#define ATTR_ONABORT ((emptyNamespace << 16) | 169)
#define ATTR_ONERROR ((emptyNamespace << 16) | 170)
#define ATTR_ONRESIZE ((emptyNamespace << 16) | 171)
#define ATTR_OVERSRC ((emptyNamespace << 16) | 172)
#define ATTR_PAGEX ((emptyNamespace << 16) | 173)
#define ATTR_PAGEY ((emptyNamespace << 16) | 174)
#define ATTR_PLAIN ((emptyNamespace << 16) | 175)
#define ATTR_PLUGINPAGE ((emptyNamespace << 16) | 176)
#define ATTR_PLUGINSPAGE ((emptyNamespace << 16) | 177)
#define ATTR_PLUGINURL ((emptyNamespace << 16) | 178)
#define ATTR_POSTER ((emptyNamespace << 16) | 179)
#define ATTR_READONLY ((emptyNamespace << 16) | 180)
#define ATTR_REL ((emptyNamespace << 16) | 181)
#define ATTR_REV ((emptyNamespace << 16) | 182)
#define ATTR_ROWS ((emptyNamespace << 16) | 183)
#define ATTR_ROWSPAN ((emptyNamespace << 16) | 184)
#define ATTR_RULES ((emptyNamespace << 16) | 185)
#define ATTR_SCOPE ((emptyNamespace << 16) | 186)
#define ATTR_SCROLLAMOUNT ((emptyNamespace << 16) | 187)
#define ATTR_SCROLLDELAY ((emptyNamespace << 16) | 188)
#define ATTR_SCROLLING ((emptyNamespace << 16) | 189)
#define ATTR_SELECTED ((emptyNamespace << 16) | 190)
#define ATTR_SHAPE ((emptyNamespace << 16) | 191)
#define ATTR_SIZE ((emptyNamespace << 16) | 192)
#define ATTR_START ((emptyNamespace << 16) | 193)
#define ATTR_TABINDEX ((emptyNamespace << 16) | 194)
#define ATTR_TARGET ((emptyNamespace << 16) | 195)
#define ATTR_TEXT ((emptyNamespace << 16) | 196)
#define ATTR_TOP ((emptyNamespace << 16) | 197)
#define ATTR_TOPMARGIN ((emptyNamespace << 16) | 198)
#define ATTR_TRUESPEED ((emptyNamespace << 16) | 199)
#define ATTR_XLINK_TYPE ((xlinkNamespace << 16) | 200)
#define ATTR_TYPE ((emptyNamespace << 16) | 200)
#define ATTR_UNKNOWN ((emptyNamespace << 16) | 201)
#define ATTR_VALIGN ((emptyNamespace << 16) | 202)
#define ATTR_VALUETYPE ((emptyNamespace << 16) | 203)
#define ATTR_VERSION ((emptyNamespace << 16) | 204)
#define ATTR_VISIBILITY ((emptyNamespace << 16) | 205)
#define ATTR_VLINK ((emptyNamespace << 16) | 206)
#define ATTR_VSPACE ((emptyNamespace << 16) | 207)
#define ATTR_WIDTH ((emptyNamespace << 16) | 208)
#define ATTR_WRAP ((emptyNamespace << 16) | 209)
#define ATTR_Z_INDEX ((emptyNamespace << 16) | 210)
#define ATTR_ACTION ((emptyNamespace << 16) | 211)
#define ATTR_ALT ((emptyNamespace << 16) | 212)
#define ATTR_ARCHIVE ((emptyNamespace << 16) | 213)
#define ATTR_BACKGROUND ((emptyNamespace << 16) | 214)
#define ATTR_CLASS ((emptyNamespace << 16) | 215)
#define ATTR_CLASSID ((emptyNamespace << 16) | 216)
#define ATTR_CODEBASE ((emptyNamespace << 16) | 217)
#define ATTR_CONTENT ((emptyNamespace << 16) | 218)
#define ATTR_DATA ((emptyNamespace << 16) | 219)
#define ATTR_DATETIME ((emptyNamespace << 16) | 220)
#define ATTR_FOR ((emptyNamespace << 16) | 221)
#define ATTR_HEADERS ((emptyNamespace << 16) | 222)
#define ATTR_XLINK_HREF ((xlinkNamespace << 16) | 223)
#define ATTR_HREF ((emptyNamespace << 16) | 223)
#define ATTR_ID ((emptyNamespace << 16) | 224)
#define ATTR_LONGDESC ((emptyNamespace << 16) | 225)
#define ATTR_NAME ((emptyNamespace << 16) | 226)
#define ATTR_ONBLUR ((emptyNamespace << 16) | 227)
#define ATTR_ONCHANGE ((emptyNamespace << 16) | 228)
#define ATTR_ONCLICK ((emptyNamespace << 16) | 229)
#define ATTR_ONDBLCLICK ((emptyNamespace << 16) | 230)
#define ATTR_ONFOCUS ((emptyNamespace << 16) | 231)
#define ATTR_ONKEYDOWN ((emptyNamespace << 16) | 232)
#define ATTR_ONKEYPRESS ((emptyNamespace << 16) | 233)
#define ATTR_ONKEYUP ((emptyNamespace << 16) | 234)
#define ATTR_ONLOAD ((emptyNamespace << 16) | 235)
#define ATTR_ONMOUSEDOWN ((emptyNamespace << 16) | 236)
#define ATTR_ONMOUSEMOVE ((emptyNamespace << 16) | 237)
#define ATTR_ONMOUSEOUT ((emptyNamespace << 16) | 238)
#define ATTR_ONMOUSEOVER ((emptyNamespace << 16) | 239)
#define ATTR_ONMOUSEUP ((emptyNamespace << 16) | 240)
#define ATTR_ONRESET ((emptyNamespace << 16) | 241)
#define ATTR_ONSELECT ((emptyNamespace << 16) | 242)
#define ATTR_ONSCROLL ((emptyNamespace << 16) | 243)
#define ATTR_ONSUBMIT ((emptyNamespace << 16) | 244)
#define ATTR_ONUNLOAD ((emptyNamespace << 16) | 245)
#define ATTR_PROFILE ((emptyNamespace << 16) | 246)
#define ATTR_PROMPT ((emptyNamespace << 16) | 247)
#define ATTR_SCHEME ((emptyNamespace << 16) | 248)
#define ATTR_SRC ((emptyNamespace << 16) | 249)
#define ATTR_STANDBY ((emptyNamespace << 16) | 250)
#define ATTR_SUMMARY ((emptyNamespace << 16) | 251)
#define ATTR_USEMAP ((emptyNamespace << 16) | 252)
#define ATTR_VALUE ((emptyNamespace << 16) | 253)
#define ID_ALTGLYPH 254
#define ID_ALTGLYPHDEF 255
#define ID_ALTGLYPHITEM 256
#define ID_ANIMATE 257
#define ATTR_ANIMATE ((emptyNamespace << 16) | 257)
#define ID_ANIMATECOLOR 258
#define ID_ANIMATEMOTION 259
#define ID_ANIMATETRANSFORM 260
#define ID_SET 261
#define ID_CIRCLE 262
#define ID_CLIPPATH 263
#define ID_COLOR_PROFILE 264
#define ID_CURSOR 265
#define ATTR_CURSOR ((emptyNamespace << 16) | 265)
#define ID_DEFINITION_SRC 266
#define ID_DEFS 267
#define ID_DESC 268
#define ID_ELLIPSE 269
#define ID_FEBLEND 270
#define ID_FECOLORMATRIX 271
#define ATTR_FECOLORMATRIX ((emptyNamespace << 16) | 271)
#define ID_FECOMPONENTTRANSFER 272
#define ID_FECOMPOSITE 273
#define ATTR_FECOMPOSITE ((emptyNamespace << 16) | 273)
#define ID_FECONVOLVEMATRIX 274
#define ID_FEDIFFUSELIGHTING 275
#define ID_FEDISPLACEMENTMAP 276
#define ID_FEDISTANTLIGHT 277
#define ID_FEFLOOD 278
#define ID_FEFUNCA 279
#define ID_FEFUNCB 280
#define ID_FEFUNCG 281
#define ID_FEFUNCR 282
#define ID_FEGAUSSIANBLUR 283
#define ATTR_FEGAUSSIANBLUR ((emptyNamespace << 16) | 283)
#define ID_FEIMAGE 284
#define ID_FEMERGE 285
#define ID_FEMERGENODE 286
#define ID_FEMORPHOLOGY 287
#define ATTR_FEMORPHOLOGY ((emptyNamespace << 16) | 287)
#define ID_FEOFFSET 288
#define ID_FEPOINTLIGHT 289
#define ID_FESPECULARLIGHTING 290
#define ID_FESPOTLIGHT 291
#define ID_FETILE 292
#define ATTR_FETILE ((emptyNamespace << 16) | 292)
#define ID_FETURBULENCE 293
#define ID_FILTER 294
#define ATTR_FILTER ((emptyNamespace << 16) | 294)
#define ID_FONT_FACE 295
#define ID_FONT_FACE_FORMAT 296
#define ID_FONT_FACE_NAME 297
#define ID_FONT_FACE_SRC 298
#define ID_FONT_FACE_URI 299
#define ID_FOREIGNOBJECT 300
#define ID_G 301
#define ID_GLYPH 302
#define ID_GLYPHREF 303
#define ATTR_GLYPHREF ((emptyNamespace << 16) | 303)
#define ID_HKERN 304
#define ID_LINE 305
#define ID_LINEARGRADIENT 306
#define ID_MARKER 307
#define ID_MASK 308
#define ATTR_MASK ((emptyNamespace << 16) | 308)
#define ID_METADATA 309
#define ID_MISSING_GLYPH 310
#define ID_MPATH 311
#define ID_PATH 312
#define ATTR_PATH ((emptyNamespace << 16) | 312)
#define ID_PATTERN 313
#define ID_POLYGON 314
#define ID_POLYLINE 315
#define ID_RADIALGRADIENT 316
#define ID_RECT 317
#define ID_STOP 318
#define ID_SVG 319
#define ID_SWITCH 320
#define ID_SYMBOL 321
#define ID_TEXTPATH 322
#define ID_TREF 323
#define ID_TSPAN 324
#define ID_USE 325
#define ID_VIEW 326
#define ID_VKERN 327
#define ATTR_ACCENT_HEIGHT ((emptyNamespace << 16) | 328)
#define ATTR_ACCUMULATE ((emptyNamespace << 16) | 329)
#define ATTR_ADDITIVE ((emptyNamespace << 16) | 330)
#define ATTR_ALIGNMENT_BASELINE ((emptyNamespace << 16) | 331)
#define ATTR_ALPHABETIC ((emptyNamespace << 16) | 332)
#define ATTR_AMPLITUDE ((emptyNamespace << 16) | 333)
#define ATTR_ARABIC_FORM ((emptyNamespace << 16) | 334)
#define ATTR_ASCENT ((emptyNamespace << 16) | 335)
#define ATTR_ATTRIBUTENAME ((emptyNamespace << 16) | 336)
#define ATTR_ATTRIBUTETYPE ((emptyNamespace << 16) | 337)
#define ATTR_AZIMUTH ((emptyNamespace << 16) | 338)
#define ATTR_BASEFREQUENCY ((emptyNamespace << 16) | 339)
#define ATTR_BASELINE_SHIFT ((emptyNamespace << 16) | 340)
#define ATTR_BASEPROFILE ((emptyNamespace << 16) | 341)
#define ATTR_BBOX ((emptyNamespace << 16) | 342)
#define ATTR_BEGIN ((emptyNamespace << 16) | 343)
#define ATTR_BIAS ((emptyNamespace << 16) | 344)
#define ATTR_BY ((emptyNamespace << 16) | 345)
#define ATTR_CALCMODE ((emptyNamespace << 16) | 346)
#define ATTR_CAP_HEIGHT ((emptyNamespace << 16) | 347)
#define ATTR_CLIP ((emptyNamespace << 16) | 348)
#define ATTR_CLIP_PATH ((emptyNamespace << 16) | 349)
#define ATTR_CLIP_RULE ((emptyNamespace << 16) | 350)
#define ATTR_CLIPPATHUNITS ((emptyNamespace << 16) | 351)
#define ATTR_COLOR_INTERPOLATION ((emptyNamespace << 16) | 352)
#define ATTR_COLOR_INTERPOLATION_FILTERS ((emptyNamespace << 16) | 353)
#define ATTR_COLOR_PROFILE ((emptyNamespace << 16) | 354)
#define ATTR_COLOR_RENDERING ((emptyNamespace << 16) | 355)
#define ATTR_CONTENTSCRIPTTYPE ((emptyNamespace << 16) | 356)
#define ATTR_CONTENTSTYLETYPE ((emptyNamespace << 16) | 357)
#define ATTR_CX ((emptyNamespace << 16) | 358)
#define ATTR_CY ((emptyNamespace << 16) | 359)
#define ATTR_D ((emptyNamespace << 16) | 360)
#define ATTR_DESCENT ((emptyNamespace << 16) | 361)
#define ATTR_DIFFUSECONSTANT ((emptyNamespace << 16) | 362)
#define ATTR_DISPLAY ((emptyNamespace << 16) | 363)
#define ATTR_DIVISOR ((emptyNamespace << 16) | 364)
#define ATTR_DOMINANT_BASELINE ((emptyNamespace << 16) | 365)
#define ATTR_DUR ((emptyNamespace << 16) | 366)
#define ATTR_DX ((emptyNamespace << 16) | 367)
#define ATTR_DY ((emptyNamespace << 16) | 368)
#define ATTR_EDGEMODE ((emptyNamespace << 16) | 369)
#define ATTR_ELEVATION ((emptyNamespace << 16) | 370)
#define ATTR_ENABLE_BACKGROUND ((emptyNamespace << 16) | 371)
#define ATTR_END ((emptyNamespace << 16) | 372)
#define ATTR_EXPONENT ((emptyNamespace << 16) | 373)
#define ATTR_EXTERNALRESOURCESREQUIRED ((emptyNamespace << 16) | 374)
#define ATTR_FILL ((emptyNamespace << 16) | 375)
#define ATTR_FILL_OPACITY ((emptyNamespace << 16) | 376)
#define ATTR_FILL_RULE ((emptyNamespace << 16) | 377)
#define ATTR_FILTERRES ((emptyNamespace << 16) | 378)
#define ATTR_FILTERUNITS ((emptyNamespace << 16) | 379)
#define ATTR_FLOOD_COLOR ((emptyNamespace << 16) | 380)
#define ATTR_FLOOD_OPACITY ((emptyNamespace << 16) | 381)
#define ATTR_FONT_FAMILY ((emptyNamespace << 16) | 382)
#define ATTR_FONT_SIZE ((emptyNamespace << 16) | 383)
#define ATTR_FONT_SIZE_ADJUST ((emptyNamespace << 16) | 384)
#define ATTR_FONT_STRETCH ((emptyNamespace << 16) | 385)
#define ATTR_FONT_STYLE ((emptyNamespace << 16) | 386)
#define ATTR_FONT_VARIANT ((emptyNamespace << 16) | 387)
#define ATTR_FONT_WEIGHT ((emptyNamespace << 16) | 388)
#define ATTR_FORMAT ((emptyNamespace << 16) | 389)
#define ATTR_FROM ((emptyNamespace << 16) | 390)
#define ATTR_FX ((emptyNamespace << 16) | 391)
#define ATTR_FY ((emptyNamespace << 16) | 392)
#define ATTR_G1 ((emptyNamespace << 16) | 393)
#define ATTR_G2 ((emptyNamespace << 16) | 394)
#define ATTR_GLYPH_NAME ((emptyNamespace << 16) | 395)
#define ATTR_GLYPH_ORIENTATION_HORIZONTAL ((emptyNamespace << 16) | 396)
#define ATTR_GLYPH_ORIENTATION_VERTICAL ((emptyNamespace << 16) | 397)
#define ATTR_GRADIENTTRANSFORM ((emptyNamespace << 16) | 398)
#define ATTR_GRADIENTUNITS ((emptyNamespace << 16) | 399)
#define ATTR_HANGING ((emptyNamespace << 16) | 400)
#define ATTR_HORIZ_ADV_X ((emptyNamespace << 16) | 401)
#define ATTR_HORIZ_ORIGIN_X ((emptyNamespace << 16) | 402)
#define ATTR_HORIZ_ORIGIN_Y ((emptyNamespace << 16) | 403)
#define ATTR_IDEOGRAPHIC ((emptyNamespace << 16) | 404)
#define ATTR_IMAGE_RENDERING ((emptyNamespace << 16) | 405)
#define ATTR_IN ((emptyNamespace << 16) | 406)
#define ATTR_IN2 ((emptyNamespace << 16) | 407)
#define ATTR_INTERCEPT ((emptyNamespace << 16) | 408)
#define ATTR_K ((emptyNamespace << 16) | 409)
#define ATTR_K1 ((emptyNamespace << 16) | 410)
#define ATTR_K2 ((emptyNamespace << 16) | 411)
#define ATTR_K3 ((emptyNamespace << 16) | 412)
#define ATTR_K4 ((emptyNamespace << 16) | 413)
#define ATTR_KERNELMATRIX ((emptyNamespace << 16) | 414)
#define ATTR_KERNELUNITLENGTH ((emptyNamespace << 16) | 415)
#define ATTR_KERNING ((emptyNamespace << 16) | 416)
#define ATTR_KEYPOINTS ((emptyNamespace << 16) | 417)
#define ATTR_KEYSPLINES ((emptyNamespace << 16) | 418)
#define ATTR_KEYTIMES ((emptyNamespace << 16) | 419)
#define ATTR_LENGTHADJUST ((emptyNamespace << 16) | 420)
#define ATTR_LETTER_SPACING ((emptyNamespace << 16) | 421)
#define ATTR_LIGHTING_COLOR ((emptyNamespace << 16) | 422)
#define ATTR_LIMITINGCONEANGLE ((emptyNamespace << 16) | 423)
#define ATTR_LOCAL ((emptyNamespace << 16) | 424)
#define ATTR_MARKER_END ((emptyNamespace << 16) | 425)
#define ATTR_MARKER_MID ((emptyNamespace << 16) | 426)
#define ATTR_MARKER_START ((emptyNamespace << 16) | 427)
#define ATTR_MARKERHEIGHT ((emptyNamespace << 16) | 428)
#define ATTR_MARKERUNITS ((emptyNamespace << 16) | 429)
#define ATTR_MARKERWIDTH ((emptyNamespace << 16) | 430)
#define ATTR_MASKCONTENTUNITS ((emptyNamespace << 16) | 431)
#define ATTR_MASKUNITS ((emptyNamespace << 16) | 432)
#define ATTR_MATHEMATICAL ((emptyNamespace << 16) | 433)
#define ATTR_MAX ((emptyNamespace << 16) | 434)
#define ATTR_MIN ((emptyNamespace << 16) | 435)
#define ATTR_MODE ((emptyNamespace << 16) | 436)
#define ATTR_NUMOCTAVES ((emptyNamespace << 16) | 437)
#define ATTR_OFFSET ((emptyNamespace << 16) | 438)
#define ATTR_ONACTIVATE ((emptyNamespace << 16) | 439)
#define ATTR_ONBEGIN ((emptyNamespace << 16) | 440)
#define ATTR_ONEND ((emptyNamespace << 16) | 441)
#define ATTR_ONFOCUSIN ((emptyNamespace << 16) | 442)
#define ATTR_ONFOCUSOUT ((emptyNamespace << 16) | 443)
#define ATTR_ONREPEAT ((emptyNamespace << 16) | 444)
#define ATTR_ONZOOM ((emptyNamespace << 16) | 445)
#define ATTR_OPACITY ((emptyNamespace << 16) | 446)
#define ATTR_OPERATOR ((emptyNamespace << 16) | 447)
#define ATTR_ORDER ((emptyNamespace << 16) | 448)
#define ATTR_ORIENT ((emptyNamespace << 16) | 449)
#define ATTR_ORIENTATION ((emptyNamespace << 16) | 450)
#define ATTR_ORIGIN ((emptyNamespace << 16) | 451)
#define ATTR_OVERFLOW ((emptyNamespace << 16) | 452)
#define ATTR_OVERLINE_POSITION ((emptyNamespace << 16) | 453)
#define ATTR_OVERLINE_THICKNESS ((emptyNamespace << 16) | 454)
#define ATTR_PANOSE_1 ((emptyNamespace << 16) | 455)
#define ATTR_PATHLENGTH ((emptyNamespace << 16) | 456)
#define ATTR_PATTERNCONTENTUNITS ((emptyNamespace << 16) | 457)
#define ATTR_PATTERNTRANSFORM ((emptyNamespace << 16) | 458)
#define ATTR_PATTERNUNITS ((emptyNamespace << 16) | 459)
#define ATTR_POINTER_EVENTS ((emptyNamespace << 16) | 460)
#define ATTR_POINTS ((emptyNamespace << 16) | 461)
#define ATTR_POINTSATX ((emptyNamespace << 16) | 462)
#define ATTR_POINTSATY ((emptyNamespace << 16) | 463)
#define ATTR_POINTSATZ ((emptyNamespace << 16) | 464)
#define ATTR_PRESERVEALPHA ((emptyNamespace << 16) | 465)
#define ATTR_PRESERVEASPECTRATIO ((emptyNamespace << 16) | 466)
#define ATTR_PRIMITIVEUNITS ((emptyNamespace << 16) | 467)
#define ATTR_R ((emptyNamespace << 16) | 468)
#define ATTR_RADIUS ((emptyNamespace << 16) | 469)
#define ATTR_REFX ((emptyNamespace << 16) | 470)
#define ATTR_REFY ((emptyNamespace << 16) | 471)
#define ATTR_RENDERING_INTENT ((emptyNamespace << 16) | 472)
#define ATTR_REPEATCOUNT ((emptyNamespace << 16) | 473)
#define ATTR_REPEATDUR ((emptyNamespace << 16) | 474)
#define ATTR_REQUIREDEXTENSIONS ((emptyNamespace << 16) | 475)
#define ATTR_REQUIREDFEATURES ((emptyNamespace << 16) | 476)
#define ATTR_RESTART ((emptyNamespace << 16) | 477)
#define ATTR_RESULT ((emptyNamespace << 16) | 478)
#define ATTR_ROTATE ((emptyNamespace << 16) | 479)
#define ATTR_RX ((emptyNamespace << 16) | 480)
#define ATTR_RY ((emptyNamespace << 16) | 481)
#define ATTR_SCALE ((emptyNamespace << 16) | 482)
#define ATTR_SEED ((emptyNamespace << 16) | 483)
#define ATTR_SHAPE_RENDERING ((emptyNamespace << 16) | 484)
#define ATTR_SLOPE ((emptyNamespace << 16) | 485)
#define ATTR_SPACING ((emptyNamespace << 16) | 486)
#define ATTR_SPECULARCONSTANT ((emptyNamespace << 16) | 487)
#define ATTR_SPECULAREXPONENT ((emptyNamespace << 16) | 488)
#define ATTR_SPREADMETHOD ((emptyNamespace << 16) | 489)
#define ATTR_STARTOFFSET ((emptyNamespace << 16) | 490)
#define ATTR_STDDEVIATION ((emptyNamespace << 16) | 491)
#define ATTR_STEMH ((emptyNamespace << 16) | 492)
#define ATTR_STEMV ((emptyNamespace << 16) | 493)
#define ATTR_STITCHTILES ((emptyNamespace << 16) | 494)
#define ATTR_STOP_COLOR ((emptyNamespace << 16) | 495)
#define ATTR_STOP_OPACITY ((emptyNamespace << 16) | 496)
#define ATTR_STRIKETHROUGH_POSITION ((emptyNamespace << 16) | 497)
#define ATTR_STRIKETHROUGH_THICKNESS ((emptyNamespace << 16) | 498)
#define ATTR_STROKE ((emptyNamespace << 16) | 499)
#define ATTR_STROKE_DASHARRAY ((emptyNamespace << 16) | 500)
#define ATTR_STROKE_DASHOFFSET ((emptyNamespace << 16) | 501)
#define ATTR_STROKE_LINECAP ((emptyNamespace << 16) | 502)
#define ATTR_STROKE_LINEJOIN ((emptyNamespace << 16) | 503)
#define ATTR_STROKE_MITERLIMIT ((emptyNamespace << 16) | 504)
#define ATTR_STROKE_OPACITY ((emptyNamespace << 16) | 505)
#define ATTR_STROKE_WIDTH ((emptyNamespace << 16) | 506)
#define ATTR_SURFACESCALE ((emptyNamespace << 16) | 507)
#define ATTR_SYSTEMLANGUAGE ((emptyNamespace << 16) | 508)
#define ATTR_TABLEVALUES ((emptyNamespace << 16) | 509)
#define ATTR_TARGETX ((emptyNamespace << 16) | 510)
#define ATTR_TARGETY ((emptyNamespace << 16) | 511)
#define ATTR_TEXT_ANCHOR ((emptyNamespace << 16) | 512)
#define ATTR_TEXT_DECORATION ((emptyNamespace << 16) | 513)
#define ATTR_TEXT_RENDERING ((emptyNamespace << 16) | 514)
#define ATTR_TEXTLENGTH ((emptyNamespace << 16) | 515)
#define ATTR_TO ((emptyNamespace << 16) | 516)
#define ATTR_TRANSFORM ((emptyNamespace << 16) | 517)
#define ATTR_U1 ((emptyNamespace << 16) | 518)
#define ATTR_U2 ((emptyNamespace << 16) | 519)
#define ATTR_UNDERLINE_POSITION ((emptyNamespace << 16) | 520)
#define ATTR_UNDERLINE_THICKNESS ((emptyNamespace << 16) | 521)
#define ATTR_UNICODE ((emptyNamespace << 16) | 522)
#define ATTR_UNICODE_BIDI ((emptyNamespace << 16) | 523)
#define ATTR_UNICODE_RANGE ((emptyNamespace << 16) | 524)
#define ATTR_UNITS_PER_EM ((emptyNamespace << 16) | 525)
#define ATTR_V_ALPHABETIC ((emptyNamespace << 16) | 526)
#define ATTR_V_HANGING ((emptyNamespace << 16) | 527)
#define ATTR_V_IDEOGRAPHIC ((emptyNamespace << 16) | 528)
#define ATTR_V_MATHEMATICAL ((emptyNamespace << 16) | 529)
#define ATTR_VALUES ((emptyNamespace << 16) | 530)
#define ATTR_VERT_ADV_Y ((emptyNamespace << 16) | 531)
#define ATTR_VERT_ORIGIN_X ((emptyNamespace << 16) | 532)
#define ATTR_VERT_ORIGIN_Y ((emptyNamespace << 16) | 533)
#define ATTR_VIEWBOX ((emptyNamespace << 16) | 534)
#define ATTR_VIEWTARGET ((emptyNamespace << 16) | 535)
#define ATTR_WIDTHS ((emptyNamespace << 16) | 536)
#define ATTR_WORD_SPACING ((emptyNamespace << 16) | 537)
#define ATTR_WRITING_MODE ((emptyNamespace << 16) | 538)
#define ATTR_X ((emptyNamespace << 16) | 539)
#define ATTR_X_HEIGHT ((emptyNamespace << 16) | 540)
#define ATTR_X1 ((emptyNamespace << 16) | 541)
#define ATTR_X2 ((emptyNamespace << 16) | 542)
#define ATTR_XCHANNELSELECTOR ((emptyNamespace << 16) | 543)
#define ATTR_Y ((emptyNamespace << 16) | 544)
#define ATTR_Y1 ((emptyNamespace << 16) | 545)
#define ATTR_Y2 ((emptyNamespace << 16) | 546)
#define ATTR_YCHANNELSELECTOR ((emptyNamespace << 16) | 547)
#define ATTR_Z ((emptyNamespace << 16) | 548)
#define ATTR_ZOOMANDPAN ((emptyNamespace << 16) | 549)
#define ATTR_XLINK_ACTUATE ((xlinkNamespace << 16) | 550)
#define ATTR_XLINK_ARCROLE ((xlinkNamespace << 16) | 551)
#define ATTR_XLINK_ROLE ((xlinkNamespace << 16) | 552)
#define ATTR_XLINK_SHOW ((xlinkNamespace << 16) | 553)
#define ATTR_XML_SPACE ((xmlNamespace << 16) | 554)
#define ID_LAST_TAG 110
#define ID_CLOSE_TAG 16384
#define ATTR_LAST_ATTR 253
#define ATTR_LAST_CI_ATTR 210

#define caseSensitiveAttr(id) (((localNamePart(id)) > ATTR_LAST_CI_ATTR || (id) == ATTR_ABBR || (id) == ATTR_CITE || (id) == ATTR_CODE || (id) == ATTR_LABEL || (id) == ATTR_OBJECT || (id) == ATTR_TITLE)) 

#endif