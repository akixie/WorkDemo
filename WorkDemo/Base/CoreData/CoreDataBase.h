//
//  CoreDataBase.h
//  WorkDemo
//
//  Created by akixie on 17/2/22.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Car+CoreDataProperties.h"
#import "CarModel.h"

@interface CoreDataBase : NSObject

+(CoreDataBase *)sharedCoreData;

//增
-(BOOL)saveCarInfoByCarModel:(CarModel *)carmodel;

//删：根据carID来删除carID对应的那个车辆
-(BOOL)deleteCarInfoByCarID:(NSString *)carID;

//改：根据userID以及carID来修改车辆信息
-(BOOL)updateCarInfoByCarModel:(CarModel *)carmodel;

// 查：根据userID查寻该userID对应的所有车辆
-(NSArray *)queryCarInfoByUserID:(NSString *)userID;

@end
