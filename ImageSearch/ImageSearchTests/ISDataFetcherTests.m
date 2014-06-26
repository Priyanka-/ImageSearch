//
//  ISDataFetcherTests.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/30/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ISDataFetcher.h"
#import <OCMock/OCMock.h>

@interface ISDataFetcherTests : XCTestCase

//@property(nonatomic) ISDataFetcher* datafetcher;

@end
@implementation ISDataFetcherTests

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

- (void)testDataFetcherInit
{
    ISDataFetcher* datafetcher = [[ISDataFetcher alloc] init];
    XCTAssertNotNil(datafetcher, @"Validating that datafetcher is not nill after init");
}

- (void)testResultsNotNilAfterInit
{
    ISDataFetcher* datafetcher = [[ISDataFetcher alloc] init];
    XCTAssertNotNil(datafetcher.results, @"Validating that datafetcher results array is not nill after init");
    XCTAssertEqual(datafetcher.results.count, 0, @"Validating that datafetcher results array is empty just after init");
}

- (void)testSizeOfImageAtIndex
{
    ISDataFetcher* datafetcher = [[ISDataFetcher alloc] init];
    CGSize size = [datafetcher sizeOfImageAtIndex:1];
    XCTAssertEqual(size.width, CGSizeZero.width, @"Validating that sizeOfImage is returned as 0 when the index is out of bounds");
    XCTAssertEqual(size.height, CGSizeZero.height, @"Validating that sizeOfImage is returned as 0 when the index is out of bounds");
}

- (void)testImageUrlAtIndex
{
    ISDataFetcher* datafetcher = [[ISDataFetcher alloc] init];
    NSString* imgUrl = [datafetcher imageURLAtIndex:1];
    XCTAssertNil(imgUrl, @"Image Url should be Nil when the index is out of bounds.");
}

@end
