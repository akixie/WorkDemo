//
//  ProBasicSimNetworking.m
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "ProBasicSimNetworking.h"
#import "TestHomeModel.h"

@implementation ProBasicSimNetworking

+ (void)simNetworkingForPage:(int)page withSuccess:(void (^) (NSArray <TestHomeVModel *>*list))aSuccessBlock failed:(void (^) (NSError *error))aFailurBlock
{
    NSString *testJsonPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSData *testJsonData = [NSData dataWithContentsOfFile:testJsonPath];
    NSDictionary *testJsonDictionary = [NSJSONSerialization JSONObjectWithData:testJsonData options:NSJSONReadingAllowFragments error:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *testList = testJsonDictionary[@"list"];
        NSMutableArray *vmList = [NSMutableArray array];
        NSInteger from = 0;
        NSInteger end = 0;
        NSInteger count = testList.count;
        if (page == 1) {
            end = count/2-1;
        }else {
            from = count/2;
            end = count-1;
        }
        for (NSInteger i = from; i <= end; ++ i) {
            NSDictionary *dict = testList[i];
            TestHomeModel *hmodel = [TestHomeModel pbm_instanceFromResponseDictionary:dict];
            TestHomeVModel *hvmodel = [TestHomeVModel pbv_instanceFromModel:hmodel];
            [vmList addObject:hvmodel];
        }
        if (aSuccessBlock)
            aSuccessBlock(vmList);
    });
}

@end
