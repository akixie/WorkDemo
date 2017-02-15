//
//  ProBasicVModel.h
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class ProBasicModel;

@interface ProBasicVModel : NSObject


+ (instancetype)pbv_instanceFromModel:(ProBasicModel *)aPbm;
- (instancetype)pbv_instanceFromModel:(ProBasicModel *)aPbm;

/// 将vm于aBindView绑定。
- (void)pbv_bindView:(UIView *)aBindView;

/**********************************************/
/******************* 子类实现 *******************/
/***** 将子类的数据格式化返回，达到数据组装的功能 *****/
/**********************************************/
/// 同步组装view显示内容。
- (id)pbv_bindViewSetValueFilterForKeyPath:(NSString *)keyPath withValue:(id)value;

/// 异步组装view显示内容。
- (void)pbv_bindViewSetValueFilterForKeyPath:(NSString *)keyPath withValue:(id)value async:(void (^) (id value))aAsyncBlock;

/// 将被绑定的view的keyPath和viewModel对应的keyPath进行绑定。
/// 这是同步操作，使用与一般情况，例如label的显示等等。
- (void)pbv_addBindKeyPathForBindView:(NSString *)aBindViewKeyPath withVMKeyPath:(NSString *)aVModelKeyPath;

/// 将被绑定的view的keyPath和viewModel对应的keyPath进行绑定。
/// 这是异步操作，当加载完成后会更新view的对饮keyPath值。
- (void)pbv_asyncAddBindKeyPathForBindView:(NSString *)aBindViewKeyPath withVMKeyPath:(NSString *)aVModelKeyPath;

/// 当用户操作时，需要更改model中的aKeyPath属性时调用。
- (void)pbv_updateKeyPath:(NSString *)aKeyPath usingValue:(id)value;


@end
