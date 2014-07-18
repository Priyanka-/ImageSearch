//
//  ISImageCache.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/8/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISImageCache.h"

@interface ISImageCache()<NSCacheDelegate>
@property(nonatomic) NSCache* cache;
@property(nonatomic, readwrite) NSOperationQueue* operationQueue;
@end

@implementation ISImageCache

+ (ISImageCache*)singletonInstance {
    static ISImageCache *theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theInstance = [[ISImageCache alloc] init];
    });
    return theInstance;
}

- (id) init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        _cache.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [self respondToLowMemory];
        }];
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.name = @"ISImageFetcher";
        _operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    }
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) respondToLowMemory {
    //purge the cache
    [self.cache removeAllObjects];
}

- (UIImage*) getImageForUrl:(NSString*)imageUrl {
    return [self.cache objectForKey:imageUrl];
}

- (void) setImage:(UIImage*) image forUrl:(NSString*)imageUrl {
    [self.cache setObject:image forKey:imageUrl];
}

@end
