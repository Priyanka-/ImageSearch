//
//  ISResultsViewCell.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/25/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISResultsViewCell.h"
#import "ISImageFetchOperation.h"
#import "ISImageCache.h"

#define kImageViewTag 0x3000

@interface ISResultsViewCell() <ISImageFetchOperationDelegate>

@property UIImageView* imageView;
@property CGSize size;

@end

@implementation ISResultsViewCell


-(CGSize)intrinsicContentSize {
    return self.size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingImg"]];
        _size = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
    }
    return self;
}

#pragma mark cell lifecycle
- (void) prepareForReuse {
   UIImageView* imageView = (UIImageView*) [self.contentView viewWithTag:kImageViewTag];
    [imageView removeFromSuperview];
    self.imageURL = nil;
    self.size = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
 }

#pragma mark custom methods

- (void) setImageURL:(NSString *)imageURL size:(CGSize)size {
     _imageURL = imageURL;
    self.size = size;
    UIImage* image = [[ISImageCache singletonInstance] getImageForUrl:_imageURL];
    if (image) {
        [self setImage:image];
    } else {
        ISImageFetchOperation* imageFetchOperation = [[ISImageFetchOperation alloc] initWithUrl:_imageURL delegate:self];
        [[ISImageCache singletonInstance].operationQueue addOperation:imageFetchOperation];
    }
}

-(void) setImage:(UIImage*)image {
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0.0f, self.size.width, self.size.height);
    [imageView setImage:image];
    imageView.tag = kImageViewTag;
    
    [imageView setBackgroundColor:[UIColor clearColor]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];

}

#pragma mark ISImageFetchOperationDelegate methods

- (void) fetchFinished:(NSString*)imageURL image:(UIImage*)image {
    if (image) {
        [[ISImageCache singletonInstance] setImage:image forUrl:imageURL];
        if ([self.imageURL isEqualToString:_imageURL]) {
            [self setImage:image];
        }
    }
    
}


@end
