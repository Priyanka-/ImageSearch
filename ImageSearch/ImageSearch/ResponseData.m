//
//  ResponseData.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/18/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseData.h"
#import "Result.h"

@implementation ResponseData

- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key {
    if ([key isEqualToString:@"results"]) {
        return [Result class];
    }
    return nil;
}


@end