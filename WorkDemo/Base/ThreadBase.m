//
//  ThreadBase.m
//  WorkDemo
//
//  Created by akixie on 17/2/21.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "ThreadBase.h"




@interface ThreadBase(){
    int count;
    bool countFinished;
    
}

//BOOL是否多线程安全？我提到对于BOOL类型的property来说，声明为atomic并没有意义，nonatmoic对于BOOL的get，set也是安全的。
@property (nonatomic, assign) BOOL isValid;
//所以，更准确更严格的说法应该是：现阶段的iOS设备软硬件环境下，BOOL的读写是原子的，不过将来不一定，苹果官方和C标准都没有做任何保证。

@end

@implementation ThreadBase


//计算出错
-(void)demo1{
    __block int count1 = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10000; i ++) {
            count1 ++;
        }
    });
    for (int i = 0; i < 10000; i ++) {
        count1 ++;
    }
    
    /*
     最后计算的结果有很大概率小于20000，原因是count ++为非原子操作。
     这也是data race的场景，这种race没有crash也没有memory corruption，因此有些人把这种race称作benign race(良性的race)。
     不过上面提到的WWDC视频中，苹果的工程师说到：
     
     There is No Such Thing as a “Benign” Race
     
     意思是，只要发生data race，就没有良性一说了，因为虽然程序没有crash，但count最后的值还是出错了，这种 错误必然会导致逻辑上的错误，如果这个count值代表的是你银行卡余额，你应该会更加同意苹果工程师的观点。
     

     */

}

//Crash
-(void)demo2{
    NSMutableString* str = [@"" mutableCopy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10000; i ++) {
            [str setString:@"1234567890"];
        }
    });
    for (int i = 0; i < 10000; i ++) {
        [str setString:@"abcdefghigk"];
    }
    
    /*
     这种场景是真正会导致crash和memory corruption的，发生在两个线程同时对同一个变量执行写操作时，
     这也属于data race的场景，一般会出现在对于复杂对象（class或者struct）的多线程写操作中，
     原因是因为写操作本身不是原子的，而且写操作背后会调用更多的内存操作，多线程同时写时，
     会导致这块内存区间处于中间的不稳定状态，进而crash，这是真正的恶性的data race。
     */
}

//乱序
-(void)demo3{
    
    //过去几年Review代码的经历中，看到过不少如下使用公共变量来做多线程同步的，比如：
    
    //thread 1
     count = 10;
     countFinished = true;
    
    //thread 2
    while (countFinished == false) {
        usleep(1000);
    }
    NSLog(@"count: %d", count);
    
    /*
     按理说，count最后会输出值10。可实际上，编译器并不知道thread 2对count和countFinished这两个变量的赋值顺序有依赖，所以基于优化的目的，有可能会调整thread 1中count = 10;和countFinished = true;生成的最后指令的执行顺序，最后也就导致count值输出的时机不对，虽然最后count的值还是10。这也可以看做是一种benign race，因为也不会crash，而是程序的流程出错。而且这种错误的调试及其困难，因为逻辑上是完全正确的，不明白其中缘由的同学甚至会怀疑是系统bug。
     
     遇到这种多线程读写状态，而且存在顺序依赖的场景，不能简单依赖代码逻辑。解决这种data race场景有一个简单办法：加锁，比如使用NSLock，将对顺序有依赖的代码块整个原子化，加锁之所以有用是因为会生成memory barrier，从而避免了编译器优化。
     
     */
}

//内存泄漏
-(void)demo4{
    
//    iOS刚诞生不久时，还没有多少Best Practise，不少人写单例的时候还不会用到dispatch_once_t，而是采用如下直白的写法：
//    Singleton *getSingleton() {
//        static Singleton *sharedInstance = nil;
//        if (sharedInstance == nil) {
//            sharedInstance = [[Singleton alloc] init];
//        }
//        return sharedInstance;
//    }
    
    /*
    这种写法的问题是，多线程环境下，thread A和thread B会同时进入sharedInstance = [[Singleton alloc] init];，Singleton被多创建了一次，MRC环境就产生了内存泄漏。
    
    这是个经典的例子，也是data race的场景之一，其结果是造成额外的内存泄漏，这种race也可以算作是benign的，但也是我们平时编写代码应该避免的。
    
    上面几个是我们写iOS代码比较容易遇到的，还有其他一些就不一一举例了，只要理解了data race的含义都不难分析这些race导致的具体问题。
     */
    
    
    
    /* 正确写法应该是
    
    EaseSDKHelper.h
    @interface EaseSDKHelper : NSObject
    + (instancetype)shareHelper;
    
    EaseSDKHelper.m
    static EaseSDKHelper *helper = nil;
    @implementation EaseSDKHelper
    - (instancetype)init
    {
        self = [super init];
        if (self) {
            [self commonInit];
        }
        return self;
    }
    
    +(instancetype)shareHelper
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            helper = [[EaseSDKHelper alloc] init];
        });
        
        return helper;
    }
    
     #pragma mark - private
    
    - (void)commonInit
    {
        
    }
     
    */


}



@end
