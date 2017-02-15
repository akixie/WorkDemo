//
//  TestHomeModel.h
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "ProBasicModel.h"

@interface TestHomeModel : ProBasicModel

@property (nonatomic , copy) NSString              * simple_remarks;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic)        long                    total_schedule;
@property (nonatomic , copy) NSString              * duration;
@property (nonatomic , copy) NSString              * longs;
@property (nonatomic , copy) NSString              * director;
@property (nonatomic , copy) NSString              * score;
@property (nonatomic , copy) NSString              * version;
@property (nonatomic , copy) NSString              * detail;
@property (nonatomic)        int                     date_status;
@property (nonatomic , copy) NSString              * year;
@property (nonatomic , copy) NSString              * poster_url;
@property (nonatomic , copy) NSString              * wantCount;
@property (nonatomic , copy) NSString              * date_des;
@property (nonatomic)        BOOL                    will_flag;
@property (nonatomic , copy) NSString              * poster_url_size3;
@property (nonatomic , copy) NSString              * seenCount;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * discount_des;
@property (nonatomic , copy) NSString              * date;
@property (nonatomic)        long                    total_cinema;
@property (nonatomic , copy) NSString              * scoreCount;
@property (nonatomic , copy) NSString              * tags;
@property (nonatomic , copy) NSString              * month;
@property (nonatomic)        int                     prevue_status;
@property (nonatomic , copy) NSString              * en_name;
@property (nonatomic)        BOOL                    buy_flag;
@property (nonatomic , copy) NSString              * actor;
@property (nonatomic , copy) NSString              * coverid;

@property (nonatomic, copy)  NSArray               * recommended_news;

+ (void)fetchDataWithPage:(int)page success:(void (^) (NSArray *list))aSuccessBlock;

@end
