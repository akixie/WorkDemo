//
//  Student+Category.h
//  WorkDemo
//
//  Created by akixie on 17/2/20.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "Student.h"

/*
 Objective-C 中的 Category 就是设计模式(装饰模式)的一种具体实现
 
 根据苹果官方文档对 Category 的描述，它的使用场景主要有三个：
 
 1. 给现有的类添加方法；
 2. 将一个类的实现拆分成多个独立的源文件；
 3. 声明私有的方法。
 其中，第 1 个是最典型的使用场景，应用最广泛。
 */

@interface Student (Category)

@property(nonatomic,copy)NSString *firstName;

@end
