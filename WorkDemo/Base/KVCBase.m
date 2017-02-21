//
//  KVCBase.m
//  WorkDemo
//
//  Created by akixie on 17/2/16.
//  Copyright © 2017年 Aki.Xie. All rights reserved.
//

#import "KVCBase.h"

@class Account;
@class Person;


//KVC的操作方法由NSKeyValueCoding协议提供，而NSObject就实现了这个协议，也就是说ObjC中几乎所有的对象都支持KVC操作

//KVC操作方法如下：
//动态设置： setValue:属性值 forKey:属性名（用于简单路径）、setValue:属性值 forKeyPath:属性路径（用于复合路径，例如Person有一个Account类型的属性，那么person.account就是一个复合属性）
//动态读取： valueForKey:属性名 、valueForKeyPath:属性名（用于复合路径）

@implementation KVCBase

-(void)kvc{
    //KVC的消息传递
    //valueForKey:的使用并不仅仅用来取值那么简单，
    //还有很多特殊的用法，集合类也覆盖了这个方法，
    //通过调用valueForKey:给容器中每一个对象发送操作消息，并且结果会被保存在一个新的容器中返回，
    //这样我们能很方便地利用一个容器对象创建另一个容器对象。
    //另外，valueForKeyPath:还能实现多个消息的传递。
    
    NSArray *array = [NSArray arrayWithObjects:@"10.11",@"20.22", nil];
    NSArray *resultArray = [array valueForKey:@"doubleValue.intValue"];
    NSLog(@"result: %@",resultArray);
    /*
     打印结果：
     （
        10，
        20
      ）
     */
    
    
    //KVC还定义了特殊的一些常用操作，使用valueForKeyPath:结合操作符来使用，所定义的keyPath格式入下图所示
    //Left key path:如果有，则代表需要操作的对象路径(相对于调用者)
    //Collection operator:以"@"开头的操作符
    //Right key path:指定被操作的属性
    
    //常规操作符：@avg、@count、@max、@min、@sum
    //对象操作符：@distinctUnionOfObjects、@unionOfObjects
    
    NSArray *values = [array valueForKeyPath:@"@unionOfObjects.value"];
    NSLog(@"values:%@",values);
    //@distinctUnionOfObjects操作符返回被操作对象指定属性的集合并做去重操作，
    //而@unionOfObjects则允许重复。如果其中任何涉及的对象为nil，则抛出异常。
    
    //Array和Set操作符：Array和Set操作符操作对象是嵌套型的集合对象
    
    //@distinctUnionOfArrays、@unionOfArrays
    
    NSArray *values2 = [array valueForKeyPath:@"@distinctUnionOfArrays.value"];
    NSLog(@"values2:%@",values2);
    //同样的，返回被操作集合下的集合中的对象的指定属性的集合，并且做去重操作，
    //而@unionOfObjects则允许重复。如果其中任何涉及的对象为nil，则抛出异常。
    
    //@distinctUnionOfSets
    
    //NSSet *values = [setOfobjectsSets valueForKeyPath:@"@distinctUnionOfSets.value"];
    //返回结果同理于NSArray。
    
}

-(void)kvcDemo{
    Person *person1 = [[Person alloc] init];
    [person1 setValue:@"aki" forKey:@"name"];
    [person1 setValue:@18 forKey:@"age"];//注意，即使一个私有变量仍然可以访问
    
    [person1 showMessage];
    //输出结果：name=aki,age=18
    NSLog(@"person1 name is:%@, age is :%@",person1.name,[person1 valueForKey:@"age"]);
    //输出结果：person1 name is:aki,age is :18
    
    Account *account1 = [[Account alloc] init];
    //注意这一步一定要先给account属性赋值，否则下面按路径赋值无法成功，因为account为nil，
    //当然这一步骤也可以写成:[person1 setValue:account1 forKeyPath:@"account"];
    person1.account = account1;
    
    [person1 setValue:@100.00 forKey:@"account.balance"];
    
    NSLog(@"person1's balance is :%.2f",[[person1 valueForKeyPath:@"account.balance"] floatValue]);
    //结果：person1's balance is :100.00
}






//----------kvc demo2----------------

//使用KVC修改属性：
-(void)testKVC
{
    Person2 *p = [[Person2 alloc] init];
    // 1.property
    p.name = @"rose";
    p.age = 20;
    p.dog = [[Dog alloc] init];
    p.dog.name = @"旺财";
    
    // 2.forkey
    [p setValue:@"jack" forKey:@"name"];
    [p setValue:@30 forKey:@"age"];
    [p.dog setValue:@"旺福" forKey:@"name"];
    
    //Person对象的私有变量_height，对两个key：height\_height，任意一个key都可以修改其属性。
    //（对于height，KVC先从内存中寻找对应名为height的属性，如果找不到就会自动寻找_height，然后进行相应的修改）
    [p setValue:@1.80 forKey:@"height"];
    [p setValue:@1.85 forKey:@"_height"];
    
    // 3.forKeyPath
    // forKeyPath包含了forKey的功能,以后使用forKeyPath就可以了。
    // forKeyPath可以利用‘ . ’运算符一层一层往下查找对象的属性
    [p setValue:@"jack" forKeyPath:@"name"];
    [p setValue:@30 forKeyPath:@"age"];
    
    [p setValue:@"哈士奇" forKeyPath:@"dog.name"];
    
    NSLog(@"%d %@",  p.age,  p.name);
}

//KVC取值
- (void)useKVCGetValue
{
    Person2 *p = [[Person2 alloc] init];
    p.dog = [[Dog alloc] init];
    [p setValue:@"妞妞" forKeyPath:@"dog.name"];
    
    NSLog(@"%@", [p valueForKeyPath:@"dog.name"]);
}

//KVC Tips(技巧)
- (void)test
{
    Person2 *p = [[Person2 alloc] init];
    
    Dog *dog1 = [[Dog alloc] init];
    dog1.name = @"中华田园犬"; // 看家还得看土狗
    dog1.number = 3;
    
    Dog *dog2 = [[Dog alloc] init];
    dog2.name = @"哈士奇"; // 二货，这玩意不能多养
    dog2.number = 1;
    
    Dog *dog3 = [[Dog alloc] init];
    dog3.name = @"柴犬";
    dog3.number = 4;
    
    Dog *dog4 = [[Dog alloc] init];
    dog3.name = @"萨摩耶";
    dog3.number = 3;
    
    Dog *dog5 = [[Dog alloc] init];
    dog5.name = @"黑背";
    dog5.number = 3;
    
    p.dogs = @[dog1, dog2, dog3, dog4, dog5];
    //1. tip1：取指定数组
    // 取出dogs数组中每一个元素的name属性值，放到一个新的数组中返回
    NSArray *dogNames = [p valueForKeyPath:@"dogs.name"];
    NSLog(@"%@",dogNames);
    //2.tip2: @sum(求和)，@avg(求平均数)，更多tip请百度。
    // 计算所有狗的个数
    NSNumber *dogsNumber = [p valueForKeyPath:@"dogs.@sum.number"];
    NSLog(@"%@",dogsNumber);
//    NSLog(@"%@", sumNumber);
    
    
    //总结
    //1.key的值必须正确，如果拼写错误，会出现异常;
    //2.valueForKey\ valueForKeyPath 方法根据key的值读取对象的属性，setValue:forKey:\ forKeyPath: 是根据key的值来写对象的属性；
    //3.推荐使用 valueForKeyPath \ setValue:forKeyPth；
    //4.当key的值是没有定义的，valueForUndefinedKey:这个方法会被调用，如果重写了这个方法，就可以获取错误的key值。
}



//-----kvc demo3------KVC与容器类(集合代理对象)
-(void)kvcDemo3{
    
    
    //对象的属性可以是一对一的，也可以是一对多。
    //属性的一对多关系其实就是一种对容器类的映射。
    //如果有一个名为numbers的数组属性，我们可以使用valueForKey:@"numbers"来获取，这个是没问题的，
    //但KVC还能使用更灵活的方式管理集合。——集合代理对象
    
    ElfinsArray *elfinsArr = [[ElfinsArray alloc] init];
    elfinsArr.count = 3;
    NSArray *elfins = [ElfinsArray valueForKey:@"elfins"];
    //elfins为KVC代理数组
    NSLog(@"%@", elfins);
    //打印结果
    /*
    (
     "小精灵0",
     "小精灵1",
     "小精灵2"
     )
     */
    
    //问题来了
    //ElfinsArray中并没有定义elfins属性，那么elfins数组从何而来？valueForKey:有如下的搜索规则：
    //按顺序搜索getVal、val、isVal，第一个被找到的会用作返回。
    //countOfVal，或者objectInValAtIndex:与valAtIndexes其中之一，这个组合会使KVC返回一个代理数组。
    //countOfVal、enumeratorOfVal、memberOfVal。这个组合会使KVC返回一个代理集合。
    //名为val、isVal、val、isVal的实例变量。到这一步时，KVC会直接访问实例变量，而这种访问操作破坏了封装性，我们应该尽量避免，这可以通过重写+accessInstanceVariablesDirectly返回NO来避免这种行为。
    //上例中我们实现了第二条中的特殊命名函数组合：
    //- (NSUInteger)countOfElfins;
    //- (id)objectInElfinsAtIndex:(NSUInteger)index;
    //这使得我们调用valueForKey:@"elfins"时，
    //KVC会为我们返回一个可以响应NSArray所有方法的代理数组对象(NSKeyValueArray)，
    //这是NSArray的子类，
    //- (NSUInteger)countOfElfins决定了这个代理数组的容量，
    //- (id)objectInElfinsAtIndex:(NSUInteger)index决定了代理数组的内容。
    //本例中使用的key是elfins，同理的如果key叫human，KVC就会去寻找-countOfHuman:

}

@end


@interface Account()

@end

@implementation Account

//method

@end

@interface Person(){
    @private
    int _age;
}

@end

@implementation Person

-(void)showMessage{
    NSLog(@"name=%@,age=%d",_name,_age);
}

@end



//-----kvc demo2----
@implementation Dog

@end
@interface Person2() {
    @private
    double _height;
}

@end
@implementation Person2

- (void)printHeight{
    
}
@end


//-----kvc demo3------KVC与容器类(集合代理对象)
@implementation ElfinsArray
- (NSUInteger)countOfElfins {
    return  self.count;
}
- (id)objectInElfinsAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"小精灵%lu", (unsigned long)index];
}
@end



