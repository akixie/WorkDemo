//
//  ProBasicModel.m
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "ProBasicModel.h"
#import <objc/runtime.h>

NSArray *allProperties(Class cls)
{
    if (!cls)
        return nil;
    u_int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; ++ i) {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String:propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}


@implementation ProBasicModel

+ (instancetype)pbm_instanceFromResponseDictionary:(NSDictionary *)aDictionary
{
    ProBasicModel *pbm = [[self alloc] pbm_instanceFromResponseDictionary:aDictionary];
    return pbm;
}

- (instancetype)pbm_instanceFromResponseDictionary:(NSDictionary *)aDictionary
{
    if (!aDictionary || ![aDictionary isKindOfClass:[NSDictionary class]])
        return nil;
    
    if ([super init]) {
        NSArray *properties = allProperties(self.class);
        NSArray *keys = aDictionary.allKeys;
        // 模型key-value匹配
        [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([properties containsObject:key]) {
                id value = aDictionary[key];
                [self setValue:value forKeyPath:key];
            }
        }];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copyInstance = [[self.class allocWithZone:zone] init];
    
    NSArray *properties = allProperties(self.class);
    
    [properties enumerateObjectsUsingBlock:^(NSString *aPropertyName, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = [self valueForKeyPath:aPropertyName];
        [copyInstance setValue:value forKeyPath:aPropertyName];
    }];
    
    return copyInstance;
}

@end
