//
//  ECFileTableView.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-19.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECFileTableView.h"

@implementation ECFileTableView{
    UIBarButtonItem *_delete, *_flexItem, *_done, *_edit, *_cancel;
    UITableView* _tableView;
    UIToolbar* _toolBar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        //_tableView.editing = YES;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        
        
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44)];
        _toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _delete = [[UIBarButtonItem alloc] initWithTitle:@"Delete All" style:UIBarButtonItemStyleBordered target:self action:@selector(tapDelete)];
        _delete.tintColor = [UIColor redColor];
        
        _edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(tapEdit)];
        _edit.enabled = NO;
        
        _flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDone)];
        
        _cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(tapCancel)];
        
        [_toolBar setItems:@[_edit,_flexItem,_done] animated:NO];
        [self addSubview:_toolBar];
        
        _tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _tableView.autoresizingMask = self.autoresizingMask;
    }
    return self;
}

- (void)tapDelete{
    NSString* message;
    NSArray* selected = [_tableView indexPathsForSelectedRows];
    if (selected.count == 1 || [_tableView numberOfRowsInSection:0] == 1) {
        message = @"Are you sure you want to delete this item?";
    }else{
        message = @"Are you sure you want to delete these items?";
    }
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    [actionSheet showInView:self];
}

- (void)tapEdit{
    _tableView.editing = YES;
    [_toolBar setItems:@[_delete,_flexItem,_cancel] animated:YES];
}

- (void)tapCancel{
    _tableView.editing = NO;
    [_toolBar setItems:@[_edit,_flexItem,_done] animated:YES];
}

- (void)tapDone{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (self.delegate) {
            [self.delegate fileTableView:self DeleteMapsAtIndexPaths:[_tableView indexPathsForSelectedRows]];
            _tableView.editing = NO;
            [_toolBar setItems:@[_edit,_flexItem,_done] animated:YES];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing) {
        NSArray* selected = [tableView indexPathsForSelectedRows];
        if (selected.count == [_tableView numberOfRowsInSection:0]) {
            _delete.title = @"Delete All";
        }else{
            _delete.title = [NSString stringWithFormat:@"Delete (%lu)",(unsigned long)selected.count];
        }
    }else{
        [self tapDone];
        if (self.delegate) {
            [self.delegate loadMapAtIndexPath:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.editing) {
        NSArray* selected = [tableView indexPathsForSelectedRows];
        if (selected.count == [tableView numberOfRowsInSection:0] || selected.count == 0) {
            _delete.title = @"Delete All";
        }else{
            _delete.title = [NSString stringWithFormat:@"Delete (%lu)",(unsigned long)selected.count];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataSource) {
        return  [self.dataSource numberOfSectionsInFileTableView:self];
    }else{
        return 0;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows = 0;
    if (self.dataSource) {
        numberOfRows = [self.dataSource fileTableView:self numberOfRowsInSection:section];
    }
    if (numberOfRows == 0) {
        _edit.enabled = NO;
    }else{
        _edit.enabled = YES;
    }
    return numberOfRows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.dataSource) {
        cell.textLabel.text = [self.dataSource fileTableView:self titleForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (void)reloadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    
}
@end
