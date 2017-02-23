//
//  CALayerBase.m
//  WorkDemo
//
//  Created by akixie on 17/2/23.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "CALayerBase.h"
#import <CoreText/CoreText.h>

CALayerBase *_layerBase;

@implementation CALayerBase

+(CALayerBase*)shareCALayerBase{
    static dispatch_once_t token;
    //dispatch_once 这个接口可以保证在整个应用程序生命周期中，某段代码只被执行一次
    //thread A和thread B会同时进入sharedInstance = [[Singleton alloc] init];，Singleton被多创建了一次，MRC环境就产生了内存泄漏。
    dispatch_once(&token, ^{
        _layerBase = [[CALayerBase alloc] init];
    });
    return _layerBase;
}


//CAEmitterLayer,粒子发射器
//一部分为发射器，设置例子发射的宏观属性，另一部分是粒子单元，用于设置相应的粒子属性
-(void)emitterLayerInit:(UIView*)sView{
    CAEmitterLayer * _fireEmitter;//发射器对象
    //设置发射器
    _fireEmitter=[[CAEmitterLayer alloc]init];
    _fireEmitter.emitterPosition=CGPointMake(sView.frame.size.width/2,sView.frame.size.height-20);
    _fireEmitter.emitterSize=CGSizeMake(sView.frame.size.width-100, 20);
    _fireEmitter.renderMode = kCAEmitterLayerAdditive;
    //发射单元
    //火焰
    CAEmitterCell * fire = [CAEmitterCell emitterCell];
    fire.birthRate=800;
    fire.lifetime=2.0;
    fire.lifetimeRange=1.5;
    fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
    fire.contents=(id)[[UIImage imageNamed:@"Particles_fire.png"]CGImage];
    [fire setName:@"fire"];
    
    fire.velocity=160;
    fire.velocityRange=80;
    fire.emissionLongitude=M_PI+M_PI_2;
    fire.emissionRange=M_PI_2;
    
    fire.scaleSpeed=0.3;
    fire.spin=0.2;
    
    //烟雾
    CAEmitterCell * smoke = [CAEmitterCell emitterCell];
    smoke.birthRate=400;
    smoke.lifetime=3.0;
    smoke.lifetimeRange=1.5;
    smoke.color=[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05]CGColor];
    smoke.contents=(id)[[UIImage imageNamed:@"Particles_fire.png"]CGImage];
    [fire setName:@"smoke"];
    
    smoke.velocity=250;
    smoke.velocityRange=100;
    smoke.emissionLongitude=M_PI+M_PI_2;
    smoke.emissionRange=M_PI_2;
    
    _fireEmitter.emitterCells=[NSArray arrayWithObjects:smoke,fire,nil];
    [sView.layer addSublayer: _fireEmitter];
    
    //参考：https://my.oschina.net/u/2340880/blog/485095
}

//CAGradientLayer是用于色彩梯度展示的layer图层，通过CAGradientLayer，我们可以很轻松的创建出有过渡效果的色彩图
-(void)gradientLayerInit:(UIView*)sView{
    
     /*
     颜色数组，设置我们需要过的的颜色，必须是CGColor对象
     */
    //@property(nullable, copy) NSArray *colors;
    /*
     颜色开始进行过渡的位置
     这个数组中的元素是NSNumber类型，单调递增的，并且在0——1之间
     例如，如果我们设置两个颜色进行过渡，这个数组中写入0.5，则第一个颜色会在达到layer一半的时候开始向第二个颜色过渡
     */
    //@property(nullable, copy) NSArray<NSNumber *> *locations;
    /*
     下面两个参数用于设置渲染颜色的起点和终点 取值范围均为0——1
     默认起点为（0.5 ，0） 终点为（0.5 ，1）,颜色的过渡范围就是沿y轴从上向下
     */
    //@property CGPoint startPoint;
    //@property CGPoint endPoint;
    /*
     渲染风格 iOS中只支持一种默认的kCAGradientLayerAxial，我们无需手动设置
     */
    //@property(copy) NSString *type;
    
    CAGradientLayer * layer = [CAGradientLayer layer];
    layer.colors = @[(id)[UIColor redColor].CGColor,(id)[UIColor blueColor].CGColor,(id)[UIColor greenColor].CGColor];
    layer.locations = @[@0.1,@0.7,@1];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(100, 100);
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
    [sView.layer addSublayer:layer];
    
}

// CAReplocatorLayer是拷贝视图容器，我们可以通过它，将其中的子layer进行拷贝，并进行一些差异处理
-(void)replicatorLayerInit:(UIView*)sView{
    
//    //拷贝的次数
//    @property NSInteger instanceCount;
//    //是否开启景深效果
//    @property BOOL preservesDepth;
//    //当CAReplicatorLayer的子Layer层进行动画的时候，拷贝的副本执行动画的延时
//    @property CFTimeInterval instanceDelay;
//    //拷贝副本的3D变换
//    @property CATransform3D instanceTransform;
//    //拷贝副本的颜色变换
//    @property(nullable) CGColorRef instanceColor;
//    //每个拷贝副本的颜色偏移参数
//    @property float instanceRedOffset;
//    @property float instanceGreenOffset;
//    @property float instanceBlueOffset;
//    //每个拷贝副本的透明度偏移参数
//    @property float instanceAlphaOffset;
    
    CAReplicatorLayer *reLayer = [CAReplicatorLayer layer];
    reLayer.position = CGPointMake(0, 0);
    CALayer * layer= [CALayer layer];
    [reLayer addSublayer:layer];
    [sView.layer addSublayer:reLayer];
    layer.bounds = CGRectMake(0, 0, 20, 20);
    layer.position = CGPointMake(30, 100);
    layer.backgroundColor = [UIColor redColor].CGColor;
    //每个副本向右平移25px
    reLayer.instanceTransform=CATransform3DMakeTranslation(25, 0, 0);
    //如果进行动画，副本延时一秒执行
    reLayer.instanceDelay = 1;
    //拷贝十个副本
    reLayer.instanceCount = 10;
    
}

//CAShapeLayer是图形layer层，我们可以自定义这个层的形状。
-(void)shapeLayerInit:(UIView*)sView{
    
//    path属性为CAShapeLayer设置一个边界路径，
//    @property(nullable) CGPathRef path;
//    //设置图形的填充颜色
//    @property(nullable) CGColorRef fillColor;
//    /*
//     设置图形的填充规则 选项如下：
//     非零填充
//     NSString *const kCAFillRuleNonZero;
//     奇偶填充
//     NSString *const kCAFillRuleEvenOdd;
//     */
//    @property(copy) NSString *fillRule;
//    //设置线条颜色
//    @property(nullable) CGColorRef strokeColor;
//    //设置线条的起点与终点 0-1之间
//    @property CGFloat strokeStart;
//    @property CGFloat strokeEnd;
//    //设置线条宽度
//    @property CGFloat lineWidth;
//    //设置两条线段相交时锐角斜面长度
//    @property CGFloat miterLimit;
//    /*
//     设置线条首尾的外观
//     可选参数如下
//     无形状
//     NSString *const kCALineCapButt;
//     圆形
//     NSString *const kCALineCapRound;
//     方形
//     NSString *const kCALineCapSquare;
//     */
//    @property(copy) NSString *lineCap;
//    /*
//     设置线段的链接方式
//     棱角
//     NSString *const kCALineJoinMiter;
//     平滑
//     NSString *const kCALineJoinRound;
//     折线
//     NSString *const kCALineJoinBevel;
//     */
//    @property(copy) NSString *lineJoin;
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.position=CGPointMake(0,0);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, 0, 100, 100);
    CGPathAddLineToPoint(path, 0, 300, 100);
    CGPathAddLineToPoint(path, 0, 200, 200);
    CGPathAddLineToPoint(path, 0, 100, 100);
    layer.path=path;
    layer.fillColor= [UIColor redColor].CGColor;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.strokeColor = [UIColor blueColor].CGColor;
    layer.strokeStart =0;
    layer.strokeEnd =0.5;
    layer.lineWidth = 5;
    layer.miterLimit = 1;
    layer.lineJoin = kCALineJoinMiter;
    [sView.layer addSublayer:layer];
    
    //除此之外，我们还可以设置边界的线条为虚线，通过下面两个属性：
    //设置线段的宽度为5px 间距为10px
    /*
     这个数组中还可以继续添加，会循环进行设置 例如 5 2 1 3 则第一条线段5px，间距2px，第二条线段1px 间距3px再开始第一条线段
     */
    layer.lineDashPattern = @[@05,@10];
    //设置从哪个位置开始
    layer.lineDashPhase =5;
}

//CATextLayer可以进行文本的绘制
-(void)textLayer:(UIView*)labelView{
//    //渲染的文字字符串
//    @property(nullable, copy) id string;
//    //设置字体
//    @property(nullable) CFTypeRef font;
//    //设置字号
//    @property CGFloat fontSize;
//    //设置文字颜色
//    @property(nullable) CGColorRef foregroundColor;
//    //是否换行
//    @property(getter=isWrapped) BOOL wrapped;
//    /*
//     设置截断模式
//     NSString * const kCATruncationNone;
//     截断前部分
//     NSString * const kCATruncationStart;
//     截断后部分
//     NSString * const kCATruncationEnd;
//     截断中间
//     NSString * const kCATruncationMiddle;
//     */
//    @property(copy) NSString *truncationMode;
//    /*
//     设置文字对齐模式
//     NSString * const kCAAlignmentNatural;
//     NSString * const kCAAlignmentLeft;
//     NSString * const kCAAlignmentRight;
//     NSString * const kCAAlignmentCenter;
//     NSString * const kCAAlignmentJustified;
//     */
//    @property(copy) NSString *alignmentMode;
    
    //create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = labelView.bounds;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [labelView.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    
    //choose some text
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \n elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \n leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc \n elementum, libero ut porttitor dictum, diam odio congue lacus, vel \n fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \n lobortis";
    
    //create attributed string
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:text];
    
    //convert UIFont to a CTFont
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    //set text attributes
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                              };
    
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                };
    //设置ipsum为红色，下划线。
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    
    //release the CTFont we created earlier
    CFRelease(fontRef);
    
    //set layer text
    textLayer.string = string;
    
    //参考：http://www.jianshu.com/p/fa2061819c41
}

@end
