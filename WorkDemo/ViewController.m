//
//  ViewController.m
//  WorkDemo
//
//  Created by akixie on 16/12/28.
//  Copyright © 2016年 Aki.Xie. All rights reserved.
//

#import "ViewController.h"

//定义一个枚举
typedef NS_ENUM(NSInteger, OrderType) {
    OrderTypeGet,
    OrderTypeFit
};


void logBlock( int ( ^ theBlock )( void ) )
{
    NSLog( @"Closure var X: %i", theBlock() );
}


//定义block
typedef NSString *(^blockD1)(NSString *paraA);
typedef void (^blockD2)(int a);


@protocol TestDeletage <NSObject>

@optional
-(void)testDeEvent:(NSString*)str;

@end


@interface ViewController ()

//设置成只读
@property(nonatomic,copy,readonly) NSString *orderTitle;

//String，copy与retain的区别
@property (copy, nonatomic) NSString *testStrCopy;
@property (retain, nonatomic) NSString *testStrRetain;

//定义枚举类型
@property(nonatomic,assign) OrderType orderType;

//基本类型使用，应避免使用基本类型(int,float)，建议使Foundation数据类型(NSInteger,NSFloat)，NSUInteger基于64-bit适配
@property(nonatomic,assign) NSUInteger *age;

//在ARC中,在有可能出现循环引用的时候,往往要通过让其中一端使用weak来解决,比如:delegate代理属性
@property(nonatomic,weak) id<TestDeletage> tDeletage;

//weak demo
@property (nonatomic, strong) void(^aBlock)(id obj, NSUInteger idx, BOOL *stop);

//block demo


@end

@implementation ViewController

//instancetype与ID区别
//instancetype的作用，就是使那些非关联返回类型的方法返回所在类的类型
//1、相同点
//都可以作为方法的返回类型
//2、不同点
//①instancetype可以返回和方法所在类相同类型的对象，id只能返回未知类型的对象；
//②instancetype只能作为返回值，不能像id那样作为参数
//
//在ARC(Auto Reference Count)环境下:
//instancetype用来在编译期确定实例的类型,而使用id的话,编译器不检查类型, 运行时检查类型.
//
//在MRC(Manual Reference Count)环境下:
//instancetype和id一样,不做具体类型检查

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
//    [self StringDemo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//NSString，copy与reatin
-(void)StringDemo{
    
    //    assign： 简单赋值，不更改索引计数
    //    copy： 建立一个索引计数为1的对象，然后释放旧对象
    //    retain：释放旧的对象，将旧对象的值赋予输入对象，再提高输入对象的索引计数为1
    //    strong 和 weak 是在arc后引入的关键字，strong类似于retain，引用时候会引用计算+1，
    //    weak相反，不会改变引用计数。
    //    weak和assign都是引用计算不变，两个的差别在于，weak用于object type，就是指针类型，
    
    
    NSMutableString *muStr = [[NSMutableString alloc] initWithString:@"muTest"];
    self.testStrRetain = muStr;
//    self.testStrRetain = muStr;
    
    //查看copy与retain的引用数量
//    NSLog(@"testStrCopy count is %ld", CFGetRetainCount((__bridge CFTypeRef)_testStrCopy));
    
    NSLog(@"_testStrRetain count is %ld",CFGetRetainCount((__bridge CFTypeRef)(_testStrRetain)));
    
    NSLog(@"muStr count is %ld", CFGetRetainCount((__bridge CFTypeRef)muStr));
    

//   1. 接触过C，那么假设你用malloc分配了一块内存，并且把它的地址赋值给了指针a，后来你希望指针b也共享这块内存，于是你又把a赋值给（assign）了b。此时a和b指向同一块内存，请问当a不再需要这块内存，能否直接释放它？答案是否定的，因为a并不知道b是否还在使用这块内存，如果a释放了，那么b在使用这块内存的时候会引起程序crash掉。
//   2. 了解到1中assign的问题，那么如何解决？最简单的一个方法就是使用引用计数（reference counting），还是上面的那个例子，我们给那块内存设一个引用计数，当内存被分配并且赋值给a时，引用计数是1。当把a赋值给b时引用计数增加到2。这时如果a不再使用这块内存，它只需要把引用计数减1，表明自己不再拥有这块内存。b不再使用这块内存时也把引用计数减1。当引用计数变为0的时候，代表该内存不再被任何指针所引用，系统可以把它直接释放掉。
//   3.总结：上面两点其实就是assign和retain的区别，assign就是直接赋值，从而可能引起1中的问题，当数据为int, float等原生类型时，可以使用assign。retain就如2中所述，使用了引用计数，retain引起引用计数加1, release引起引用计数减1，当引用计数为0时，dealloc函数被调用，内存被回收。

    NSString *string = @"origion";
    NSLog(@"string count is %ld", CFGetRetainCount((__bridge CFTypeRef)string));
    NSString *stringCopy = [string copy];
    NSLog(@"stringCopy count is %ld", CFGetRetainCount((__bridge CFTypeRef)stringCopy));
    NSMutableString *stringMCopy = [string mutableCopy];
    NSLog(@"stringMCopy count is %ld", CFGetRetainCount((__bridge CFTypeRef)stringMCopy));
    [stringMCopy appendString:@"!!"];
     NSLog(@"stringMCopy count is %ld", CFGetRetainCount((__bridge CFTypeRef)stringMCopy));
    
     NSLog(@"string count is %ld", CFGetRetainCount((__bridge CFTypeRef)string));
    
//    查看内存可以发现，string和stringCopy指向的是同一块内存区域(又叫apple弱引用weak reference)，此时stringCopy的引用计数和string的一样都为2。而stringMCopy则是我们所说的真正意义上的复制，系统为其分配了新内存，但指针所指向的字符串还是和string所指的一样。
    


//    Copy其实是建立了一个相同的对象，而retain不是：
//    
//    比如一个NSString对象，地址为0×1111，内容为@”STR”
//    
//    Copy到另外一个NSString之后，地址为0×2222，内容相同，新的对象retain为1，旧有对象没有变化
//    
//    retain到另外一个NSString之后，地址相同（建立一个指针，指针拷贝），内容当然相同，这个对象的retain值+1
//    
//    也就是说，retain是指针拷贝，copy是内容拷贝。
    
//    * 使用assign: 对基础数据类型 （NSInteger）和C数据类型（int, float, double, char,等）
//    * 使用copy： 对NSString
//    * 使用retain： 对其他NSObject和其子类
    
//    readonly表示这个属性是只读的，就是只生成getter方法，不会生成setter方法．
//    readwrite，设置可供访问级别
//    retain，是说明该属性在赋值的时候，先release之前的值，然后再赋新值给属性，引用再加1。
//    nonatomic，非原子性访问，不加同步，多线程并发访问会提高性能。注意，如果不加此属性，则默认是两个访问方法都为原子型事务访问。
    
//    retain的实际语法为：
//    
//    - (void)setName:(NSString *)newName {
//        if (name != newName) {
//            [name release];
//            name = [newName retain];
//            // name’s retain count has been bumped up by 1
//        }
//    }
//    对参数进行release旧值，再retain新值
//    
//    文／Peter__Pan（简书作者）
//    原文链接：http://www.jianshu.com/p/158c979f9b30
//    著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
    
}

-(void)weakDemo{
    __weak ViewController *weakSelf = self;
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
-(void)doSomething:(NSUInteger)idx{
    NSLog(@"dodododo");
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
