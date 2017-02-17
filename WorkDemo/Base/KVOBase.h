//
//  KVOBase.h
//  WorkDemo
//
//  Created by akixie on 17/2/16.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//


//我们知道在WPF、Silverlight中都有一种双向绑定机制，如果数据模型修改了之后会立即反映到UI视图上，
//类似的还有如今比较流行的基于MVVM设计模式的前端框架，例如Knockout.js。
//其实在ObjC中原生就支持这种机制，它叫做键值监听KVO

#import <Foundation/Foundation.h>

@interface KVOBase : NSObject

@end



@interface Accountkvo : NSObject

@property (nonatomic,assign) float balance;

@end

@class Accountkvo;
@interface Personkvo : NSObject

@property (nonatomic , copy) NSString *name;
@property (nonatomic,retain) Accountkvo *account;

-(void)showMessage;

@end

