//
//  ISImageFetcher.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/26/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISImageFetcher : NSObject {
@private
NSCache* cache;

}

+ (ISImageFetcher *)singletonInstance;

- (void)fetchImageForUrl:(NSString *)url success:(void (^)(NSString *url, UIImage *))success failure:(void (^)(NSString *url, NSError *))failure;

- (void)cancelFetchForUrl:(NSString *)url;

@end
