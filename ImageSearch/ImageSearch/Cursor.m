//
//  Cursor.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/21/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cursor.h"
#import "Page.h"

@implementation Cursor

- (Class)isc_classForObject:(id)object inArrayWithKey:(NSString *)key {
    if ([key isEqualToString:@"pages"]) {
        return [Page class];
    }
    return nil;
}


@end