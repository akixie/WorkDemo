//
//  KVCBase.h
//  WorkDemo
//
//  Created by akixie on 17/2/16.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

//键值编码KVC.Key Value Coding（简称KVC）

@interface KVCBase : NSObject

@end


@interface Account : NSObject

@property (nonatomic,assign) float balance;

@end

@class Account;
@interface Person : NSObject

@property (nonatomic , copy) NSString *name;
@property (nonatomic,retain) Account *account;

-(void)showMessage;

@end



//kvc @count,@avg,@sum,@max,@min
@interface ProductApple : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, copy) NSString *launchDate;

@end


//-----kvc demo2----

@interface Dog : NSObject

@property (nonatomic, copy) NSString *name; //名字
@property (nonatomic, assign) int number; //数量

@end

@class Dog;

@interface Person2 : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;

@property (nonatomic, strong) Dog *dog;
@property (nonatomic, strong) NSArray *dogs;

- (void)printHeight;
@end


//-----kvc demo3------KVC与容器类(集合代理对象)
@interface ElfinsArray : NSObject
@property (assign ,nonatomic) NSUInteger count;

- (NSUInteger)countOfElfins;

- (id)objectInElfinsAtIndex:(NSUInteger)index;
@end


