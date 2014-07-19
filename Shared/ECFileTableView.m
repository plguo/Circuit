//
//  ECFileTableView.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-19.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECFileTableView.h"

@implementation ECFileTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITableView* tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:tableView];
        
        UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44)];
        
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDone)];
        [toolBar setItems:@[item,done] animated:NO];
        [self addSubview:toolBar];
    }
    return self;
}

- (void)tapDone{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"cell"];
}
@end
