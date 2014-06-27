//
//  ECGridView.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-27.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECGridView.h"
#define GridWidth 30.0
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
        self.backgroundColor = [UIColor grayColor];
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
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    
    //Draw Vertical Lines
    for (NSUInteger i = 0; i < _width; i ++) {
        CGContextMoveToPoint(context, i*GridWidth+BorderWidth, BorderWidth);
        CGContextAddLineToPoint(context, i*GridWidth+BorderWidth, BorderWidth+(_height-1)*GridWidth);
        
    }
    CGContextStrokePath(context);
    
}


@end
