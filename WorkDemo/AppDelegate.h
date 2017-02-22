//
//  AppDelegate.h
//  WorkDemo
//
//  Created by akixie on 16/12/28.
//  Copyright © 2016年 Aki.Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext1;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel1;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator1;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end

