//
//  BlockBase.m
//  WorkDemo
//
//  Created by akixie on 17/2/20.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "BlockBase.h"

/*
  
 delegate,block,notification三者区别？
 
 通知：
 “一对多”，在APP中，很多控制器都需要知道一个事件，应该用通知；
 
 delegate：
 1，“一对一”，对同一个协议，一个对象只能设置一个代理delegate，所以单例对象就不能用代理；
 2，代理更注重过程信息的传输：比如发起一个网络请求，可能想要知道此时请求是否已经开始、是否收到了数据、数据是否已经接受完成、数据接收失败
 判断触发委托方法。
 //确定委托是否存在Entered方法
 if([delegate respondsToSelector:@selector(method:)])
 {
 //发送委托方法，方法的参数为用户的输入
 [delegate method:xxx];
 }
 
 block：
 1：写法更简练，不需要写protocol、函数等等
 2，block注重结果的传输：比如对于一个事件，只想知道成功或者失败，并不需要知道进行了多少或者额外的一些信息
 3，block需要注意防止循环引用：
 
 ARC下这样防止：
 __weak typeof(self) weakSelf = self;
 [yourBlock:^(NSArray *repeatedArray, NSArray *incompleteArray) {
 [weakSelf doSomething];
 }];
 
 非ARC
 
 __block typeof(self) weakSelf = self;
 [yourBlock:^(NSArray *repeatedArray, NSArray *incompleteArray) {
 [weakSelf doSomething];
 }];
 
 */

//一般来说公共接口，方法也较多用delegate进行解耦 ，iOS有很多例子如最常用tableViewDelegate，textViewDelegate等。
//异步和简单的回调用block更好 ，iOS有很多例子如常用的网络库AFNetwork等。


void logBlock( int ( ^ theBlock )( void ) )
{
    NSLog( @"Closure var X: %i", theBlock() );
}
//定义block
typedef NSString *(^blockD1)(NSString *paraA);
typedef void (^blockD2)(int a);

@interface BlockBase()

//weak demo
@property (nonatomic, strong) void(^aBlock)(id obj, NSUInteger idx, BOOL *stop);

//block demo

@end

@implementation BlockBase

-(void)doSomething:(NSUInteger)idx{
    NSLog(@"dodododo");
}

-(void)weakDemo{
    __weak BlockBase *weakSelf = self;
    self.aBlock = ^(id obj, NSUInteger idx, BOOL *stop) {
        [weakSelf doSomething:idx];
    };
    
    //    这个例子的区别在于：block被self strong引用。所以结果就是block中引用了self，self引用了block。
    //    那么这个时候，如果你不使用weakself，则self和block永远都不会被释放。
    //
    //    那么是不是遇到block都要使用weakself呢？
    //    当然不是，而且如果全部使用weakself，会出现你想执行block中的代码时，self已经被释放掉了的情况。
    
    NSArray *anArray = @[@"1", @"2", @"3"];
    [anArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self doSomething:idx];
        
        if (idx == 1) {
            
            * stop = YES;//用来停止遍历
            
        }
        
    }];
    //    这种情况下，block中retain了self，当block中的代码被执行完后，self就会被ARC释放。所以不需要处理weakself的情况。
    
    
    //    字典遍历
    NSDictionary *dic =    @{@"姓名":@"Scarlett",
                             
                             @"年龄":@"26",
                             
                             @"性别":@"女"};
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSLog(@"%@======%@",key,obj);
        
    }];
    
}




//block demo
-(void)blockDemo{
    
    
    //1.block定义
    //    回传值 (^名字) (参数列);
    //2.block实现
    //    ^(传入参数列) {行为主体};
    //3.block使用
    
    
    void (^ddd)(int a);
    
    ddd = ^(int aa){
        int b = aa;
        NSLog(@"%d",b);
    };
    
    
    NSString *(^strTest)(NSString *str);
    
    strTest = ^(NSString *str){
        return [NSString stringWithFormat:@"log %@",str];
    };
    
    NSString *resultStr = strTest(@"hehe");
    NSLog(@"%@",resultStr);
    
    NSString *resultStr2 = ^(NSString *str){return [NSString stringWithFormat:@"log %@",str];}(@"hehe");
    NSLog(@"%@",resultStr2);
    
    
    
    void (^ arrayTest) (NSArray *aa);
    
    NSArray *tempArray = @[@"aa",@"bb"];
    
    
    arrayTest = ^(NSArray *temp){
        NSString *str = temp[0];
        NSLog(@"log %@",str);
    };
    
    arrayTest(tempArray);
    
    NSString * ( ^ myBlock )( int );
    
    myBlock = ^( int paramA )
    {
        return [ NSString stringWithFormat: @"Passed number: %i", paramA ];
    };
    
    NSString *ba = myBlock(8);
    NSLog(@"%@",ba);
    
    
    int result = ^(int a) {return a*a;} (5);
    NSLog(@"%d",result);
    
    int (^square)(int);
    square = ^(int a ){return a*a ;}; // 将刚刚Block 实体指定给 square
    
    int resulta =square(5); // 感觉上不就是funtion的用法吗？
    NSLog(@"%d",resulta);
    
    
    
}


@end
