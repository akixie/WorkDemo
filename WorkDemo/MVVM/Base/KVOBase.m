//
//  KVOBase.m
//  WorkDemo
//
//  Created by akixie on 17/2/16.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "KVOBase.h"

//键值监听KVO (Key Value Observing)
//KVO其实是一种观察者模式，利用它可以很容易实现视图组件和数据模型的分离，
//当数据模型的属性值改变之后作为监听器的视图组件就会被激发，激发时就会回调监听器自身。
//在ObjC中要实现KVO则必须实现NSKeyValueObServing协议，
//不过幸运的是NSObject已经实现了该协议，因此几乎所有的ObjC对象都可以使用KVO。

//在ObjC中使用KVO操作常用的方法如下：
//注册指定Key路径的监听器： addObserver: forKeyPath: options:  context:
//删除指定Key路径的监听器： removeObserver: forKeyPath、removeObserver: forKeyPath: context:
//回调监听： observeValueForKeyPath: ofObject: change: context:

//KVO的使用步骤也比较简单：
//通过addObserver: forKeyPath: options: context:为被监听对象（它通常是数据模型）注册监听器
//重写监听器的observeValueForKeyPath: ofObject: change: context:方法

@implementation KVOBase

-(void)kvoDemo{
    
    //假设当我们的账户余额balance变动之后我们希望用户可以及时获得通知。
    //那么此时Account就作为我们的被监听对象，需要Person为它注册监听（使用addObserver: forKeyPath: options: context:）;
    //而人员Person作为监听器需要重写它的observeValueForKeyPath: ofObject: change: context:方法，
    //当监听的余额发生改变后会回调监听器Person监听方法（observeValueForKeyPath: ofObject: change: context:）。
    
    Personkvo *person1=[[Personkvo alloc]init];
    person1.name=@"aki";
    Accountkvo *account1=[[Accountkvo alloc]init];
    account1.balance=100.0;
    person1.account=account1;
    
    account1.balance=200.0;//注意执行到这一步会触发监听器回调函数observeValueForKeyPath: ofObject: change: context:
    //结果：keyPath=balance,object=<Account: 0x100103aa0>,newValue=200.00,context=(null)
    
    //在上面的代码中我们在给人员分配账户时给账户的balance属性添加了监听，
    //并且在监听回调方法中输出了监听到的信息，同时在对象销毁时移除监听，这就构成了一个典型的KVO应用
}


@end







@interface Accountkvo()

@end

@implementation Accountkvo

//method

@end

@interface Personkvo(){
@private
    int _age;
}

@end

@implementation Personkvo

-(void)showMessage{
    NSLog(@"name=%@,age=%d",_name,_age);
}
#pragma mark 设置人员账户
-(void)setAccount:(Accountkvo *)account{
    _account=account;
    //添加对Account的监听
    [self.account addObserver:self forKeyPath:@"balance" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 覆盖方法
#pragma mark 重写observeValueForKeyPath方法，当账户余额变化后此处获得通知
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"balance"]){//这里只处理balance属性
        NSLog(@"keyPath=%@,object=%@,newValue=%.2f,context=%@",keyPath,object,[[change objectForKey:@"new"] floatValue],context);
    }
}

#pragma mark 重写销毁方法
-(void)dealloc{
    [self.account removeObserver:self forKeyPath:@"balance"];//移除监听
    //[super dealloc];//注意启用了ARC，此处不需要调用
}
@end

