//
//  LTAGateInfoView.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-08.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LTAGateInfoView.h"
#import "LInputGate.h"

@implementation LTAGateInfoView{
    UITextView* _textView;
    UILabel* _label;
    NSInteger _format;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _title = @"Gate";
        _format = 0;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Format" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeFormat) forControlEvents:UIControlEventTouchDown];
        [button sizeToFit];
        CGSize buttonSize = button.frame.size;
        CGSize boundsSize = self.bounds.size;
        
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        button.center = CGPointMake(boundsSize.width - buttonSize.width/2, buttonSize.height/2);
        [self addSubview:button];
        
        _label = [[UILabel alloc] init];
        _label.text = self.title;
        _label.textColor = [UIColor whiteColor];
        _label.font = button.titleLabel.font;
        _label.textAlignment = NSTextAlignmentCenter;
        
        [_label sizeToFit];
        _label.center = CGPointMake(_label.center.x, button.center.y);
        [self addSubview:_label];
        
        CGFloat space = 2.0;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0, buttonSize.height + space, boundsSize.width, boundsSize.height - (buttonSize.height + space))];
        _textView.editable = NO;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_textView];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _label.text = _title;
    [_label sizeToFit];
}

- (void)setDelegate:(id<LTAGateInfoViewDelegate>)delegate{
    if (delegate) {
        _delegate = delegate;
        [self performSelectorInBackground:@selector(loadBooleanFormula) withObject:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputDidUpdate)
                                                     name:[LInputGate inputDidUpdateNotificationKey]
                                                   object:nil];
    }
}

- (void)changeFormat{
    _format += 1;
    if (_format > 1) {
        _format = 0;
    }
    [self loadBooleanFormula];
}

- (void)loadBooleanFormula{
    if (self.delegate) {
        
        NSMutableString* string = [[NSMutableString alloc] initWithString:[self.delegate booleanFormulaWithFormat:_format]];
        
        if ([[string substringToIndex:1] isEqualToString:@"("] && [[string substringFromIndex:string.length - 1] isEqualToString:@")"]) {
            [string deleteCharactersInRange:NSMakeRange(0, 1)];
            [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
        }
        
        
        UIFont* font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        UIFont* boldFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        NSDictionary* dict = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
        
        if ([string rangeOfString:@"<-"].location == NSNotFound && [string rangeOfString:@"->"].location == NSNotFound) {
            NSMutableAttributedString*attString = [[NSMutableAttributedString alloc] initWithString:string
                                                                                         attributes:dict];
            [_textView performSelectorOnMainThread:@selector(setAttributedText:) withObject:attString waitUntilDone:NO];
            
        }else{
            
            NSMutableSet* rangeSet = [NSMutableSet set];
            NSRange subStringRange = NSMakeRange(0, 2);
            
            
            NSInteger beginLocation = -1;
            NSInteger counter = 0;
            for (NSUInteger i = 0; i < string.length - 1; i++) {
                subStringRange.location = i;
                NSString* subString = [string substringWithRange:subStringRange];
                if ([subString isEqualToString:@"<-"]) {
                    if (beginLocation == -1) {
                        beginLocation = i;
                        [string deleteCharactersInRange:subStringRange];
                        counter = 0;
                        i --;
                    }else{
                        counter += 1;
                    }
                }else if ([subString isEqualToString:@"->"]){
                    if (beginLocation >= 0) {
                        if (counter == 0) {
                            NSRange range; //= NSMakeRange(beginLocation, i - beginLocation);
                            NSNumber* status;
                            
                            NSString* boolString = [string substringWithRange:NSMakeRange(subStringRange.location - 1, 1)];
                            if ([boolString isEqualToString:@"0"]) {
                                
                                range = NSMakeRange(beginLocation, i - beginLocation - 1);
                                status = [NSNumber numberWithBool:NO];
                                [string deleteCharactersInRange:NSMakeRange(subStringRange.location - 1, subStringRange.length + 1)];
                                
                            }else if ([boolString isEqualToString:@"1"]) {
                                
                                range = NSMakeRange(beginLocation, i - beginLocation - 1);
                                status = [NSNumber numberWithBool:YES];
                                [string deleteCharactersInRange:NSMakeRange(subStringRange.location - 1, subStringRange.length + 1)];
                                
                            }else{
                                
                                range = NSMakeRange(beginLocation, i - beginLocation);
                                status = [NSNumber numberWithBool:YES];
                                [string deleteCharactersInRange:subStringRange];
                                
                            }
                            NSValue* rangeValue = [NSValue valueWithRange:range];
                            
                            
                            [rangeSet addObject:@[rangeValue,status]];
                            
                            beginLocation = -1;
                        }else{
                            counter -= 1;
                        }
                    }
                }
            }
            
            NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:(NSString *)string attributes:dict];
            for (NSArray* valueArray in rangeSet) {
                NSValue* value = valueArray[0];
                NSRange range = [value rangeValue];
                
                NSNumber* status = valueArray[1];
                if ([status boolValue]) {
                    [attString addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:0.18 green:0.8 blue:0.44 alpha:1.0] range:range];
                }else{
                    [attString addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:0.9 green:0.298 blue:0.235 alpha:1.0] range:range];
                }
                [attString addAttribute:NSFontAttributeName value:boldFont range:range];
            }
            
            [_textView performSelectorOnMainThread:@selector(setAttributedText:) withObject:attString waitUntilDone:NO];
        }
    }
}

- (void)inputDidUpdate{
    [self loadBooleanFormula];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
         
@end
