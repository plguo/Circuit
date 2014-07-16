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
    
    //dispatch_queue_t _dataQueue;
}

#pragma mark - Init Model
+ (instancetype)sharedDataModel{
    if (!shareModel) {
        shareModel = [[self alloc] init];
    }
    return shareModel;
}

+ (void)saveDataModel {
    if (shareModel != nil) {
        [shareModel saveContext];
    }
}

- (instancetype)init{
    self = [super init];
    if (self) {
        //_dataQueue = dispatch_queue_create("com.edguo.LogicGate.LDataModel", 0);
        
        [self setupFileSystem];
        
        //#warning Debug only
        [self logAllData];
        
        
    }
    return self;
}



#pragma mark - Method for database
#pragma mark add
- (void)addEntry:(NSString *)name Path:(NSURL *)path LastEditedDate:(NSDate*)date Snapshot:(NSData*)snapshot{
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"LDMap"
                                                                   inManagedObjectContext:_managedObjectContext];
    [managedObject setValue:name                  forKey:@"name"];
    [managedObject setValue:[path absoluteString] forKey:@"path"];
    [managedObject setValue:date                  forKey:@"lastEditedDate"];
    [managedObject setValue:snapshot              forKey:@"snapshot"];
}

#pragma mark setup
- (void)setupFileSystem{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LGMapModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSURL *storeURL = [[self documentsDirectory] URLByAppendingPathComponent:@"LGMapModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"LDataModel init _persistentStoreCoordinator error %@, %@", error, [error userInfo]);
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
}

#pragma mark save context
- (void)saveContext{
    NSError *error = nil;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            NSLog(@"LDataModel save _managedObjectContext error %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark - Debug
- (void)logAllData{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LDMap" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    // Limit size
    //[fetchRequest setFetchBatchSize:10];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastEditedDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"LDataModel fetch error %@, %@", error, [error userInfo]);
        return;
    }else{
        for (NSManagedObject* managedObject in fetchedObjects) {
            NSString* name = [managedObject valueForKey:@"name"];
            NSString* path = [managedObject valueForKey:@"path"];
            NSDate* date = [managedObject valueForKey:@"lastEditedDate"];
            NSLog(@"Name:%@ Path:%@ Date:%@",name,path,[date description]);
        }
    }
}

#pragma mark - URL
- (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)saveDirectory{
    return [[self documentsDirectory] URLByAppendingPathComponent:@"Save" isDirectory:YES];
}

/*
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
*/

@end
