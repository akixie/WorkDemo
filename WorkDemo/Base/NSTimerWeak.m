//
//  NSTimerWeak.m
//  WorkDemo
//
//  Created by akixie on 17/3/2.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "NSTimerWeak.h"

@interface NSTimerWeak ()

@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) id target;

@end

@implementation NSTimerWeak

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats{
    
    NSTimerWeak * timer = [NSTimerWeak new];
    timer.target = aTarget;
    timer.selector = aSelector;
    //-------------------------------------------------------------此处的target已经被换掉了不是原来的VIewController而是TimerWeakTarget类的对象timer
    timer.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timer selector:@selector(fire:) userInfo:userInfo repeats:repeats];
    return timer.timer;
}



-(void)fire:(NSTimer *)timer{
    
    if (self.target) {
        //如何解决使用ARC后出现的PerformSelector may cause a leak because its selector is unknown
        //1.使用宏忽略警告
        //通过使用#pragma clang diagnostic push/pop，你可以告诉Clang编译器仅仅为某一特定部分的代码来忽视特定警告。
//        #pragma clang diagnostic push
//        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [self.target performSelector:self.selector withObject:timer.userInfo];
//        #pragma clang diagnostic pop
        
        //2.使用afterDelay
        //如果在接受范围内，允许在下一个runloop执行，可以这么做。xCode5没问题，但据反映，xCode6的话这个不能消除警告。
        [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0.0];
        
        //原因
        //在ARC模式下，运行时需要知道如何处理你正在调用的方法的返回值。
        //这个返回值可以是任意值，如void,int,char,NSString,id等等。
        //ARC通过头文件的函数定义来得到这些信息。所以平时我们用到的静态选择器就不会出现这个警告。因为在编译期间，这些信息都已经确定。
        /*如：
         [someController performSelector:@selector(someMethod)];
         ...
         - (void)someMethod
         {
         //bla bla...
         }
         */
        
        //而使用[someController performSelector: NSSelectorFromString(@"someMethod")];时
        //ARC并不知道该方法的返回值是什么，以及该如何处理？该忽略？
        //还是标记为ns_returns_retained还是ns_returns_autoreleased?
        
    } else {
        [self.timer invalidate];
    }
}


+ (void)dealloc
{
    NSLog(@"是否已经离去");
}

//使用，在ViewControllder中
/*
 @interface ViewController ()
 
 @property(nonatomic,strong)NSTimer *timer;
 
 @end
 
 @implementation ViewController
 
 - (void)viewDidLoad {
    [super viewDidLoad];
    self.timer =  [NSTimerWeak scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
 }
 
 - (void)update:(NSTimer *)timer
 {
    static NSInteger num = 0;
    num ++;
    NSLog(@"%zd",num);
 }
 
 - (void)dealloc
 {
    [self.timer invalidate];
    NSLog(@"我去了");
 }
 */



@end
