//
//  ECScreenEdgeScrollController.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-01.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECScreenEdgeScrollController.h"

@implementation ECScreenEdgeScrollController{
    NSTimer* _timer;
    CGPoint _offest;
    CGRect _bounds;
    UIPanGestureRecognizer* _recognizer;
    CGPoint _location;
    CGRect _contentRect;
}

- (void)trackGestureRecognizer:(UIPanGestureRecognizer*)recognizer Bounds:(CGRect)bounds Location:(CGPoint)location {
    if (!_tracking) {
        _recognizer = recognizer;
        [_recognizer addTarget:self action:@selector(handlePanFrom:)];
        _bounds = bounds;
        _location = location;
        _offest = [self calculateOffestWithLocation:location];
        _tracking = YES;
        _contentRect = CGRectMake(0, 0, _scrollView.contentSize.width - _scrollView.frame.size.width, _scrollView.contentSize.height - _scrollView.frame.size.height);
        //_contentRect = CGRectInset(_contentRect, 20, 20);
        [self startTimer];
    }
}

- (void)startTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.015
                                              target:self
                                            selector:@selector(moveScrollView)
                                            userInfo:nil
                                             repeats:YES];
    [_timer setTolerance:0.01];
}

- (void)finishedTracking{
    [_recognizer removeTarget:self action:@selector(handlePanFrom:)];
    [_timer invalidate];
    _timer = nil;
    _tracking = NO;
}

- (CGPoint)calculateOffestWithLocation:(CGPoint)point{
    
    CGPoint center = CGPointMake(CGRectGetMidX(_bounds), CGRectGetMidY(_bounds));
    point.x -= center.x;
    point.y -= center.y;
    
    CGFloat radius = 5.0;
    CGFloat m = (CGFloat)sqrt((double)(point.x*point.x + point.y*point.y));
    
    CGFloat x = (CGFloat)(point.x * radius)/m;
    CGFloat y = (CGFloat)(point.y * radius)/m;
    
    
    return CGPointMake(x, y);
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint offsetLocation = [recognizer locationInView:_scrollView];
        offsetLocation.x -= _scrollView.contentOffset.x;
        offsetLocation.y -= _scrollView.contentOffset.y;
        _location = offsetLocation;
        if (CGRectContainsPoint(_bounds, offsetLocation)) {
            [self finishedTracking];
        }else{
            _offest = [self calculateOffestWithLocation:offsetLocation];
        }
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        [self finishedTracking];
    }
}

- (void)moveScrollView{
    if (_scrollView) {
        CGPoint offset = CGPointMake(_scrollView.contentOffset.x + _offest.x, _scrollView.contentOffset.y + _offest.y);
        offset.x = MIN(CGRectGetMaxX(_contentRect), MAX(CGRectGetMinX(_contentRect), offset.x));
        offset.y = MIN(CGRectGetMaxY(_contentRect), MAX(CGRectGetMinY(_contentRect), offset.y));
        _recognizer.view.center = [_scrollView convertPoint:CGPointMake(_location.x + offset.x, _location.y + offset.y) toView:_recognizer.view.superview];
        [_scrollView setContentOffset:offset animated:NO];
    }
}

@end
