//
//  CoreAnimationBase.h
//  WorkDemo
//
//  Created by akixie on 17/2/23.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreAnimationBase : NSObject

+(CoreAnimationBase*)shareCoreAnimationBase;

//iOS动画的调用方式,1.UIView 代码块调用,2.UIView [begin commit]模式,3.使用Core Animation中的类
-(void)animationCall;

/**
 *  位移动画演示,animationWithKeyPath:@"position" fromValue,toValue,duration
 */
-(void)positionAnimation:(UIView*)_demoView;

/**
 *  透明度动画,[CABasicAnimation animationWithKeyPath:@"opacity"]
 */
-(void)opacityAniamtion:(UIView*)_demoView;

/**
 *  缩放动画,[CABasicAnimation animationWithKeyPath:@"transform.scale"];
 */
-(void)scaleAnimation:(UIView*)_demoView;

/**
 *  旋转动画,[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转
 */
-(void)rotateAnimation:(UIView*)_demoView;

/**
 *  背景色变化动画,[CABasicAnimation animationWithKeyPath:@"backgroundColor"];
 */
-(void)backgroundAnimation:(UIView*)_demoView;

//关键帧动画（CAKeyframeAnimation）,会使用一个NSArray保存一组关键帧,围绕轨迹数组实现动画效果
-(void)keyframeAnimation:(UIView*)_demoView;

/**
 *  path动画
 */
-(void)pathAnimation:(UIView*)_demoView;

/**
 *  抖动效果
 */
-(void)shakeAnimation:(UIView*)_demoView;

@end
