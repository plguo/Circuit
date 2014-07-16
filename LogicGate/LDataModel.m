//
//  LDataModel.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-12.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LDataModel.h"
#import "LWire.h"
#import "LGate.h"

#define formatVersion @"1"

static LDataModel* shareModel;
@implementation LDataModel{
    //NSMutableArray* _fileList;
    //NSDictionary* _filesInfoDictionary;
    
    NSManagedObjectContext* _managedObjectContext;
    NSManagedObjectModel* _managedObjectModel;
    NSPersistentStoreCoordinator*  _persistentStoreCoordinator;
}

#pragma mark - Init Model
+ (instancetype)sharedDataModel{
    if (!shareModel) {
        shareModel = [[self alloc] init];
    }
    return shareModel;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
        /*
        //Make sure save folder exist
        if (![[NSFileManager defaultManager]fileExistsAtPath:[self getSaveDirectory]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[self getSaveDirectory]
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        
        //Make sure file list exist
        NSString* filesListPath = [self getFilesListPath];
        if (![[NSFileManager defaultManager]fileExistsAtPath:filesListPath]) {
            [self saveFilesList];
        }
        
        //Make sure it use lastest version
        NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:filesListPath];
        if (![formatVersion isEqualToString:dictionary[@"version"]]) {
            //Remove the old version
            [self removeSaveDirectory];
            _fileList = [NSMutableArray array];
            _filesInfoDictionary = _filesInfoDictionary = @{@"version":formatVersion,@"files":_fileList};
        }else{
            _fileList = [NSMutableArray arrayWithArray:dictionary[@"files"]];
            _filesInfoDictionary = _filesInfoDictionary = @{@"version":formatVersion,@"files":_fileList};
        }
         */
        
    }
    return self;
}
#pragma mark - Save Map
-(void)saveMapToIndex:(NSUInteger)index GatesArray:(NSArray*)gatesArray WiresArray:(NSArray*)wiresArray{
    
}

#pragma mark - File List
-(NSString*)getFilesListPath{
    return [[self getSaveDirectory] stringByAppendingPathComponent:@"filesList.plist"];
}

-(void)saveFilesList{
    [_filesInfoDictionary writeToFile:[self getFilesListPath] atomically:YES];
}

#pragma mark - SaveDirectory
-(void)removeSaveDirectory{
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtPath:[self getSaveDirectory] error:&error];
}

-(NSString*)getSaveDirectory{
    //Get doc path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    //Return path with save directory
    return [docPath stringByAppendingPathComponent:@"save"];
}

@end
