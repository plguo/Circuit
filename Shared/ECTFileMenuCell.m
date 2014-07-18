//
//  ECTFileMenuCell.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-16.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTFileMenuCell.h"

@implementation ECTFileMenuCell{
    UIImageView* _imageView;
    UILabel* _label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.contentView.backgroundColor = [UIColor greenColor];
        _image = nil;
        _title = @"";
        _titleColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectOffset(CGRectInset(self.contentView.bounds, 5, 15),0,-10)];
        _imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_imageView.frame].CGPath;
        _imageView.layer.shadowColor = [UIColor grayColor].CGColor;
        _imageView.layer.shadowOpacity = 0.8;
        [self.contentView addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(self.contentView.bounds) - 20, CGRectGetWidth(self.contentView.bounds)-30, 20)];
        _label.text = _title;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = _titleColor;
        [self.contentView addSubview:_label];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    }
    return self;
    
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _label.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    _label.textColor = titleColor;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

+ (CGSize)preferredSizeForCell{
    return CGSizeMake(80.0, 70.0);
}

+ (CGSize)preferredSizeForImage{
    CGSize cellSize = [self preferredSizeForCell];
    return CGSizeMake(cellSize.width, cellSize.height - 20.0);
}
@end
