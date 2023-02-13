/*
 * Copyright (C) 2004 Apple Inc.  All rights reserved.
 * Copyright (C) 2006 Samuel Weinig <sam.weinig@gmail.com>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE INC. OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 */

#import <WebKitLegacy/DOMCore.h>
#import <WebKitLegacy/DOMDocument.h>
#import <WebKitLegacy/DOMElement.h>
#import <WebKitLegacy/DOMObject.h>
#import <WebKitLegacy/DOMStylesheets.h>

#import <WebKitLegacy/DOMCSSCharsetRule.h>
#import <WebKitLegacy/DOMCSSFontFaceRule.h>
#import <WebKitLegacy/DOMCSSImportRule.h>
#import <WebKitLegacy/DOMCSSMediaRule.h>
#import <WebKitLegacy/DOMCSSPageRule.h>
#import <WebKitLegacy/DOMCSSPrimitiveValue.h>
#import <WebKitLegacy/DOMCSSRule.h>
#import <WebKitLegacy/DOMCSSRuleList.h>
#import <WebKitLegacy/DOMCSSStyleDeclaration.h>
#import <WebKitLegacy/DOMCSSStyleRule.h>
#import <WebKitLegacy/DOMCSSStyleSheet.h>
#import <WebKitLegacy/DOMCSSUnknownRule.h>
#import <WebKitLegacy/DOMCSSValue.h>
#import <WebKitLegacy/DOMCSSValueList.h>
#import <WebKitLegacy/DOMCounter.h>
#import <WebKitLegacy/DOMRGBColor.h>
#import <WebKitLegacy/DOMRect.h>

@interface DOMCSSStyleDeclaration (DOMCSS2Properties)
@property (nonatomic, copy) NSString *azimuth WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *background WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *backgroundAttachment WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *backgroundColor WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *backgroundImage WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *backgroundPosition WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *backgroundRepeat WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *border WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderCollapse WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderColor WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderSpacing WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderStyle WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderTop WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderRight WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderBottom WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderLeft WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderTopColor WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderRightColor WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderBottomColor WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderLeftColor WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderTopStyle WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderRightStyle WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderBottomStyle WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderLeftStyle WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderTopWidth WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderRightWidth WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderBottomWidth WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderLeftWidth WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *borderWidth WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *bottom WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *captionSide WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *clear WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *clip WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *color WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *content WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *counterIncrement WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *counterReset WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *cue WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *cueAfter WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *cueBefore WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *cursor WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *direction WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *display WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *elevation WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *emptyCells WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *cssFloat WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *font WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *fontFamily WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *fontSize WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *fontSizeAdjust WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *fontStretch WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *fontStyle WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *fontVariant WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *fontWeight WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *height WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *left WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *letterSpacing WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *lineHeight WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *listStyle WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *listStyleImage WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *listStylePosition WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *listStyleType WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *margin WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *marginTop WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *marginRight WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *marginBottom WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *marginLeft WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *markerOffset WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *marks WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *maxHeight WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *maxWidth WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *minHeight WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *minWidth WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *orphans WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *outline WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *outlineColor WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *outlineStyle WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *outlineWidth WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *overflow WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *padding WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *paddingTop WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *paddingRight WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *paddingBottom WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *paddingLeft WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *page WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *pageBreakAfter WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *pageBreakBefore WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *pageBreakInside WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *pause WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *pauseAfter WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *pauseBefore WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *pitch WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *pitchRange WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *playDuring WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *position WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *quotes WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *richness WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *right WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *size WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *speak WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *speakHeader WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *speakNumeral WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *speakPunctuation WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *speechRate WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *stress WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *tableLayout WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *textAlign WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *textDecoration WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *textIndent WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *textShadow WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *textTransform WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *top WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *unicodeBidi WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *verticalAlign WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *visibility WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *voiceFamily WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *volume WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *whiteSpace WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *widows WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *width WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *wordSpacing WEBKIT_AVAILABLE_MAC(10_4);
@property (nonatomic, copy) NSString *zIndex WEBKIT_AVAILABLE_MAC(10_4);
@end
