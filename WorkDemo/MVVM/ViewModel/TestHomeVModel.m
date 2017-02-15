//
//  TestHomeVModel.m
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "TestHomeVModel.h"
#import "SDWebImageTools.h"
#import "TestHomeModel.h"

@implementation TestHomeVModel


+ (void)fetchDataWithPage:(int)page success:(void (^)(NSArray *))aSuccessBlock
{
    [TestHomeModel fetchDataWithPage:page success:aSuccessBlock];
}

- (id)pbv_bindViewSetValueFilterForKeyPath:(NSString *)keyPath withValue:(id)value
{
    if ([keyPath isEqualToString:@"score"]) {
        return [NSString stringWithFormat:@"%@分",value];
    }else if ([keyPath isEqualToString:@"director"]) {
        return [NSString stringWithFormat:@"%@/%@",value,self.actor];
    }else if ([keyPath isEqualToString:@"actor"]) {
        return [NSString stringWithFormat:@"%@/%@",self.director,value];
    }
    return value;
}

- (void)pbv_bindViewSetValueFilterForKeyPath:(NSString *)keyPath withValue:(id)value async:(void (^)(id))aAsyncBlock
{
    if ([keyPath isEqualToString:@"poster_url"] && aAsyncBlock) {
        [SDWebImageTools SDWebImageFromUrl:value progress:nil success:^(UIImage *image) {
            if (aAsyncBlock)
                aAsyncBlock(image);
        }];
    }
}

- (NSString *)lookPoint
{
    if (!_lookPoint) {
        for (NSDictionary *dict in [self valueForKeyPath:@"pbm.recommended_news"]) {
            if (dict && [dict[@"tag"] isEqualToString:@"看点"]) {
                _lookPoint = dict[@"title"];
                break;
            }
        }
    }
    return _lookPoint;
}

- (CGFloat)rowHeight
{
    if (self.lookPoint) {
        return 120.f;
    }else {
        return 90.f;
    }
}

- (void)dealloc
{
    NSLog(@"TestHomeVModel %@",NSStringFromSelector(_cmd));
}


@end
