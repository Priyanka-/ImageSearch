//
//  ISLocalPersistenceTests.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/30/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ISLocalPersistence.h"
#import <OCMock/OCMock.h>

@interface ISLocalPersistenceTests : XCTestCase

@end

@implementation ISLocalPersistenceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNumberOfSavedQueriesWithNilDictionary
{
    id userDefaultsMock = OCMClassMock([NSUserDefaults class]);
    [OCMStub([userDefaultsMock dictionaryForKey:@"SearchHistory"]) andReturn:nil];
    
    [OCMStub([userDefaultsMock standardUserDefaults]) andReturn:userDefaultsMock];
    
    NSUInteger savedQueries = [[ISLocalPersistence singletonInstance] numberOfSavedQueries];
    
    XCTAssertEqual(savedQueries, savedQueries, @"Validating that numberOfSavedQueries returns 0 when there is no search history");
}

- (void)testNumberOfSavedQueriesWithNonNilDictionary
{
    NSDictionary* dict = @{@"0":@"cat", @"1":@"dog", @"2":@"random"};
    
    id userDefaultsMock = OCMClassMock([NSUserDefaults class]);
    [OCMStub([userDefaultsMock dictionaryForKey:@"SearchHistory"]) andReturn:dict];
    
    [OCMStub([userDefaultsMock standardUserDefaults]) andReturn:userDefaultsMock];
    
    NSUInteger savedQueries = [[ISLocalPersistence singletonInstance] numberOfSavedQueries];
    
    XCTAssertEqual(savedQueries, dict.count, @"Validating that numberOfSavedQueries returns  a valid value when there is some valid search history");
}

- (void)testQueryAtIndexWithNilDictionary
{
    id userDefaultsMock = OCMClassMock([NSUserDefaults class]);
    [OCMStub([userDefaultsMock dictionaryForKey:@"SearchHistory"]) andReturn:nil];
    
    [OCMStub([userDefaultsMock standardUserDefaults]) andReturn:userDefaultsMock];
    
    NSString* query = [[ISLocalPersistence singletonInstance] queryAtIndex:0];
    
    XCTAssertNil(query, @"Validating that queryAtIndex returns nil when there is no search history");
}

- (void)testQueryAtIndexWithNonNilDictionary
{
    NSDictionary* dict = @{@"0":@"cat", @"1":@"dog", @"2":@"random"};
    
    id userDefaultsMock = OCMClassMock([NSUserDefaults class]);
    [OCMStub([userDefaultsMock dictionaryForKey:@"SearchHistory"]) andReturn:dict];
    
    [OCMStub([userDefaultsMock standardUserDefaults]) andReturn:userDefaultsMock];
    
    NSString* query = [[ISLocalPersistence singletonInstance] queryAtIndex:0];
    
    XCTAssertEqual(query, @"cat", @"Validating that queryAtIndex returns valid query when there is valid search history");
    
    query = [[ISLocalPersistence singletonInstance] queryAtIndex:1];
    XCTAssertEqual(query, @"dog", @"Validating that queryAtIndex returns valid query when there is valid search history");
}

//- (void) testSaveSearch
//{
//    id userDefaultsMock = OCMClassMock([NSUserDefaults class]);
//    [OCMStub([userDefaultsMock dictionaryForKey:@"SearchHistory"]) andReturn:nil];
//
//    [OCMStub([userDefaultsMock synchronize])];
//
//    [OCMStub([userDefaultsMock standardUserDefaults]) andReturn:userDefaultsMock];
//
//    [ISLocalPersistence saveSearch:@"cat"];
//
//}


@end
