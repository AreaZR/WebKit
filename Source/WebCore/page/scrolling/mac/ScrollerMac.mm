/*
 * Copyright (C) 2019 Apple Inc. All rights reserved.
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
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "config.h"
#import "ScrollerMac.h"

#if PLATFORM(MAC)

#import "ScrollerPairMac.h"
#import <QuartzCore/CALayer.h>
#import <WebCore/FloatPoint.h>
#import <WebCore/IntRect.h>
#import <WebCore/NSScrollerImpDetails.h>
#import <WebCore/PlatformWheelEvent.h>
#import <pal/spi/mac/NSScrollerImpSPI.h>
#import <wtf/BlockObjCExceptions.h>

enum class FeatureToAnimate {
    KnobAlpha,
    TrackAlpha,
    UIStateTransition,
    ExpansionTransition
};

@interface WebScrollbarPartAnimationMac : NSAnimation {
    WebCore::ScrollerMac* _scroller;
    FeatureToAnimate _featureToAnimate;
    CGFloat _startValue;
    CGFloat _endValue;
}
- (instancetype)initWithScroller:(WebCore::ScrollerMac*)scroller featureToAnimate:(FeatureToAnimate)featureToAnimate animateFrom:(CGFloat)startValue animateTo:(CGFloat)endValue duration:(NSTimeInterval)duration NS_DESIGNATED_INITIALIZER;
@end

@implementation WebScrollbarPartAnimationMac

- (instancetype)initWithScroller:(WebCore::ScrollerMac*)scroller featureToAnimate:(FeatureToAnimate)featureToAnimate animateFrom:(CGFloat)startValue animateTo:(CGFloat)endValue duration:(NSTimeInterval)duration
{
    self = [super initWithDuration:duration animationCurve:NSAnimationEaseInOut];
    if (!self)
        return nil;

    _scroller = scroller;
    _featureToAnimate = featureToAnimate;
    _startValue = startValue;
    _endValue = endValue;

    self.animationBlockingMode = NSAnimationNonblocking;

    return self;
}

- (void)startAnimation
{
    ASSERT(_scroller);

    [super startAnimation];
}

- (void)setStartValue:(CGFloat)startValue
{
    _startValue = startValue;
}

- (void)setEndValue:(CGFloat)endValue
{
    _endValue = endValue;
}

- (void)setCurrentProgress:(NSAnimationProgress)progress
{
    super.currentProgress = progress;

    CGFloat currentValue;
    if (_startValue > _endValue)
        currentValue = 1 - progress;
    else
        currentValue = progress;

    switch (_featureToAnimate) {
    case FeatureToAnimate::KnobAlpha:
        _scroller->scrollerImp().knobAlpha = currentValue;
        break;
    case FeatureToAnimate::TrackAlpha:
        _scroller->scrollerImp().trackAlpha = currentValue;
        break;
    case FeatureToAnimate::UIStateTransition:
        _scroller->scrollerImp().uiStateTransitionProgress = currentValue;
        break;
    case FeatureToAnimate::ExpansionTransition:
        _scroller->scrollerImp().expansionTransitionProgress = currentValue;
        break;
    }
}

- (void)invalidate
{
    BEGIN_BLOCK_OBJC_EXCEPTIONS
    [self stopAnimation];
    END_BLOCK_OBJC_EXCEPTIONS
    _scroller = nullptr;
}

@end

@interface WebScrollerImpDelegateMac : NSObject<NSAnimationDelegate, NSScrollerImpDelegate> {
    WebCore::ScrollerMac* _scroller;

    RetainPtr<WebScrollbarPartAnimationMac> _knobAlphaAnimation;
    RetainPtr<WebScrollbarPartAnimationMac> _trackAlphaAnimation;
    RetainPtr<WebScrollbarPartAnimationMac> _uiStateTransitionAnimation;
    RetainPtr<WebScrollbarPartAnimationMac> _expansionTransitionAnimation;
}
- (instancetype)initWithScroller:(WebCore::ScrollerMac*)scroller NS_DESIGNATED_INITIALIZER;
- (void)cancelAnimations;
@end

@implementation WebScrollerImpDelegateMac

- (instancetype)initWithScroller:(WebCore::ScrollerMac*)scroller
{
    self = [super init];
    if (!self)
        return nil;

    _scroller = scroller;
    return self;
}

- (void)cancelAnimations
{
    BEGIN_BLOCK_OBJC_EXCEPTIONS
    [_knobAlphaAnimation stopAnimation];
    [_trackAlphaAnimation stopAnimation];
    [_uiStateTransitionAnimation stopAnimation];
    [_expansionTransitionAnimation stopAnimation];
    END_BLOCK_OBJC_EXCEPTIONS
}

- (NSRect)convertRectToBacking:(NSRect)aRect
{
    return aRect;
}

- (NSRect)convertRectFromBacking:(NSRect)aRect
{
    return aRect;
}

- (CALayer *)layer
{
    return nil;
}

- (NSPoint)mouseLocationInScrollerForScrollerImp:(NSScrollerImp *)scrollerImp
{
    if (!_scroller)
        return NSZeroPoint;

    ASSERT_UNUSED(scrollerImp, scrollerImp == _scroller->scrollerImp());

    return _scroller->convertFromContent(_scroller->pair().lastKnownMousePosition());
}

- (NSRect)convertRectToLayer:(NSRect)rect
{
    return rect;
}

- (BOOL)shouldUseLayerPerPartForScrollerImp:(NSScrollerImp *)scrollerImp
{
    UNUSED_PARAM(scrollerImp);

    return true;
}

#if HAVE(OS_DARK_MODE_SUPPORT)
- (NSAppearance *)effectiveAppearanceForScrollerImp:(NSScrollerImp *)scrollerImp
{
    UNUSED_PARAM(scrollerImp);

    if (!_scroller)
        ALLOW_DEPRECATED_DECLARATIONS_BEGIN
        return [NSAppearance currentAppearance];
        ALLOW_DEPRECATED_DECLARATIONS_END

    // The base system does not support dark Aqua, so we might get a null result.
    if (auto *appearance = [NSAppearance appearanceNamed:_scroller->pair().useDarkAppearance() ? NSAppearanceNameDarkAqua : NSAppearanceNameAqua])
        return appearance;
    ALLOW_DEPRECATED_DECLARATIONS_BEGIN
    return [NSAppearance currentAppearance];
    ALLOW_DEPRECATED_DECLARATIONS_END
}
#endif

- (void)setUpAlphaAnimation:(RetainPtr<WebScrollbarPartAnimationMac>&)scrollbarPartAnimation featureToAnimate:(FeatureToAnimate)featureToAnimate animateAlphaTo:(CGFloat)newAlpha duration:(NSTimeInterval)duration
{
    // If we are currently animating,  stop
    if (scrollbarPartAnimation) {
        [scrollbarPartAnimation stopAnimation];
        scrollbarPartAnimation = nil;
    }

    scrollbarPartAnimation = adoptNS([[WebScrollbarPartAnimationMac alloc] initWithScroller:_scroller
        featureToAnimate:featureToAnimate
        animateFrom:featureToAnimate == FeatureToAnimate::KnobAlpha ? _scroller->scrollerImp().knobAlpha : _scroller->scrollerImp().trackAlpha
        animateTo:newAlpha
        duration:duration]);
    [scrollbarPartAnimation startAnimation];
}

- (void)scrollerImp:(NSScrollerImp *)scrollerImp animateKnobAlphaTo:(CGFloat)newKnobAlpha duration:(NSTimeInterval)duration
{
    if (!_scroller)
        return;

    ASSERT_UNUSED(scrollerImp, scrollerImp == _scroller->scrollerImp());
    [self setUpAlphaAnimation:_knobAlphaAnimation featureToAnimate:FeatureToAnimate::KnobAlpha animateAlphaTo:newKnobAlpha duration:duration];
}

- (void)scrollerImp:(NSScrollerImp *)scrollerImp animateTrackAlphaTo:(CGFloat)newTrackAlpha duration:(NSTimeInterval)duration
{
    if (!_scroller)
        return;

    ASSERT_UNUSED(scrollerImp, scrollerImp == _scroller->scrollerImp());
    [self setUpAlphaAnimation:_trackAlphaAnimation featureToAnimate:FeatureToAnimate::TrackAlpha animateAlphaTo:newTrackAlpha duration:duration];
}

- (void)scrollerImp:(NSScrollerImp *)scrollerImp animateUIStateTransitionWithDuration:(NSTimeInterval)duration
{
    if (!_scroller)
        return;

    ASSERT(scrollerImp == _scroller->scrollerImp());

    // UIStateTransition always animates to 1. In case an animation is in progress this avoids a hard transition.
    scrollerImp.uiStateTransitionProgress = 1 - scrollerImp.uiStateTransitionProgress;

    if (!_uiStateTransitionAnimation) {
        _uiStateTransitionAnimation = adoptNS([[WebScrollbarPartAnimationMac alloc] initWithScroller:_scroller
            featureToAnimate:FeatureToAnimate::UIStateTransition
            animateFrom:scrollerImp.uiStateTransitionProgress
            animateTo:1.0
            duration:duration]);
    } else {
        // If we don't need to initialize the animation, just reset the values in case they have changed.
        [_uiStateTransitionAnimation setStartValue:scrollerImp.uiStateTransitionProgress];
        [_uiStateTransitionAnimation setEndValue:1.0];
        _uiStateTransitionAnimation.duration = duration;
    }
    [_uiStateTransitionAnimation startAnimation];
}

- (void)scrollerImp:(NSScrollerImp *)scrollerImp animateExpansionTransitionWithDuration:(NSTimeInterval)duration
{
    if (!_scroller)
        return;

    ASSERT(scrollerImp == _scroller->scrollerImp());

    // ExpansionTransition always animates to 1. In case an animation is in progress this avoids a hard transition.
    scrollerImp.expansionTransitionProgress = 1 - scrollerImp.expansionTransitionProgress;

    if (!_expansionTransitionAnimation) {
        _expansionTransitionAnimation = adoptNS([[WebScrollbarPartAnimationMac alloc] initWithScroller:_scroller
            featureToAnimate:FeatureToAnimate::ExpansionTransition
            animateFrom:scrollerImp.expansionTransitionProgress
            animateTo:1.0
            duration:duration]);
    } else {
        // If we don't need to initialize the animation, just reset the values in case they have changed.
        [_expansionTransitionAnimation setStartValue:scrollerImp.uiStateTransitionProgress];
        [_expansionTransitionAnimation setEndValue:1.0];
        _expansionTransitionAnimation.duration = duration;
    }
    [_expansionTransitionAnimation startAnimation];
}

- (void)scrollerImp:(NSScrollerImp *)scrollerImp overlayScrollerStateChangedTo:(NSOverlayScrollerState)newOverlayScrollerState
{
    UNUSED_PARAM(scrollerImp);
    UNUSED_PARAM(newOverlayScrollerState);
}

- (void)invalidate
{
    _scroller = nil;
    BEGIN_BLOCK_OBJC_EXCEPTIONS
    [_knobAlphaAnimation invalidate];
    [_trackAlphaAnimation invalidate];
    [_uiStateTransitionAnimation invalidate];
    [_expansionTransitionAnimation invalidate];
    END_BLOCK_OBJC_EXCEPTIONS
}

@end

namespace WebCore {

ScrollerMac::ScrollerMac(ScrollerPairMac& pair, Orientation orientation)
    : m_pair(pair)
    , m_orientation(orientation)
{
}

ScrollerMac::~ScrollerMac()
{
    [m_scrollerImpDelegate invalidate];
    [m_scrollerImp setDelegate:nil];
}

void ScrollerMac::attach()
{
    m_scrollerImpDelegate = adoptNS([[WebScrollerImpDelegateMac alloc] initWithScroller:this]);

    NSScrollerStyle newStyle = m_pair.scrollerImpPair().scrollerStyle;
    m_scrollerImp = [NSScrollerImp scrollerImpWithStyle:newStyle controlSize:NSControlSizeRegular horizontal:m_orientation == Orientation::Horizontal replacingScrollerImp:nil];
    m_scrollerImp.delegate = m_scrollerImpDelegate.get();
}

void ScrollerMac::setHostLayer(CALayer *layer)
{
    if (m_hostLayer == layer)
        return;

    m_hostLayer = layer;

    m_scrollerImp.layer = layer;

    if (m_orientation == Orientation::Vertical)
        m_pair.scrollerImpPair().verticalScrollerImp = layer ? m_scrollerImp.get() : nil;
    else
        m_pair.scrollerImpPair().horizontalScrollerImp = layer ?  m_scrollerImp.get() : nil;
}

void ScrollerMac::updateValues()
{
    auto values = m_pair.valuesForOrientation(m_orientation);

    BEGIN_BLOCK_OBJC_EXCEPTIONS

    m_scrollerImp.enabled = !!m_hostLayer;
    m_scrollerImp.boundsSize = NSSizeFromCGSize(m_hostLayer.bounds.size);
    m_scrollerImp.doubleValue = values.value;
    m_scrollerImp.presentationValue = values.value;
    m_scrollerImp.knobProportion = values.proportion;

    END_BLOCK_OBJC_EXCEPTIONS
}

WebCore::FloatPoint ScrollerMac::convertFromContent(const WebCore::FloatPoint& point) const
{
    return WebCore::FloatPoint { [m_hostLayer convertPoint:point fromLayer:m_hostLayer.superlayer] };
}

}

#endif
