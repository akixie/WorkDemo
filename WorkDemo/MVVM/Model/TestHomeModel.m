//
//  TestHomeModel.m
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "TestHomeModel.h"
#import "ProBasicSimNetworking.h"

@implementation TestHomeModel

- (void)dealloc
{
    NSLog(@"TestHomeModel %@",NSStringFromSelector(_cmd));
}

+ (void)fetchDataWithPage:(int)page success:(void (^)(NSArray *))aSuccessBlock
{
    [ProBasicSimNetworking simNetworkingForPage:page withSuccess:aSuccessBlock failed:nil];
}

@end
