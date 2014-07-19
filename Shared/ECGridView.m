//
//  ECGridView.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-27.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECGridView.h"
#define GRID_WIDTH 40.0
#define MARGIN_WIDTH 60.0

@implementation ECGridView{
    NSUInteger _width;
    NSUInteger _height;
    CGRect _gridRect;
}

#pragma mark - Methods for tool bar initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        CGSize contentSize = CGSizeMake(frame.size.width - MARGIN_WIDTH*2, frame.size.height - MARGIN_WIDTH*2);
        _width = (NSUInteger)contentSize.width/GRID_WIDTH + 1;
        _height = (NSUInteger)contentSize.height/GRID_WIDTH + 1;
        _gridRect = CGRectMake(MARGIN_WIDTH+GRID_WIDTH,
                               MARGIN_WIDTH+GRID_WIDTH,
                               GRID_WIDTH*(_width-3),
                               GRID_WIDTH*(_height-3));
        
        _gridWidth = GRID_WIDTH;
        _marginWidth = MARGIN_WIDTH;
    }
    return self;
}

+ (instancetype)generateGridWithNumberOfVerticalLines:(NSUInteger)width HorizonLines:(NSUInteger)height{
    return [[ECGridView alloc] initWithFrame:CGRectMake(0, 0, (width+1)*GRID_WIDTH + MARGIN_WIDTH*2, (height+1)*GRID_WIDTH + MARGIN_WIDTH*2)];
}



#pragma mark - Snap Method
- (CGPoint)closestPointInGridView:(CGPoint)point{
    CGPoint newPoint;
    //Limit X in rect
    newPoint.x = MIN(point.x, CGRectGetMaxX(_gridRect));
    newPoint.x = MAX(newPoint.x, CGRectGetMinX(_gridRect));
    
    //Limit Y in rect
    newPoint.y = MIN(point.y, CGRectGetMaxY(_gridRect));
    newPoint.y = MAX(newPoint.y, CGRectGetMinY(_gridRect));
    
    //Snap X to point
    CGFloat xRemainder = (CGFloat)fmod(newPoint.x - MARGIN_WIDTH, GRID_WIDTH);
    if (xRemainder > GRID_WIDTH/2) {
        newPoint.x += GRID_WIDTH - xRemainder;
    }else{
        newPoint.x -= xRemainder;
    }
    
    
    CGFloat yRemainder = (CGFloat)fmod(newPoint.y - MARGIN_WIDTH, GRID_WIDTH);
    if (yRemainder > GRID_WIDTH/2) {
        newPoint.y += GRID_WIDTH - yRemainder;
    }else{
        newPoint.y -= yRemainder;
    }
    
    
    return newPoint;
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
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.8 alpha:1.0].CGColor);
    
    //Draw Vertical Lines Expect Border And Every 10 Lines
    for (NSUInteger i = 1; i < _width - 1; i ++) {
        if (i % 5 != 0) {
            CGContextMoveToPoint(context, i*GRID_WIDTH+MARGIN_WIDTH, MARGIN_WIDTH);
            CGContextAddLineToPoint(context, i*GRID_WIDTH+MARGIN_WIDTH, MARGIN_WIDTH+(_height-1)*GRID_WIDTH);
        }
    }
    
    //Draw Horizon Lines Expect Border And Every 10 Lines
    for (NSUInteger i = 1; i < _height - 1; i ++) {
        if (i % 5 != 0) {
            CGContextMoveToPoint(context, MARGIN_WIDTH, i*GRID_WIDTH+MARGIN_WIDTH);
            CGContextAddLineToPoint(context, MARGIN_WIDTH+(_width-1)*GRID_WIDTH, i*GRID_WIDTH+MARGIN_WIDTH);
        }
    }
    CGContextStrokePath(context);
    
    //Draw Vertical Lines Every 10 Lines
    CGContextSetLineWidth(context, 4.0);
    for (NSUInteger i = 5; i < _width - 1; i += 5) {
        CGContextMoveToPoint(context, i*GRID_WIDTH+MARGIN_WIDTH, MARGIN_WIDTH);
        CGContextAddLineToPoint(context, i*GRID_WIDTH+MARGIN_WIDTH, MARGIN_WIDTH+(_height-1)*GRID_WIDTH);
    }
    
    //Draw Vertical Lines Every 10 Lines
    for (NSUInteger i = 5; i < _height -1; i += 5) {
        CGContextMoveToPoint(context, MARGIN_WIDTH, i*GRID_WIDTH+MARGIN_WIDTH);
        CGContextAddLineToPoint(context, MARGIN_WIDTH+(_width-1)*GRID_WIDTH, i*GRID_WIDTH+MARGIN_WIDTH);
    }
    
    //Draw Border
    //Left |
    CGContextMoveToPoint(context, +MARGIN_WIDTH, MARGIN_WIDTH - 2);
    CGContextAddLineToPoint(context, +MARGIN_WIDTH, MARGIN_WIDTH+(_height-1)*GRID_WIDTH + 2);
    
    //Right |
    CGContextMoveToPoint(context, (_width-1)*GRID_WIDTH+MARGIN_WIDTH, MARGIN_WIDTH - 2);
    CGContextAddLineToPoint(context, (_width-1)*GRID_WIDTH+MARGIN_WIDTH, MARGIN_WIDTH+(_height-1)*GRID_WIDTH + 2);
    
    //Top -
    CGContextMoveToPoint(context, MARGIN_WIDTH, MARGIN_WIDTH);
    CGContextAddLineToPoint(context, MARGIN_WIDTH+(_width-1)*GRID_WIDTH, MARGIN_WIDTH);
    
    //Bottom -
    CGContextMoveToPoint(context, MARGIN_WIDTH, (_height-1)*GRID_WIDTH+MARGIN_WIDTH);
    CGContextAddLineToPoint(context, MARGIN_WIDTH+(_width-1)*GRID_WIDTH, (_height-1)*GRID_WIDTH+MARGIN_WIDTH);
    
    CGContextStrokePath(context);
}


@end
