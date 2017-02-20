//
//  RuntimeBase.m
//  WorkDemo
//
//  Created by akixie on 17/2/20.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "RuntimeBase.h"
#import "Student.h"
#import "Student+Category.h"
#import <objc/runtime.h>

@implementation RuntimeBase

//动态变量控制
- (void)ChangeVariable {
    Student *student = [Student new];
    student.name = @"乔布斯";
    NSLog(@"%@",student.name);//乔布斯
    
    
    unsigned int count;
    Ivar *ivar = class_copyIvarList([student class], &count);
    for (int i = 0; i< count; i++) {
        Ivar var = ivar[i];
        const char *varName = ivar_getName(var);
        NSString *name = [NSString stringWithCString:varName encoding:NSUTF8StringEncoding];
        if ([name isEqualToString:@"_name"]) {
            object_setIvar(student, var, @"Steve Jobs");
            break;
        }
    }
    
    NSLog(@"%@",student.name);//Steve Jobs
    
}

//1.void的前面没有+、-号，因为只是C的代码。
//2.必须有两个指定参数(id self,SEL _cmd)
void happyNewYear(id self, SEL _cmd){
    NSLog(@"新年快乐");
}

-(void)jump{
    NSLog(@"jump...");
}

//动态添加方法
- (void)addMethod
{
    Student *student = [Student new];
    student.name = @"乔布斯";
    //参数说明：
    //(IMP)happyNewYear 意思是happyNewYear的地址指针;
    //"v@:" 意思是，v代表无返回值void，如果是i则代表int；@代表 id sel; : 代表 SEL _cmd;
    //“v@:@@” 意思是，两个参数的没有返回值。
    class_addMethod([student class], @selector(jump), (IMP)happyNewYear, "v@:");
    [student performSelector:@selector(jump)];
    
    //输出结果：新年快乐
}


//动态为Category扩展加属性
- (void)addExtentionProperty
{
    Student *student = [Student new];
    student.name = @"乔布斯";
    
    NSLog(@"添加属性firstName结果前%@",student.firstName);
    
    student.firstName = @"Steve";
    NSLog(@"添加属性firstName结果:%@ ",student.firstName);//添加属性firstName结果:Steve
    
}

//动态交换方法实现
- (IBAction)exchangeMethod
{
    Student *student = [Student new];
    student.name = @"乔布斯";
    
    NSLog(@"交换方法前");
    [student eat];
    [student sleep];
    
    NSLog(@"----------交换方法实现-----------");
    Method m1 = class_getInstanceMethod([student class], @selector(eat));
    Method m2 = class_getInstanceMethod([student class], @selector(sleep));
    method_exchangeImplementations(m1, m2);
    
    [student eat];
    [student sleep];
    
    /*
     输出结果:
     2016-02-22 11:30:10.068 Day2016-02-04[9424:1014697] 乔布斯吃饭了
     2016-02-22 11:30:10.069 Day2016-02-04[9424:1014697] 乔布斯睡觉了
     2016-02-22 11:30:10.069 Day2016-02-04[9424:1014697] ----------交换方法实现-----------
     2016-02-22 11:30:10.070 Day2016-02-04[9424:1014697] 乔布斯睡觉了
     2016-02-22 11:30:10.070 Day2016-02-04[9424:1014697] 乔布斯吃饭了
     */
}


@end
