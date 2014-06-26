//
//  ISLocalPersistence.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/29/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISLocalPersistence : NSObject

+ (ISLocalPersistence*)singletonInstance;

- (void) saveSearch:(NSString*)query;

- (NSUInteger) numberOfSavedQueries;

- (NSString*) queryAtIndex:(NSUInteger) index;

@end
