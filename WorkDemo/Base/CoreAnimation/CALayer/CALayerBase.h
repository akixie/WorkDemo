//
//  CALayerBase.h
//  WorkDemo
//
//  Created by akixie on 17/2/23.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

//iOS 核心动画 － 专用图层,几种常用Layer的使用

@interface CALayerBase : NSObject

+(CALayerBase*)shareCALayerBase;

//CAEmitterLayer,粒子发射器
//一部分为发射器，设置例子发射的宏观属性，另一部分是粒子单元，用于设置相应的粒子属性
-(void)emitterLayerInit:(UIView*)sView;

//CAGradientLayer是用于色彩梯度展示的layer图层，通过CAGradientLayer，我们可以很轻松的创建出有过渡效果的色彩图
-(void)gradientLayerInit:(UIView*)sView;

// CAReplocatorLayer是拷贝视图容器，我们可以通过它，将其中的子layer进行拷贝，并进行一些差异处理
-(void)replicatorLayerInit:(UIView*)sView;

//CAShapeLayer是图形layer层，我们可以自定义这个层的形状。
-(void)shapeLayerInit:(UIView*)sView;

@end
