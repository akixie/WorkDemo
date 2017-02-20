//
//  RuntimeBase.h
//  WorkDemo
//
//  Created by akixie on 17/2/20.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 runtime是一套比较底层的纯C语言API, 属于1个C语言库, 包含了很多底层的C语言API。
 在我们平时编写的OC代码中, 程序运行过程时, 其实最终都是转成了runtime的C语言代码, runtime算是OC的幕后工作者。
 
 RunTime简称运行时,就是系统在运行的时候的一些机制，其中最主要的是消息机制。
 
 对于C语言，函数的调用在编译的时候会决定调用哪个函数，编译完成之后直接顺序执行，无任何二义性。
 
 参考：http://www.jianshu.com/p/462b88edbe5c
 
 */

@interface RuntimeBase : NSObject

@end
