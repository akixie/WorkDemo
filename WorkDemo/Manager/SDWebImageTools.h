//
//  SDWebImageTools.h
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface SDWebImageTools : NSObject

//下载成功后缓存图片
//回调都在主线程
+(void)SDWebImageFromUrl:(NSString*)urlStr progress:(void (^) (NSInteger receivedSize,NSInteger expectedSize))
    aProgressBlock success:(void(^) (UIImage *image)) aSuccessBlock;

@end
