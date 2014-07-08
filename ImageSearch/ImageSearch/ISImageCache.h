//
//  ISImageCache.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/8/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISImageCache : NSObject

@property(nonatomic, readonly) NSOperationQueue* operationQueue;

+ (ISImageCache*)singletonInstance;
- (UIImage*) getImageForUrl:(NSString*)imageUrl;
- (void) setImage:(UIImage*) image forUrl:(NSString*)imageUrl;
@end