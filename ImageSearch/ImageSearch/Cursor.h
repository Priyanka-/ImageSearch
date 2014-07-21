//
//  Cursor.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/21/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

@interface Cursor : NSObject

@property(nonatomic, strong) NSArray* pages;
@property(nonatomic) NSUInteger estimatedResultCount;
@property(nonatomic) NSUInteger currentPageIndex;
@property(nonatomic, strong) NSString* moreResultsUrl;

@end