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
        _image = nil;
        _title = @"";
        _titleColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectOffset(CGRectInset(self.contentView.bounds, 5, 15),0,-10)];
        _imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_imageView.frame].CGPath;
        _imageView.layer.shadowColor = [UIColor grayColor].CGColor;
        [self.contentView addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - 20, CGRectGetWidth(self.contentView.bounds), 20)];
        _label.text = _title;
        _label.textColor = _titleColor;
        [self.contentView addSubview:_label];
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



@end
