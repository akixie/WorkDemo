//
//  NSDictionary+NilSafe.h
//  WorkDemo
//
//  Created by akixie on 17/2/20.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>


//Objective-C 里的 NSDictionary 是不支持 nil 作为 key 或者 value 的。但是总会有一些地方会偶然往 NSDictionary 里插入 nil value。

/*
 发 API request 的时候，比如：
 NSDictionary *params = @{
    @"some_key": someValue,
 };
 [[APIClient sharedClient] post:someURL params:params callback:callback];
 
 
 解决1：
 NSDictionary *params = @{
    @"some_key": someValue ?: @"",
 };
 
 解决2：
 NSMutableDictionary *params = [NSMutableDictionary dictionary];
 if (someValue) {
    params[@"some_key"] = someValue;
 }
 以上处理会有几个问题：
 1.冗余代码太多
 2.一不小心就会忘记检查 nil，有些 corner case 只有上线出现 live crash 了才会被发现
 3.我们的 API 大部分是以 JSON 格式传参的，所以一个 nil 的值不论是传空字符串还是不传，在语义上都不是很正确，甚至还可能会导致一些奇怪的 server bug
 
 
 所以我们希望 NSDictionary 用起来是这样的：
 1.插入 nil 的时候不会 crash
 2.插入 nil 以后它对应的 key 的确存在，且能取到值（NSNull）
 3.被 serialize 成 JSON 的时候，被转成 null
 4.让 NSNull 更接近 nil，可以吃任何方法不 crash
 
 参考：http://tech.glowing.com/cn/how-we-made-nsdictionary-nil-safe/

 */

@interface NSDictionary (NilSafe)

@end

@interface NSMutableDictionary (NilSafe)

@end

@interface NSNull (NilSafe)

@end
