//
//  ProBasicSimNetworking.h
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestHomeVModel.h"

@interface ProBasicSimNetworking : NSObject

/// 如果使用的是AFN的话，我的做法是新建一个网络层Tools，对AFN封装。每部分的请求写一个分类，在请求中完成数据的解析与组装。
+ (void)simNetworkingForPage:(int)page withSuccess:(void (^) (NSArray <TestHomeVModel *>*list))aSuccessBlock failed:(void (^) (NSError *error))aFailurBlock;

@end
