//
//  GCDBase.m
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "GCDBase.h"
#import <UIKit/UIKit.h>


//Dispatch Queue(调度队列)
//开发者要做的只是定义想执行的任务并追加到适当的Dispatch Queue中
//“定义想执行的任务”使用Block语法来完成
//Dispatch Queue分为串行和并发两种

//--Serial Dispatch Queue串行
//1.要求等待正在执行的任务完成，再执行下一个
//2.只会创建一个线程来执行任务
//3.不能改变执行顺序或不想并行执行多个任务时
//--Concurrent Dispatch Queue 并发
//1.后面的任务可以不必等待正在执行的任务执行完成就可以开始执行，也就是同时可以执行多个任务
//2.会创建多个线程同时执行多个任务
//3.内核会基于Dispatch Queue中的任务数量、CPU核数和CPU负荷等当前系统状态来决定创建多少个线程和并行执行多少个任务


@implementation GCDBase

-(void)createDemo{
    //创建serial dispatch queue，同步执行的，但多个Serial,Serial queue与Serial queue之间是并发执行的
    //可以创建多个串行队列，串行队列也可以并行执行。决不能随意的大量生产Serial Dispatch Queue。
    dispatch_queue_t serialQueue = dispatch_queue_create("serial", NULL);
    dispatch_async(serialQueue, ^{
        NSLog(@"hello serial dispatch queue");
    });
//    dispatch_release(serialQueue);
    
    //创建concurrent dispatch queue
    //不管创建多少都没有问题，因为Concurrent Dispatch Queue所使用的线程由系统的XNU内核高效管理，不会影响系统性能。
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"hello concurrent dispatch queue");
    });
    
    //全局Global dispatch queue，获取一个全局队列，系统开启的全局线程。用priority指定队列的优先级，而flag作为保留字段备用（一般为0）。
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(globalQueue, ^{
        NSLog(@"");
    });
    
    //返回主队列，也就是UI队列。它一般用于在其它队列中异步完成了一些工作后，需要在UI队列中更新界面。
    //它是全局可用的serial queue
    //系统默认就有一个串行队列main_queue
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"hello main dispatch queue");
    });
    
    
    
    //内存管理
    //由dispatch_queue_create方法生成的Dispatch Queue并不能由ARC来自动管理内存.
    //可以使用dispatch_release、dispatch_retain来手动管理（引用计数式）
    //但在目前看来，所用的OSX-10.8开启的ARC已经不需要再用dispatch_release()来做管理。
    
    //线程安全
    //对于串行队列，每创建一个串行队列，系统就会对应创建一个线程，同时这些线程都是并行执行的，只是在串行队列中的任务是串行执行的。
    //大量的创建串行队列会导致大量消耗内存，这是不可取的做法。串行队列的优势在于他是一个线程，所以在操作一个全局数据时候是线程安全的。
    //当想并行执行而不发生数据竞争时候可以用并行队列操作
    
    //暂停一个队列
    dispatch_suspend(serialQueue);
    //重启一个队列
    dispatch_resume(serialQueue);
    //注意，dispatch_suspend（以及dispatch_resume）在主线程上不起作用
    
    
    
    
}

//常见用法
-(void)commonUse{
    //让你的程序保持响应原则
    //1.不要阻塞主线程
    //2.把工作放到其它线程中做
    //3.做完后更新主线程的UI
    
    //场景1.从网络抓取数据，然后更新UI，我们经常这么做,
    //dispatch_get_global_queue中第二个参数目前系统保留，请设置为0即可。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //long-runing task networking
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //update UI
        });
        
    });
    //dispatch_async() 用来提交block给指定queue进行异步执行，如果成功提交，那么立刻返回，程序继续往下执行。
    //注意，block是定义在stack上的，需要复制到pile上，再执行
    //dispatch_sync() 调用以后等到block执行完以后才返回，会阻塞当前线程。
    //提交block提供同步执行。这个接口会等到block执行结束以后才返回，在主线程这样做是没意义的，主要在子线程上使用。
    
    
    //场景2：死锁了，因为sync同步执行。
    dispatch_queue_t exampleQueue = dispatch_queue_create("xxx.identifier", NULL);
    dispatch_sync( exampleQueue,^{
        printf("I am now deadlocked...\n");
        
    });

    
    
    //普通控制
    //dispatch_once 这个接口可以保证在整个应用程序生命周期中，某段代码只被执行一次

    //dispatch_set_target_queue,可以设置一个dispatch queue的优先级，或指定一个dispatch source相应的事件处理提交到那个queue上
    //注意，只是开始的顺序，如果前面没有按顺序来，这里dispatch_set_target_queue(serialQ,mainQ),让serialQ与主线程的级别一样高，第二个参数是参照物，让第一个线程和参照物的优先级一样
    
    
}

//dispatch_after 这个接口可以让线程等两秒后再给个提示
-(void)dispatchAfterDemo{
    double delaySeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delaySeconds*NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"延迟两秒后弹出" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        // [self presentViewController:alert animated:true completion:nil];
    });
}


//dispatch_apply 执行某段代码若干次，这样做的另一个好处是，处理NSArray中元素的Block并执行，速度更快。
-(void)dispatchApplyDemo{
    NSArray *array = [NSArray arrayWithObjects:@"a",@"b",@"c" ,nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_get_global_queue中第二个参数目前系统保留，请设置为0即可。
    dispatch_apply([array count], queue, ^(size_t index) {
        NSLog(@"%zu:%@",index,[array objectAtIndex:index]);
    });
}

//dispatch group 该机制允许我们监听一组任务是否完成
-(void)dispatchGroupDemo{
    void(^blk0)(void) = ^(void) {
        NSLog(@"blk0 is running...");
    };
    void(^blk1)(void) = ^(void) {
        NSLog(@"blk1 is running...");
    };
    
    void(^blk2)(void) = ^(void) {
        NSLog(@"blk2 is running...");
    };
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t serialQ = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    dispatch_group_async(group, serialQ, blk0);
    dispatch_group_async(group, serialQ, blk1);
    dispatch_group_async(group, serialQ, blk2);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"finished...");
    });
    
}

//dispatch_barrier_async  提交的任务会等它前面的任务执行结束才开始，
-(void)dispatchBarrierDemo{
    //然后它后面的任务必须等它执行完毕才能开始。
    dispatch_queue_t conQueue = dispatch_queue_create("xxx.ConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(conQueue, ^{
        
        [NSThread sleepForTimeInterval:2];
        
        NSLog(@"dispatch_async1");
        
    });
    
    dispatch_async(conQueue, ^{
        
        [NSThread sleepForTimeInterval:4];
        
        NSLog(@"dispatch_async2");
        
    });
    
    dispatch_barrier_async(conQueue, ^{
        
        NSLog(@"dispatch_barrier_async");
        
        [NSThread sleepForTimeInterval:4];
        
    });
    
    dispatch_async(conQueue, ^{
        
        [NSThread sleepForTimeInterval:1];
        
        NSLog(@"dispatch_async3");
        
    });
    
    
}

-(void)doSometing:(NSString*)str{
    NSLog(@"do str:%@",str);
}

-(void)doSomethingArray:(NSArray*)array{
    NSLog(@"对处理完后的数组，再次进行操作");
}

//平行运算
-(void)test01{
    //假定 -doSomethingIntensiveWith: 是线程安全的且可以同时执行多个.
    //一个array通常包含多个元素，这样的话，我们可以很简单地使用GCD来平行运算
    NSArray *array = [[NSArray alloc] initWithObjects:@"a",@"b",@"c",@"d", nil];
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (NSString *str in array) {
        dispatch_async(globalQueue, ^{
            [self doSometing:str];
        });
    }
    
    //操作完数组元素后，还要对操作结果进行其它操作，这时候要用dispatch group,将多个block组成一组以检测这些block全部完成或等待全部完成，
    dispatch_queue_t gQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    for (NSString *str in array) {
        dispatch_group_async(group, gQueue, ^{
            [self doSometing:str];
        });
        
    }
    //dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //等group里的task都执行完后执行notify方法里的内容，相当于把wait方法及之后要执行的代码合并到一起了。
    dispatch_group_notify(group, gQueue, ^{
        [self doSomethingArray:array];
    });
    
    
    //如果doSomethingArray需要在主线程中执行，比如操作GUI，那么
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self doSomethingArray:array];
    });
    
}

-(void)groupasyncDemo{
    dispatch_queue_t disqueue =  dispatch_queue_create("com.shidaiyinuo.NetWorkStudy", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t disgroup = dispatch_group_create();
    //ios中使用gcd让两个线程执行完结束后再去执行另一个线程
    //如下，任务一与任务二完成后，再执行任务三
    dispatch_group_async(disgroup, disqueue, ^{
        NSLog(@"任务一完成");
    });
    dispatch_group_async(disgroup, disqueue, ^{
        sleep(8);
        NSLog(@"任务二完成");
    });
    dispatch_group_notify(disgroup, disqueue, ^{
        NSLog(@"dispatch_group_notify 执行");
        NSLog(@"任务三");
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_group_wait(disgroup, dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
        NSLog(@"dispatch_group_wait 结束");
    });
    
    //向group中放入两个任务(准确讲是将任务加入到了并行队列disqueue中执行，然后队列和group关联当队列上任务执行完毕时group会进行同步)，
    //第二个任务会等待8秒所以第一个任务会先完成；会先打印任务一完成再打印任务二完成，
    //当两个任务都完成时dispatch_group_notify中的block会执行；会接着打印dispatch_group_notify 执行；
    //dispatch_group_wait设置了超时时间为5秒所以它会在5秒后停止等待打印dispatch_group_wait 结束(任务二会等待8秒所以它会在任务二完成前打印)；
    
    /*
     输出结果：
     2017-02-15 15:00:43.793 任务一完成
     2017-02-15 15:00:48.798 dispatch_group_wait 结束
     2017-02-15 15:00:51.795 任务二完成
     2017-02-15 15:00:51.795 dispatch_group_notify 执行
     
     */
}

-(void)groupasyncDemo2{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, concurrentQueue, ^{
        sleep(5);
        NSLog(@"第一个任务完成");
    });
    dispatch_group_async(group, concurrentQueue, ^{
        sleep(6);
        NSLog(@"第二个任务完成");
    });
    dispatch_group_async(group, globalQueue, ^{
        sleep(10);
        NSLog(@"第三个任务完成");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务都完成了");
    });
    //上面的代码里有两个队列一个是我自己创建的并行队列dispatchQueue，
    //另一个是系统提供的并行队列globalQueue；
    //dispatch_group_notify会等这两个队列上的任务都执行完毕才会执行自己的代码块。
    
    /*
     输出结果：
     2017-02-15 15:17:51.261 第一个任务完成
     2017-02-15 15:17:52.261 第二个任务完成
     2017-02-15 15:17:56.266 第三个任务完成
     2017-02-15 15:17:56.266 任务都完成了
     
     */
    
}

@end
