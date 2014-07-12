//
//  LTAInputInfoView.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-12.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LTAInputInfoView.h"

@implementation LTAInputInfoView{
    UITextField* _textField;
    CGPoint _oldCenter;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect smallerFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 40.0);
    self = [super initWithFrame:smallerFrame];
    if (self) {
        UILabel* label = [[UILabel alloc] init];
        label.text = @"Input Name:";
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        CGFloat labelWidth = label.frame.size.width;
        label.center = CGPointMake(labelWidth/2,CGRectGetMidY(self.bounds));
        [self addSubview:label];
        
        labelWidth += 4.0;//Add some space
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        CGSize size = [_textField sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds) - labelWidth, CGRectGetHeight(self.bounds))];
        _textField.frame = CGRectMake(labelWidth, (CGRectGetHeight(self.bounds) - size.height)/2, CGRectGetWidth(self.bounds) - labelWidth, size.height);
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"Enter a name";
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_textField];
        [_textField addTarget:self action:@selector(done) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setDelegate:(id<LTAInputInfoViewDelegate>)delegate{
    if (delegate) {
        _delegate = delegate;
        NSString* inputName = [_delegate inputName];
        if (inputName) {
            _textField.text = [inputName substringWithRange:NSMakeRange(2, inputName.length-4)];
        }
    }
}

- (void)done{
    [_textField resignFirstResponder];
    if (self.delegate && _textField.text.length > 0) {
        [self.delegate setInputName:[NSString stringWithFormat:@"<-%@->",_textField.text]];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification*)notification{
    if (!self.superview) {
        return;
    }
    NSValue* beginFrameValue =  [notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginFrame = [self.superview.superview convertRect:[beginFrameValue CGRectValue] fromView:nil];
    
    NSValue* endFrameValue =  [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = [self.superview.superview convertRect:[endFrameValue CGRectValue] fromView:nil];
    
    NSNumber* animationCurveValue = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber* animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    CGPoint superviewCenter = CGPointMake(self.superview.center.x,
                                          endFrame.origin.y - CGRectGetHeight(self.superview.frame)/2);
    if (beginFrame.origin.y >= CGRectGetMaxY(self.superview.superview.frame)) {
        _oldCenter = self.superview.center;
    }else if (endFrame.origin.y >= CGRectGetMaxY(self.superview.superview.frame)){
        if (_toolBar) {
            superviewCenter = CGPointMake(CGRectGetWidth(self.superview.frame)/2, CGRectGetMinY(_toolBar.frame) - CGRectGetHeight(self.superview.frame)/2);
        }else{
            superviewCenter = _oldCenter;
        }
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[animationCurveValue integerValue]];
    [UIView setAnimationDuration:[animationDurationValue doubleValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.superview.center = superviewCenter;
    [UIView commitAnimations];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
