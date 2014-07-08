
//
//  ISImageFetchOperation.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/8/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISImageFetchOperationDelegate <NSObject>
- (void) fetchFinished:(NSString*)imageURL image:(UIImage*)image;
@end

@interface ISImageFetchOperation : NSOperation

@property(nonatomic, readonly) NSString* imageUrl;
@property(nonatomic, readonly) UIImage *image;
@property(nonatomic, weak) NSObject<ISImageFetchOperationDelegate> * delegate;

- (id) initWithUrl:(NSString *)url delegate:(NSObject<ISImageFetchOperationDelegate> *)delegate;

@end