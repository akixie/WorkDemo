//
//  TestHomeVModel.h
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "ProBasicVModel.h"

@interface TestHomeVModel : ProBasicVModel


@property (copy, nonatomic) NSString *simple_remarks;
@property (copy, nonatomic) NSString *score;
@property (copy, nonatomic) NSString *remark;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *director;
@property (copy, nonatomic) NSString *actor;
@property (copy, nonatomic) NSString *poster_url;

@property (copy, nonatomic) NSString *lookPoint;

@property (nonatomic) CGFloat rowHeight;

/// 获取网络数据
+ (void)fetchDataWithPage:(int)page success:(void (^) (NSArray *list))aSuccessBlock;


@end
