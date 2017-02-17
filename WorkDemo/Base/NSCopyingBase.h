//
//  NSCopyingBase.h
//  WorkDemo
//
//  Created by akixie on 17/2/16.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCopyingBase : NSObject

@end



@interface Desserts : NSObject <NSCopying, NSMutableCopying>

@property (strong, nonatomic) NSMutableString *producer;

@property (assign, nonatomic) NSUInteger price;

- (void)setProducer:(NSMutableString *)theProducer Price:(NSUInteger)thePrice;

@end
