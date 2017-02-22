//
//  CoreDataBase.m
//  WorkDemo
//
//  Created by akixie on 17/2/22.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "CoreDataBase.h"

CoreDataBase *_coreDataBase;

@implementation CoreDataBase

+(CoreDataBase *)sharedCoreData{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coreDataBase = [[CoreDataBase alloc] init];
    });
    return _coreDataBase;
}

//增
-(BOOL)saveCarInfoByCarModel:(CarModel*)carmodel{
    BOOL retVal = NO;
    
    //NSManagedObjectContext（被管理的数据上下文）,操作实际内容（操作持久层）作用：插入数据，查询数据，删除数据
    NSManagedObjectContext *context = [APPDELEGATE managedObjectContext1];
    //下面代码相当于 alloc init 初始化
    Car *car = [NSEntityDescription insertNewObjectForEntityForName:@"Car" inManagedObjectContext:context];
    car.userID = carmodel.userID;
    car.carID = carmodel.carID;
    car.carName = carmodel.carName;
    car.carNumber = carmodel.carNumber;
    car.carIsDefault = carmodel.carIdDefault;
    NSError *error;
    if ([context save:&error]) {
        NSLog(@"保存成功");
        retVal = YES;
    }
    return retVal;
}

//删除，根据carID来删除对应那个车辆
-(BOOL)deleteCarInfoByCarID:(NSString*)carID{
    BOOL retVal = NO;
    NSManagedObjectContext *context = [APPDELEGATE managedObjectContext1];
    //建立请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //读取所有Car
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Car" inManagedObjectContext:context];
    request.entity = entity;
    //设置检索条件（不设置默认所有Car）
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"carID=%@",carID];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (arr.count) {
        //删除对象
        for (Car *car in arr) {
            [context deleteObject:car];
        }
        //保存删除的结果
        if ([context save:nil]) {
            retVal = YES;
        }
        
    }else{
        NSLog(@"没有检索到结果");
    }
    return retVal;
}

//改，根据userID和carID修改车辆信息
-(BOOL)updateCarInfoByCarModel:(CarModel *)carmodel{
    BOOL retVal = NO;
    NSManagedObjectContext *context = [APPDELEGATE managedObjectContext1];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Car" inManagedObjectContext:context];
    request.entity = entity;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@ && cardID = %@",carmodel.userID,carmodel.carID];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *arr = [context executeFetchRequest:request error:&error];
    if (arr.count) {
        for (Car *car in arr ) {
            car.userID = carmodel.userID;
            car.carID = carmodel.carID;
            car.carIsDefault = carmodel.carIdDefault;
            car.carName = carmodel.carName;
            car.carNumber = carmodel.carNumber;
            if ([context save:nil]) {
                retVal = YES;
            }
            
        }
    }else{
        NSLog(@"没有检索到对象");
    }
    return retVal;
}


// 查：根据userID查寻该userID对应的所有车辆
-(NSArray *)queryCarInfoByUserID:(NSString *)userID
{
    NSManagedObjectContext *context = [APPDELEGATE managedObjectContext1];
    //建立请求
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    //读取所有Car
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Car" inManagedObjectContext:context];
    request.entity = entity;
    //设置检索条件(不设则默认检索所有Car)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID = %@",userID];
    request.predicate = predicate;
    NSError *error;
    NSMutableArray *listArr = [NSMutableArray new];
    NSArray *arr = [context executeFetchRequest:request error:&error];
    for (Car *car in arr) {
        CarModel *model = [[CarModel alloc]init];
        model.userID = car.userID;
        model.carID = car.carID;
        model.carIdDefault = car.carIsDefault;
        model.carName = car.carName;
        model.carNumber = car.carNumber;
        [listArr addObject:model];
    }
    return listArr;
}


@end
