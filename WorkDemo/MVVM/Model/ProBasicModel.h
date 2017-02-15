//
//  ProBasicModel.h
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 获取对象的所有属性 */
extern NSArray *allProperties(Class cls);

@interface ProBasicModel : NSObject <NSCopying>

+ (instancetype)pbm_instanceFromResponseDictionary:(NSDictionary *)aDictionary;

- (instancetype)pbm_instanceFromResponseDictionary:(NSDictionary *)aDictionary;

@end
