//
//  ISResultsViewCell.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/25/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISResultsViewCell.h"
#import "ISImageFetcher.h"

#define kImageViewTag 0x3000

@interface ISResultsViewCell ()

@property UIImageView* imageView;


@end

@implementation ISResultsViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingImg"]];
    }
    return self;
}

#pragma mark cell lifecycle
- (void) prepareForReuse {
   UIImageView* imageView = (UIImageView*) [self.contentView viewWithTag:kImageViewTag];
    [imageView removeFromSuperview];
    self.imageURL = nil;
 }

#pragma mark custom methods

- (void) setImageURL:(NSString *)imageURL size:(CGSize)size {
    [[ISImageFetcher singletonInstance] cancelFetchForUrl:_imageURL];
    _imageURL = imageURL;
    [[ISImageFetcher singletonInstance] fetchImageForUrl:imageURL
                                               success:^(NSString *url, UIImage *image) {
                                                   if ([_imageURL isEqualToString:url]) {
                                                        UIImageView* imageView = [[UIImageView alloc] init];
                                                       imageView.frame = CGRectMake(0, 0.0f, size.width, size.height);
                                                       [imageView setImage:image];
                                                       imageView.tag = kImageViewTag;

                                                       [imageView setBackgroundColor:[UIColor clearColor]];
                                                       imageView.contentMode = UIViewContentModeScaleAspectFit;
                                                       [self.contentView addSubview:imageView];

                                                   }
                                               }
                                               failure:nil];
}


@end
