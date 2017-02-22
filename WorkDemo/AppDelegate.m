//
//  AppDelegate.m
//  WorkDemo
//
//  Created by akixie on 16/12/28.
//  Copyright © 2016年 Aki.Xie. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext1 = _managedObjectContext1;
@synthesize managedObjectModel1 = _managedObjectModel1;
@synthesize persistentStoreCoordinator1 = _persistentStoreCoordinator1;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "xbk.coreDataDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel1 {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel1 != nil) {
        return _managedObjectModel1;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataDemo" withExtension:@"momd"];
    _managedObjectModel1 = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel1;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator1 {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator1 != nil) {
        return _persistentStoreCoordinator1;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator1 = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel1]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataDemo.sqlite"];
    NSLog(@"%@",storeURL);
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),NSInferMappingModelAutomaticallyOption:@(YES)};
    
    if (![_persistentStoreCoordinator1 addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator1;
}


- (NSManagedObjectContext *)managedObjectContext1 {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext1 != nil) {
        return _managedObjectContext1;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator1];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext1 = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext1 setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext1;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext1 = self.managedObjectContext1;
    if (managedObjectContext1 != nil) {
        NSError *error = nil;
        if ([managedObjectContext1 hasChanges] && ![managedObjectContext1 save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end
