//
//  ISImageFetcher.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/26/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISImageFetcher.h"

@interface ISImageFetcher()<NSCacheDelegate>

@property(nonatomic) dispatch_queue_t dispatchQueue;
@property(nonatomic) NSMutableSet* runningUrls;
@property(nonatomic) NSMutableSet* cancelledUrls;
@end

@implementation ISImageFetcher



+ (ISImageFetcher*)singletonInstance {
    static ISImageFetcher *theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theInstance = [[ISImageFetcher alloc] init];
    });
    return theInstance;
}

- (id) init {
    self = [super init];
    if (self) {
        cache = [[NSCache alloc] init];
        cache.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            [self respondToLowMemory];
        }];
        _runningUrls = [[NSMutableSet alloc] init];
        _cancelledUrls = [[NSMutableSet alloc] init];
        _dispatchQueue = dispatch_queue_create("ISImageFetcher", DISPATCH_QUEUE_SERIAL);

    }
    return self;
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) respondToLowMemory {
    //purge the cache
    [cache removeAllObjects];
}

- (void)fetchImageForUrl:(NSString *)url success:(void (^)(NSString *url, UIImage *))success failure:(void (^)(NSString *url, NSError *))failure {
    if (!url || [url isEqualToString:@""]) {
        return;
    }
    dispatch_async(self.dispatchQueue, ^{
        // first, check to see if the image exists in the cache
        UIImage *cachedImage = [cache objectForKey:url];
        if (cachedImage) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(url, cachedImage);
                });
            }
            return;
        }
        
        NSString* escapedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedUrl]];
        //   [request setValue:@"application/json, text/javascript; charset=utf-8" forHTTPHeaderField:@"accept"];
        [request setHTTPMethod:@"GET"];
        //[request setValue: @"accept" forHTTPHeaderField:@"applica"];
        
        //send the request asynchronously over a connection
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if ([self.cancelledUrls containsObject:url]) {
                //it was already cancelled, do nothing
                [self.cancelledUrls removeObject:url];
            } else {
                if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            failure(url, error);
                        });
                } else {
                      UIImage *image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
                    //   UIImage *image = [UIImage imageWithData:data];
                 /*   image = [UIImage imageWithCGImage:[image CGImage] scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
                    
                    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
                    [image drawAtPoint:CGPointZero];
                    image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();*/
                    
                  /*  // force JPEG decompression to try to speed things up
                    CGImageRef imageRef = [image CGImage];
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    CGContextRef context = CGBitmapContextCreate(NULL, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), 8, CGImageGetWidth(imageRef) * 4, colorSpace,kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
                    CGColorSpaceRelease(colorSpace);
                    if (context) {
                        CGContextDrawImage(context, (CGRect){{0.0f, 0.0f}, {CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)}}, imageRef);
                        CFRelease(context);
                    }*/
                    
                    [cache setObject:image forKey:url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                            success(url, image);
                    });
                }
            }
        }];
    });

}


- (void)cancelFetchForUrl:(NSString *)url {
    if (!url || [url isEqualToString:@""]) {
        return;
    }
    dispatch_async(self.dispatchQueue, ^{
        [self.cancelledUrls addObject:url];
    });
}

#pragma mark NSCacheDelegate methods

- (void)cache:(NSCache *)cache willEvictObject:(id)obj{
    //TODO: log
}


@end
