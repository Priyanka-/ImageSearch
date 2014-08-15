//
//  ISImageFetchOperation.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/8/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISImageFetchOperation.h"

@interface ISImageFetchOperation()
@property(nonatomic, readwrite) NSString* imageUrl;
@property(nonatomic, readwrite) UIImage *image;
@end

@implementation ISImageFetchOperation


- (id) initWithUrl:(NSString *)url delegate:(NSObject<ISImageFetchOperationDelegate> *)delegate{
    self = [super init];
    if (self) {
        _imageUrl = url;
        _delegate = delegate;
    }
    return self;
}

- (void) main {
    if (self.isCancelled || !self.imageUrl || [self.imageUrl isEqualToString:@""]) {
        return;
    }
    NSString* escapedUrl = [self.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    @try {
        NSData* imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:escapedUrl]];
        self.image = [UIImage imageWithData:imgData scale:[UIScreen mainScreen].scale];
        [self.delegate fetchFinished:self.imageUrl image:self.image];
        
    }@catch(NSException* error) {
        //failed to download. TODO: add error handling
    }
  }


@end
