//
//  ISResultsViewCell.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/25/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISResultsViewCell : UICollectionViewCell

@property(nonatomic) NSString* imageURL;

- (void) setImageURL:(NSString *)imageURL size:(CGSize)size ;

//- (void) putImage;

@end
