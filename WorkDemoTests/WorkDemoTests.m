//
//  WorkDemoTests.m
//  WorkDemoTests
//
//  Created by akixie on 16/12/28.
//  Copyright © 2016年 Aki.Xie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+NilSafe.h"

@interface WorkDemoTests : XCTestCase

@end

@implementation WorkDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testLiteral {
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    NSDictionary *dict = @{
                           nonNilKey: nilVal,
                           nilKey: nonNilVal,
                           };
    XCTAssertEqualObjects([dict allKeys], @[nonNilKey]);
    XCTAssertNoThrow([dict objectForKey:nonNilKey]);
    id val = dict[nonNilKey];
    XCTAssertEqualObjects(val, [NSNull null]);
    XCTAssertNoThrow([val length]);
    XCTAssertNoThrow([val count]);
    XCTAssertNoThrow([val anyObject]);
    XCTAssertNoThrow([val intValue]);
    XCTAssertNoThrow([val integerValue]);
}

- (void)testKeyedSubscript {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    dict[nonNilKey] = nilVal;
    dict[nilKey] = nonNilVal;
    XCTAssertEqualObjects([dict allKeys], @[nonNilKey]);
    XCTAssertNoThrow([dict objectForKey:nonNilKey]);
}

- (void)testSetObject {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    [dict setObject:nilVal forKey:nonNilKey];
    [dict setObject:nonNilVal forKey:nilKey];
    XCTAssertEqualObjects([dict allKeys], @[nonNilKey]);
    XCTAssertNoThrow([dict objectForKey:nonNilKey]);
}

- (void)testArchive {
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    NSDictionary *dict = @{
                           nonNilKey: nilVal,
                           nilKey: nonNilVal,
                           };
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    NSDictionary *dict2 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertEqualObjects([dict2 allKeys], @[nonNilKey]);
    XCTAssertNoThrow([dict2 objectForKey:nonNilKey]);
}

- (void)testJSON {
    id nilVal = nil;
    id nilKey = nil;
    id nonNilKey = @"non-nil-key";
    id nonNilVal = @"non-nil-val";
    NSDictionary *dict = @{
                           nonNilKey: nilVal,
                           nilKey: nonNilVal,
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *expectedString = @"{\"non-nil-key\":null}";
    XCTAssertEqualObjects(jsonString, expectedString);
}

@end
