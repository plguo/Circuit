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
#import "LSwitch.h"

#define formatVersion @"1"
#define DATA_DEBUG_MODE YES

static LDataModel* shareModel;
static NSString* const kLDataModelCache;

@implementation LDataModel{
    //NSMutableArray* _fileList;
    //NSDictionary* _filesInfoDictionary;
    
    NSManagedObjectContext* _managedObjectContext;
    NSManagedObjectModel* _managedObjectModel;
    NSPersistentStoreCoordinator*  _persistentStoreCoordinator;
    
    dispatch_queue_t _dataQueue;
    
    NSUInteger _lockCount;
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
        _dataQueue = dispatch_queue_create("com.edguo.LogicGate.LDataModel", 0);
        _lockCount = 0;
        
        [self setupFileSystem];
    }
    return self;
}



#pragma mark - Method for database
#pragma mark setup
- (void)setupFileSystem{
    NSURL* documentsDirectory = [self documentsDirectory];
    dispatch_async(_dataQueue, ^{
        //Core Data
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LGMapModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:@"LGMapModel.sqlite"];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"LDataModel Selector:setupFileSystem RelatedObject:_persistentStoreCoordinator %@, %@", error, [error userInfo]);
        }
        
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.fetchBatchSize = 10;
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LDMap" inManagedObjectContext:_managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastEditedDate" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                                                   cacheName:kLDataModelCache];
        
        
        
        
        if (DATA_DEBUG_MODE) {
            //#warning Debug only
            //[self addEmptyData:40];
            [self logData];
            [self logDetailedData];
        }
    });
    
}

#pragma mark add
- (void)addManagedObject:(NSString *)name Snapshot:(NSData*)snapshot
                GateData:(NSData*)gateData WireData:(NSData*)wireData
          LastEditedDate:(NSDate*)date{
    
    if (name != nil && gateData != nil && wireData != nil) {
        dispatch_async(_dataQueue, ^{
            NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"LDMap" inManagedObjectContext:_managedObjectContext];
            
            [managedObject setValue:name forKey:@"name"];
            
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
            
            NSManagedObject* managedObjectData = [NSEntityDescription insertNewObjectForEntityForName:@"LDMapData" inManagedObjectContext:_managedObjectContext];
            
            [managedObjectData setValue:gateData forKey:@"gateData"];
            
            [managedObjectData setValue:wireData forKey:@"wireData"];
            
            [managedObject setValue:managedObjectData forKey:@"mapData"];
            
            [LDataModel saveDataModel];
            
            [gateData writeToURL:[[[LDataModel sharedDataModel] documentsDirectory] URLByAppendingPathComponent:@"testData.plist"] atomically:YES];
        });
    }
}

#pragma mark save context
+ (void)saveDataModel {
    if (shareModel != nil) {
        [shareModel saveContext];
    }
}

- (void)saveContext{
    NSError *error = nil;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            NSLog(@"LDataModel Selector:saveContext RelatedObject:_managedObjectContext %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark cache
- (void)deleteCache{
    [NSFetchedResultsController deleteCacheWithName:kLDataModelCache];
}

#pragma mark - Debug
- (void)logData{
    NSFetchRequest *dataFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *dataEntity = [NSEntityDescription entityForName:@"LDMapData"
                                                  inManagedObjectContext:_managedObjectContext];
    [dataFetchRequest setEntity:dataEntity];
    NSUInteger count = [_managedObjectContext countForFetchRequest:dataFetchRequest error:nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LDMap"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSUInteger mapCount = [_managedObjectContext countForFetchRequest:fetchRequest error:nil];
    
    NSLog(@"LDMap Count:%lu LDMapData Count:%lu",(unsigned long)mapCount,(unsigned long)count);
}

- (void)logDetailedData{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LDMap"
                                              inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
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
            BOOL dataStatus = ([managedObject valueForKey:@"mapData"] != nil);
            NSLog(@"Map Name:%@ DataStatus:%hhd",name, (char)dataStatus);
        }
    }
}

- (void)addEmptyData:(NSUInteger)number{
    for (NSUInteger i = 1; i <= number; i++) {
        NSArray* emptyArray = @[];
        NSData* emptyData = [NSKeyedArchiver archivedDataWithRootObject:emptyArray];
        [self addManagedObject:[NSString stringWithFormat:@"EmptyData(%lu)",(unsigned long)i] Snapshot:nil GateData:emptyData WireData:emptyData LastEditedDate:nil];
    }
    [LDataModel saveDataModel];
}

#pragma mark - URL
- (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
    
    // Configure the cell with data from the managed object.
    NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.image = [[UIImage alloc] initWithData:(NSData*)[managedObject valueForKey:@"snapshot"]];
    cell.title = (NSString*)[managedObject valueForKey:@"name"];
    cell.titleColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - Map
#pragma mark add
- (void)addMap:(NSString*)name Snapshot:(UIImage *)snapshot
    GatesArray:(NSArray *)gatesArray WiresArray:(NSArray *)wiresArray{
    
    if (![self isMapExisted:name]) {
        NSData* data = UIImagePNGRepresentation(snapshot);
        __weak LDataModel* weakSelf = self;
        [self lockMap];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSData* wireData = [weakSelf wireDataWithWiresArray:wiresArray GatesArray:gatesArray];
            NSData* gateData = [NSKeyedArchiver archivedDataWithRootObject:gatesArray];
            
            [weakSelf addManagedObject:name Snapshot:data GateData:gateData WireData:wireData LastEditedDate:nil];
            [weakSelf unlockMap];
        });
    }
    
}

#pragma mark save
- (void)saveMapAtIndexPath:(NSIndexPath *)indexPath Snapshot:(UIImage *)snapshot
                GatesArray:(NSArray *)gatesArray WiresArray:(NSArray *)wiresArray{
    
    NSData* data = UIImagePNGRepresentation(snapshot);
    __weak LDataModel* weakSelf = self;
    [self lockMap];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData* wireData = [weakSelf wireDataWithWiresArray:wiresArray GatesArray:gatesArray];
        NSData* gateData = [NSKeyedArchiver archivedDataWithRootObject:gatesArray];
        
        dispatch_async(_dataQueue, ^{
            
            NSManagedObject* managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
            NSManagedObject* mapData = [managedObject valueForKey:@"mapData"];
            
            [managedObject setValue:data forKey:@"snapshot"];
            [managedObject setValue:[NSDate date] forKey:@"lastEditedDate"];
            
            [mapData setValue:wireData forKey:@"wireData"];
            [mapData setValue:gateData forKey:@"gateData"];
            
            [LDataModel saveDataModel];
            
            [weakSelf unlockMap];
        });
        
    });
    
}

- (NSData*)wireDataWithWiresArray:(NSArray*)wiresArray GatesArray:(NSArray*)gatesArray{
    NSMutableSet* set = [NSMutableSet setWithCapacity:wiresArray.count];
    for (LWire* wire in wiresArray) {
        if (wire.startPort && wire.endPort) {
            NSUInteger startIndex = [gatesArray indexOfObject:wire.startPort.superGate];
            NSUInteger endIndex = [gatesArray indexOfObject:wire.endPort.superGate];
            
            NSUInteger startPortIndex = [wire.startPort.superGate.outPorts indexOfObject:wire.startPort];
            NSUInteger endPortIndex = [wire.endPort.superGate.inPorts indexOfObject:wire.endPort];
            
            if (startIndex != NSNotFound && endIndex != NSNotFound) {
                
                NSNumber* startIndexNumber = [NSNumber numberWithUnsignedInteger:startIndex];
                NSNumber* startPortIndexNumber = [NSNumber numberWithUnsignedInteger:startPortIndex];
                
                NSNumber* endIndexNumber = [NSNumber numberWithUnsignedInteger:endIndex];
                NSNumber* endPortIndexNumber = [NSNumber numberWithUnsignedInteger:endPortIndex];
                
                NSArray* aWireInfoArray = @[startIndexNumber,startPortIndexNumber,endIndexNumber, endPortIndexNumber];
                [set addObject:aWireInfoArray];
            }
            
        }
    }
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:[set allObjects]];
    return data;
}

#pragma mark load
- (void)loadMapAtIndexPath:(NSIndexPath *)indexPath
                  GateView:(UIView *)gateView WireView:(UIView *)wireView
GateGestureRecognizerTarget:(id)target
                 PanAction:(SEL)panAction PortAction:(SEL)portAction{
    [self lockMap];
    NSManagedObject* managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    NSManagedObject* mapData = [managedObject valueForKey:@"mapData"];
    if (mapData) {
        NSArray* gateArray = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[mapData valueForKey:@"gateData"]];
        for (LGate* gate in gateArray) {
            [gateView addSubview:gate];
            UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target
                                                                                                   action:panAction];
            [gate addGestureRecognizer:panGestureRecognizer];
            [gate initUserInteractionWithTarget:target action:portAction];
        }
        
        NSArray* wireArray = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)[mapData valueForKey:@"wireData"]];
        for (NSArray* wireInfo in wireArray) {
            if (wireInfo.count == 4) {
                LGate* startGate = [gateArray objectAtIndex:[(NSNumber*)wireInfo[0] unsignedIntegerValue]];
                LGate* endGate = [gateArray objectAtIndex:[(NSNumber*)wireInfo[2] unsignedIntegerValue]];
                
                LPort* startPort = [startGate.outPorts objectAtIndex:[(NSNumber*)wireInfo[1] unsignedIntegerValue]];
                LPort* endPort =   [endGate.inPorts objectAtIndex:[(NSNumber*)wireInfo[3] unsignedIntegerValue]];
                
                if (startPort != nil && endPort != nil) {
                    LWire* wire = [[LWire alloc] initWire];
                    [wire connectNewPort:startPort];
                    [wire connectNewPort:endPort];
                    [wireView addSubview:wire];
                    [wire drawWire];
                }
            }
            
        }
        
        for (LGate* gate in gateArray) {
            if ([gate isKindOfClass:[LSwitch class]]) {
                LSwitch* switchGate = (LSwitch*) gate;
                ((LPort*)switchGate.outPorts[0]).boolStatus = switchGate.outputState;
            }
        }
    }
    
    [self unlockMap];
    
}

#pragma mark delete
- (void)deleteMapsAtIndexPath:(NSArray *)indexPaths completion:(void (^)())handler{
    dispatch_async(_dataQueue, ^{
        
        NSMutableArray* objectArray = [NSMutableArray arrayWithCapacity:indexPaths.count];
        for (NSIndexPath* path in indexPaths) {
            [objectArray addObject:[_fetchedResultsController objectAtIndexPath:path]];
        }
        for (NSManagedObject* object  in objectArray) {
            [_managedObjectContext deleteObject:(NSManagedObject*)[object valueForKey:@"mapData"]];
            [_managedObjectContext deleteObject:object];
        }
        [LDataModel saveDataModel];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            handler(indexPaths);
        });
        
    });
}

- (void)deleteMapsAtIndexPath:(NSArray *)indexPaths{
    dispatch_async(_dataQueue, ^{
        NSMutableArray* objectArray = [NSMutableArray arrayWithCapacity:indexPaths.count];
        for (NSIndexPath* path in indexPaths) {
            [objectArray addObject:[_fetchedResultsController objectAtIndexPath:path]];
        }
        for (NSManagedObject* object  in objectArray) {
            [_managedObjectContext deleteObject:(NSManagedObject*)[object valueForKey:@"mapData"]];
            [_managedObjectContext deleteObject:object];
        }
        [LDataModel saveDataModel];
    });
}

#pragma mark rename
- (void)renameMapAtIndexPath:(NSIndexPath *)indexPath Name:(NSString *)name{
    dispatch_async(_dataQueue, ^{
        NSManagedObject* managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
        [managedObject setValue:name forKey:@"name"];
        [LDataModel saveDataModel];
    });
}

#pragma mark existed
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
#pragma mark - Map Interaction
- (void)lockMap{
    _lockCount += 1;
    if (_lockCount == 1) {
        if (self.delegate) {
            [self.delegate startMapDataProcessing];
        }
    }
}

- (void)unlockMap{
    _lockCount -= 1;
    if (_lockCount == 0) {
        if (self.delegate) {
            [self.delegate finishMapDataProcessing];
        }
    }
}

#pragma mark- ECTFileMenuDataSource
- (void)setFetchedResultsControllerDelegate:(id)delegate{
    if ([delegate conformsToProtocol:@protocol(NSFetchedResultsControllerDelegate) ]) {
        _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>)delegate;
        [_fetchedResultsController performFetch:nil];
    }
    
}
@end
