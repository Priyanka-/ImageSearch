//
//  ISResultsViewController.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/25/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISResultsViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

- (id)initWithQuery:(NSString*)query;

@end
