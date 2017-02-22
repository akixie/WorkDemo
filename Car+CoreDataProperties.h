//
//  Car+CoreDataProperties.h
//  
//
//  Created by akixie on 17/2/22.
//
//  This file was automatically generated and should not be edited.
//

#import "Car+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Car (CoreDataProperties)

+ (NSFetchRequest<Car *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, copy) NSString *carID;
@property (nullable, nonatomic, copy) NSString *carName;
@property (nullable, nonatomic, copy) NSString *carNumber;
@property (nullable, nonatomic, copy) NSString *carIsDefault;
@property (nullable, nonatomic, copy) NSString *carDiatance;

@end

NS_ASSUME_NONNULL_END
