//
//  ResponseData.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/18/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//


#import "Cursor.h"

@interface ResponseData : NSObject

@property(nonatomic, strong) NSArray* results;
@property(nonatomic, strong) Cursor* cursor;

@end