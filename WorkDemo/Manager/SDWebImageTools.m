//
//  SDWebImageTools.m
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "SDWebImageTools.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"

@implementation SDWebImageTools

+ (void)SDWebImageFromUrl:(NSString *)urlStr progress:(void (^)(NSInteger, NSInteger))aProgressBlock success:(void (^)(UIImage *))aSuccessBlock
{
    UIImage *imageFormCache = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    if (imageFormCache) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (aSuccessBlock) {
                aSuccessBlock(imageFormCache);
            }
        });
    }else{
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (aProgressBlock) {
                aProgressBlock(receivedSize, expectedSize);
            }
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[SDImageCache sharedImageCache] storeImage:image forKey:urlStr];
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (aSuccessBlock) {
                    aSuccessBlock(imageFormCache);
                }
            });
            
        }];
    }
}

@end
