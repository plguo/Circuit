//
//  ECTFileMenu.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-16.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "ECTFileMenu.h"

@implementation ECTFileMenu{
    NSArray* _buttons;
    NSUInteger _counter;
    NSMutableSet* _selectedIndexPath;
    
    UIButton* _addButton;
    UIButton* _saveButton;
    UIButton* _loadButton;
    UIButton* _removeButton;
    UIButton* _renameButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addButton setTitle:@"Add" forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(tapAddButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
        [_addButton sizeToFit];
        _addButton.frame = CGRectOffset(_addButton.frame, 10, 4);
        [self addSubview:_addButton];
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(tapSaveButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
        [_saveButton sizeToFit];
        _saveButton.frame = CGRectOffset(_saveButton.frame, CGRectGetMaxX(_addButton.frame) + 8, 4);
        [self addSubview:_saveButton];
        
        _loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_loadButton setTitle:@"Load" forState:UIControlStateNormal];
        [_loadButton addTarget:self action:@selector(tapLoadButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loadButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
        [_loadButton sizeToFit];
        _loadButton.frame = CGRectOffset(_loadButton.frame,CGRectGetMaxX(_saveButton.frame) + 8, 4);
        [self addSubview:_loadButton];
        
        _removeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_removeButton setTitle:@"Delete" forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(tapRemoveButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_removeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
        [_removeButton sizeToFit];
        _removeButton.frame = CGRectOffset(_removeButton.frame, CGRectGetMaxX(_loadButton.frame) + 8, 4);
        [self addSubview:_removeButton];
        
        _renameButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_renameButton setTitle:@"Rename" forState:UIControlStateNormal];
        [_renameButton addTarget:self action:@selector(tapRenameButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_renameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_renameButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        
        [_renameButton sizeToFit];
        _renameButton.frame = CGRectOffset(_renameButton.frame, CGRectGetMaxX(_removeButton.frame) + 8, 4);
        [self addSubview:_renameButton];
        
        [self setCounter:0];
        CGFloat buttonHeight = 8.0 + CGRectGetHeight(_addButton.frame);
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), buttonHeight+80);
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, buttonHeight, CGRectGetWidth(self.frame), 80) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[ECTFileMenuCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_collectionView];
    }
    return self;
}

+ (instancetype)autosizeFileMenuForView:(UIView*)view{
    ECTFileMenu* fileMenu = [[self alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(view.bounds), 80)];
    fileMenu.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    return fileMenu;
}

- (void)tapAddButton{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Add Map"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"cancel"
                                             otherButtonTitles:@"add", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField* textField = [alertView textFieldAtIndex:0];
    textField.placeholder = @"Enter a name";
    [alertView show];
}

- (void)tapSaveButton{
    
}

- (void)tapLoadButton{
    
}

- (void)tapRemoveButton{
    NSString* title = [NSString stringWithFormat:@"Do you want to delete these %lu maps",(unsigned long)_selectedIndexPath.count];
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.superview];
}

- (void)tapRenameButton{
    
}

- (void)setCounter:(NSUInteger)counter{
    _counter = counter;
    if (_counter == 0) {
        _saveButton.enabled = NO;
        _loadButton.enabled = NO;
        _removeButton.enabled = NO;
        _renameButton.enabled = NO;
    }else if (_counter == 1){
        _saveButton.enabled = YES;
        _loadButton.enabled = YES;
        _removeButton.enabled = YES;
        _renameButton.enabled = YES;
    }else{
        _saveButton.enabled = NO;
        _loadButton.enabled = NO;
        _removeButton.enabled = YES;
        _renameButton.enabled = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_selectedIndexPath addObject:indexPath];
    [self setCounter:_counter + 1];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_selectedIndexPath removeObject:indexPath];
    [self setCounter:_counter - 1];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Add Map"]) {
        if (buttonIndex == 1) {
            UITextField* textField = [alertView textFieldAtIndex:0];
            
            if (self.delegate) {
                [self.delegate addMapWithName:textField.text];
            }
        }
        
    }
}
@end
