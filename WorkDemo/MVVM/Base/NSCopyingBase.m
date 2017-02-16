//
//  NSCopyingBase.m
//  WorkDemo
//
//  Created by akixie on 17/2/16.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "NSCopyingBase.h"

//如果要用copy或mutableCopy方法复制自己定义的类对象，那么该类必须要实现<NSCopying>或协议。否则将会导致程序崩溃：

//实现<NSCopying>协议就必须要实现copyWithZone方法， 例如B= [A copy]， 其实现过程为：
//首先调用[A copyWithZone:zone];方法创建对象的副本及该对象的引用obj，然后将obj返回并赋值给B。
//如果没有实现copyWithZone:方法，copy方法将会发送copyWithZone:nil消息给类，这样将导致程序的崩溃。
//如果要复制的类的父类实现了<NSCopying>协议，那么在子类实现复制协议时，必须在copyWithZone方法中首先调用父类的copyWithZone方法。

@implementation NSCopyingBase

-(void)demo1{
    Desserts *desserts = [[Desserts alloc] init];
    NSMutableString *huizhou = [NSMutableString stringWithString:@"huizhou"];
    [desserts setProducer:huizhou Price:100];
    
    Desserts *sweets = [desserts copy];
    
    [desserts.producer appendString:@" hello factory"];
    desserts.price++;
    
    NSLog(@"About desserts:%@", desserts);
    NSLog(@"About sweets:  %@", sweets);
    //控制台输出：
    //2014-01-31 17:56:40.178 Chocolate[3093:303] About desserts:Producer = huizhou hello factory, Price = 101
    //2014-01-31 17:56:40.179 Chocolate[3093:303] About sweets:  Producer = huizhou hello factory, Price = 100
    

    //由于price是基本数据类型变量，所以这里的赋值使得sweets和desserts的price属性在内存中是不同的变量。
    //所以desserts.price++并不会对sweets的price造成影响。
    
    //由于producer是指针变量，而在copy时，复制成员producer只是简单的赋值，
    //因此desserts.producer和sweets.producer指向同一个NSMutableString对象，故两个对象的producer输出一致。
    
    //明显，这并不能达到我们想要的深复制对象内容的目的，因此对于可变对象，应该在复制属性时进行copy操作：
    
    // desserts.producer = self.producer;改为 desserts.producer = [self.producer copy];
    //修改后，由于NSMutableString对象的copy是深复制，所以复制后的desserts和sweets指向两个不同的对象：
    //2014-01-31 18:01:14.803 Chocolate[3106:303] About desserts:Producer = huizhou hello factory, Price = 101
    //2014-01-31 18:01:14.805 Chocolate[3106:303] About sweets:  Producer = huizhou, Price = 100

}

@end


@implementation Desserts

- (void)setProducer:(NSMutableString *)theProducer Price:(NSUInteger)thePrice {
    self.producer = theProducer;
    self.price    = thePrice;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Producer = %@, Price = %lu", self.producer, self.price];
}

- (id)copyWithZone:(NSZone *)zone {
    Desserts *desserts = [[Desserts allocWithZone:zone] init];
    desserts.producer  = self.producer;
    desserts.price     = self.price;
    
    //需要特别注意的是， 在copy协议中：
    
    //desserts.producer = self.producer;
    //desserts.price    = self.price;
    //这里的producer是strong特性的对象，
    //而price是assing特性的基本数据类型变量。
    //在复制后，sweets和desserts指向两个不同的Desserts对象。
    
    return desserts;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    Desserts *desserts = [[Desserts allocWithZone:zone] init];
    desserts.producer  = self.producer;
    desserts.price     = self.price;
    return desserts;
}

@end
