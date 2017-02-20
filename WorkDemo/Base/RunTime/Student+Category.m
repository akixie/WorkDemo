//
//  Student+Category.m
//  WorkDemo
//
//  Created by akixie on 17/2/20.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "Student+Category.h"
#import <objc/runtime.h>

@implementation Student (Category)

const char name;

- (void)setFirstName:(NSString *)firstName
{
    objc_setAssociatedObject(self, &name, firstName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)firstName
{
    return  objc_getAssociatedObject(self, &name);
}

@end
