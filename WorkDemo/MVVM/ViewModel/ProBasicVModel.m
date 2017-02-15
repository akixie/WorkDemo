//
//  ProBasicVModel.m
//  WorkDemo
//
//  Created by akixie on 17/2/15.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "ProBasicVModel.h"
#import "ProBasicModel.h"
#import <objc/runtime.h>

@interface ProBasicVModel ()

@property (strong, nonatomic) ProBasicModel *pbm;
@property (weak, nonatomic) UIView *bindView;
@property (strong, nonatomic) NSMutableDictionary *bindKeyValues;
@property (strong, nonatomic) NSMutableDictionary *asyncBindKeyValues;

@end

@implementation ProBasicVModel

+ (instancetype)pbv_instanceFromModel:(ProBasicModel *)aPbm
{
    ProBasicVModel *pbv = [[self alloc] pbv_instanceFromModel:aPbm];
    return pbv;
}

- (instancetype)pbv_instanceFromModel:(ProBasicModel *)aPbm
{
    if (!aPbm)
        return nil;
    
    if ([super init]) {
        self.pbm = aPbm;
        [self pbv_addObserveAndSetInitalizerValue];
    }
    return self;
}

- (id)pbv_bindViewSetValueFilterForKeyPath:(NSString *)keyPath withValue:(id)value { return value; }

- (void)pbv_bindViewSetValueFilterForKeyPath:(NSString *)keyPath withValue:(id)value async:(void (^) (id value))aAsyncBlock
{
    if (aAsyncBlock)
        aAsyncBlock(value);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    // 更新viewModel的属性
    __block id value = change[NSKeyValueChangeNewKey];
    [self setValue:value forKeyPath:keyPath];
    // 更新被绑定view的显示
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSArray *kps in self.bindKeyValues.allValues) {
            if ([kps containsObject:keyPath]) {
                // 确保在主线程中更新UI
                for (NSString *key in self.bindKeyValues.allKeys) {
                    if ([self.bindKeyValues[key] isEqual:kps]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            value = [self pbv_bindViewSetValueFilterForKeyPath:keyPath withValue:value];
                            [self.bindView setValue:value forKeyPath:key];
                        });
                        return;
                    }
                }
            }
        }
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSArray *kps in self.asyncBindKeyValues.allValues) {
            if ([kps containsObject:keyPath]) {
                for (NSString *key in self.asyncBindKeyValues.allKeys) {
                    if ([self.asyncBindKeyValues[key] isEqual:kps]) {
                        __weak __typeof(self)weakSelf = self;
                        [self pbv_bindViewSetValueFilterForKeyPath:keyPath withValue:value async:^(id value) {
                            [weakSelf.bindView setValue:value forKeyPath:key];
                        }];
                        return;
                    }
                }
            }
        }
    });
}

- (void)dealloc
{
    [self removeObserver];
}

#pragma mark - Private

- (void)pbv_addBindKey:(NSString *)aBindViewKeyPath withVMKeyPath:(NSString *)aVModelKeyPath isAsync:(BOOL)async
{
    NSAssert(self.bindView, @"请先使用[pbv_bindView:]绑定一个view");
    if (!aBindViewKeyPath || !aVModelKeyPath) return;
    if (async) {
        if (!self.asyncBindKeyValues) self.asyncBindKeyValues = [NSMutableDictionary dictionary];
        NSMutableArray *keyValues = self.asyncBindKeyValues[aBindViewKeyPath];
        if (!keyValues) keyValues = [NSMutableArray array];
        if (![keyValues containsObject:aVModelKeyPath]) {
            [keyValues addObject:aVModelKeyPath];
        }else {
            return;
        }
        // 将被绑定view的keyPath和viewModel的keyPath对应
        [self.asyncBindKeyValues setValue:keyValues forKey:aBindViewKeyPath];
        
    }else {
        if (!self.bindKeyValues) self.bindKeyValues = [NSMutableDictionary dictionary];
        NSMutableArray *keyValues = self.bindKeyValues[aBindViewKeyPath];
        if (!keyValues) keyValues = [NSMutableArray array];
        if (![keyValues containsObject:aVModelKeyPath]) {
            [keyValues addObject:aVModelKeyPath];
        }else {
            return;
        }
        // 将被绑定view的keyPath和viewModel的keyPath对应
        [self.bindKeyValues setValue:keyValues forKey:aBindViewKeyPath];
    }
}

- (void)removeObserver
{
    NSArray *pbmProperties = allProperties(self.pbm.class);
    [allProperties(self.class) enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([pbmProperties containsObject:keyPath]) {
            // 移除观察者
            [self.pbm removeObserver:self forKeyPath:keyPath context:nil];
        }
    }];
    /****************************************************************************************************
     ****************************************************************************************************
     // 移除所有的观察者
     [self.bindKeyValues.allValues enumerateObjectsUsingBlock:^(NSArray *keyPaths, NSUInteger idx, BOOL * _Nonnull stop) {
     for (NSString *keyPath in keyPaths) {
     [self.pbm removeObserver:self forKeyPath:keyPath context:nil];
     }
     }];
     [self.asyncBindKeyValues.allValues enumerateObjectsUsingBlock:^(NSArray *keyPaths, NSUInteger idx, BOOL * _Nonnull stop) {
     for (NSString *keyPath in keyPaths) {
     [self.pbm removeObserver:self forKeyPath:keyPath context:nil];
     }
     }];
     // 移除关联显示keyPath
     [self.bindKeyValues removeAllObjects];
     [self.asyncBindKeyValues removeAllObjects];
     self.bindKeyValues = self.asyncBindKeyValues = nil;
     ****************************************************************************************************
     ****************************************************************************************************/
    
}

#pragma mark ---

- (void)pbv_addObserveAndSetInitalizerValue
{
    NSArray *pbmProperties = allProperties(self.pbm.class);
    [allProperties(self.class) enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([pbmProperties containsObject:keyPath]) {
            // 注册观察者
            [self.pbm addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
            // KVC赋值，避免readonly
            [self setValue:[self.pbm valueForKeyPath:keyPath] forKeyPath:keyPath];
        }
    }];
}

static const char *bindViewHandlePbv_asso = "hadlePbv";

- (void)pbv_bindView:(UIView *)aBindView
{
    NSAssert(aBindView, @"调用[pbv_bindView:]时，传入的aBindView为nil");
    /*****************************************************************************************
     *****************************************************************************************
     本来不希望vm同时被view持有的，但是在列表的使用场景中，一个view会被多个vm绑定（tableView的复用时）。当其中
     一个vm对应的model改变时，本来view不应该改变，却被改变了，是一种不好的用户体验。
     但是又不愿意将vm暴露在view中，所以使用runtime来降低耦合。
     同时这里也限制了一个问题：一个view只能同时被一个vm绑定。当再次绑定时，会覆盖掉之前的绑定。
     *****************************************************************************************
     *****************************************************************************************/
    ProBasicVModel *handledValue = objc_getAssociatedObject(aBindView, bindViewHandlePbv_asso);
    if (handledValue) {
        // 移除上一个绑定
        ProBasicVModel *handledValue = objc_getAssociatedObject(aBindView, bindViewHandlePbv_asso);
        handledValue.bindView = nil;
    }else {
        objc_setAssociatedObject(aBindView, bindViewHandlePbv_asso, self, OBJC_ASSOCIATION_ASSIGN);
    }
    // 持有这个被绑定的view
    self.bindView = aBindView;
}

- (void)pbv_addBindKeyPathForBindView:(NSString *)aBindViewKeyPath withVMKeyPath:(NSString *)aVModelKeyPath
{
    [self pbv_addBindKey:aBindViewKeyPath withVMKeyPath:aVModelKeyPath isAsync:NO];
    
    id value = [self pbv_bindViewSetValueFilterForKeyPath:aVModelKeyPath withValue:[self valueForKeyPath:aVModelKeyPath]];
    [self.bindView setValue:value forKeyPath:aBindViewKeyPath];
}

- (void)pbv_asyncAddBindKeyPathForBindView:(NSString *)aBindViewKeyPath withVMKeyPath:(NSString *)aVModelKeyPath
{
    [self pbv_addBindKey:aBindViewKeyPath withVMKeyPath:aVModelKeyPath isAsync:YES];
    
    id value = [self valueForKeyPath:aVModelKeyPath];
    __weak __typeof(self)weakSelf = self;
    [self pbv_bindViewSetValueFilterForKeyPath:aVModelKeyPath withValue:value async:^(id value) {
        [weakSelf.bindView setValue:value forKeyPath:aBindViewKeyPath];
    }];
}

- (void)pbv_updateKeyPath:(NSString *)aKeyPath usingValue:(id)value
{
    if (!aKeyPath || !value) return;
    [self.pbm setValue:value forKeyPath:aKeyPath];
}

@end
