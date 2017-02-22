//
//  Car+CoreDataProperties.m
//  
//
//  Created by akixie on 17/2/22.
//
//  This file was automatically generated and should not be edited.
//

#import "Car+CoreDataProperties.h"

@implementation Car (CoreDataProperties)

+ (NSFetchRequest<Car *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Car"];
}

@dynamic userID;
@dynamic carID;
@dynamic carName;
@dynamic carNumber;
@dynamic carIsDefault;
@dynamic carDiatance;

@end
