//
//  LDataModel.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-12.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//
#import "ECTFileMenuCell.h"
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
    
    NSFetchedResultsController* _fetchedResultsController;
    dispatch_queue_t _dataQueue;
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
        _dataQueue = dispatch_queue_create("com.edguo.LogicGate.LDataModel", 0);
        
        [self setupFileSystem];
        
        
        
        
        
    }
    return self;
}



#pragma mark - Method for database
#pragma mark add
- (void)addManagedObject:(NSString *)name Path:(NSURL *)path LastEditedDate:(NSDate*)date Snapshot:(NSData*)snapshot{
    if (name != nil && path != nil) {
        dispatch_async(_dataQueue, ^{
            NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"LDMap"
                                                                           inManagedObjectContext:_managedObjectContext];
            [managedObject setValue:name forKey:@"name"];
            
            [managedObject setValue:[path absoluteString] forKey:@"path"];
            
            if (date) {
                [managedObject setValue:date forKey:@"lastEditedDate"];
            } else {
                [managedObject setValue:[NSDate date] forKey:@"lastEditedDate"];
            }
            
            if (snapshot) {
                [managedObject setValue:snapshot forKey:@"snapshot"];
            }else{
                
                __block NSData* data;
                CGSize imageSize = [ECTFileMenuCell preferredSizeForImage];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    label.text = name;
                    label.backgroundColor = [UIColor whiteColor];
                    label.textColor = [UIColor blackColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    
                    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0.0);
                    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
                    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    data = UIImagePNGRepresentation(image);
                });
                
                [managedObject setValue:data forKey:@"snapshot"];
            }
            
            [_managedObjectContext insertObject:managedObject];
        });
    }
}

#pragma mark setup
- (void)setupFileSystem{
    dispatch_async(_dataQueue, ^{
        if (![[NSFileManager defaultManager]fileExistsAtPath:[self saveDirectory].path]) {
            NSError* err;
            [[NSFileManager defaultManager] createDirectoryAtURL:[self saveDirectory]
                                     withIntermediateDirectories:YES attributes:nil error:&err];
        }
        
        
        //Core Data
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
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LDMap" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastEditedDate" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        //#warning Debug only
        [self logAllData];
    });
    
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

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([[_fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ECTFileMenuCell *cell = (ECTFileMenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.image = [[UIImage alloc] initWithData:(NSData*)[managedObject valueForKey:@"snapshot"]];
    cell.title = (NSString*)[managedObject valueForKey:@"name"];
    cell.titleColor = [UIColor whiteColor];
    // Configure the cell with data from the managed object.
    return cell;
}

#pragma mark - Save Map
- (BOOL)addMap:(NSString*)name Snapshot:(UIImage *)snapshot{
    if (![self isMapExisted:name]) {
        NSURL* url = [[self saveDirectory] URLByAppendingPathComponent:name isDirectory:YES];
        BOOL succeed = [[NSFileManager defaultManager] createDirectoryAtURL:url
                                               withIntermediateDirectories:YES
                                                                attributes:nil
                                                                     error:nil];
        if (succeed) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSData* data = UIImagePNGRepresentation(snapshot);
                [self addManagedObject:name Path:url LastEditedDate:nil Snapshot:data];
            });
            return YES;
        }
    }
    return NO;
}


- (void)saveMap:(NSString*)name GatesArray:(NSArray*)gatesArray WiresArray:(NSArray*)wiresArray Snapshot:(UIImage*)snapshot{
    
}

- (BOOL)isMapExisted:(NSString*)name{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LDMap" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger fetchedCount = [_managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (!error) {
        if (fetchedCount == NSNotFound ||fetchedCount == 0) {
            return NO;
        }
    }
    return YES;
}

- (void)setFetchedResultsControllerDelegate:(id)delegate{
    if ([delegate conformsToProtocol:@protocol(NSFetchedResultsControllerDelegate) ]) {
        _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>)delegate;
    }
    
}

/*
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