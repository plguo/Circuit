//
//  ECGridView.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-27.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECGridView.h"
#define GridWidth 40.0
#define BorderWidth 60.0

@implementation ECGridView{
    NSUInteger _width;
    NSUInteger _height;
}

#pragma mark - Methods for tool bar initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        CGSize contentSize = CGSizeMake(frame.size.width - BorderWidth*2, frame.size.height - BorderWidth*2);
        _width = (NSUInteger)contentSize.width/GridWidth + 1;
        _height = (NSUInteger)contentSize.height/GridWidth + 1;
    }
    return self;
}

+ (instancetype)generateGridWithNumberOfVerticalLines:(NSUInteger)width HorizonLines:(NSUInteger)height{
    return [[ECGridView alloc] initWithFrame:CGRectMake(0, 0, (width+1)*GridWidth + BorderWidth*2, (height+1)*GridWidth + BorderWidth*2)];
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _width = (NSInteger)[aDecoder decodeIntegerForKey:@"PointWidth"];
        _height = (NSInteger)[aDecoder decodeIntegerForKey:@"PointHeight"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:(NSInteger)_width forKey:@"PointWidth"];
    [aCoder encodeInteger:(NSInteger)_height forKey:@"PointHeight"];
}

#pragma mark - Draw Rect
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    //Draw Vertical Lines Expect Border And Every 10 Lines
    for (NSUInteger i = 1; i < _width - 1; i ++) {
        if (i % 5 != 0) {
            CGContextMoveToPoint(context, i*GridWidth+BorderWidth, BorderWidth);
            CGContextAddLineToPoint(context, i*GridWidth+BorderWidth, BorderWidth+(_height-1)*GridWidth);
        }
    }
    
    //Draw Horizon Lines Expect Border And Every 10 Lines
    for (NSUInteger i = 1; i < _height - 1; i ++) {
        if (i % 5 != 0) {
            CGContextMoveToPoint(context, BorderWidth, i*GridWidth+BorderWidth);
            CGContextAddLineToPoint(context, BorderWidth+(_width-1)*GridWidth, i*GridWidth+BorderWidth);
        }
    }
    CGContextStrokePath(context);
    
    //Draw Vertical Lines Every 10 Lines
    CGContextSetLineWidth(context, 4.0);
    for (NSUInteger i = 5; i < _width - 1; i += 5) {
        CGContextMoveToPoint(context, i*GridWidth+BorderWidth, BorderWidth);
        CGContextAddLineToPoint(context, i*GridWidth+BorderWidth, BorderWidth+(_height-1)*GridWidth);
    }
    
    //Draw Vertical Lines Every 10 Lines
    for (NSUInteger i = 5; i < _height -1; i += 5) {
        CGContextMoveToPoint(context, BorderWidth, i*GridWidth+BorderWidth);
        CGContextAddLineToPoint(context, BorderWidth+(_width-1)*GridWidth, i*GridWidth+BorderWidth);
    }
    
    //Draw Border
    CGContextMoveToPoint(context, +BorderWidth, BorderWidth);
    CGContextAddLineToPoint(context, +BorderWidth, BorderWidth+(_height-1)*GridWidth);
    
    CGContextMoveToPoint(context, _width*GridWidth+BorderWidth, BorderWidth);
    CGContextAddLineToPoint(context, _width*GridWidth+BorderWidth, BorderWidth+(_height-1)*GridWidth);
    
    CGContextMoveToPoint(context, BorderWidth, BorderWidth);
    CGContextAddLineToPoint(context, BorderWidth+(_width-1)*GridWidth, BorderWidth);
    
    CGContextMoveToPoint(context, BorderWidth, _height*GridWidth+BorderWidth);
    CGContextAddLineToPoint(context, BorderWidth+(_width-1)*GridWidth, _height*GridWidth+BorderWidth);
    
    CGContextStrokePath(context);
}


@end
