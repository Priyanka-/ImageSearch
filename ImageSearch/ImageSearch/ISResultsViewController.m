//
//  ISResultsViewController.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/25/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISResultsViewController.h"
#import "ISDataFetcher.h"
#import "ISCollectionViewFlowLayout.h"
#import "ISResultsViewCell.h"
#import "ISFooterView.h"

#define kFooterReusableString  @"footer"
#define kCellReusableString    @"cell"

@interface ISResultsViewController () <UISearchBarDelegate>
@property(nonatomic) ISDataFetcher* datafetcher;
@property(nonatomic) NSString* lastSearchTerm;

@end

@implementation ISResultsViewController

- (id)initWithQuery:(NSString*)query
{
    
    UICollectionViewFlowLayout* layout = [[ISCollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = ([[UIScreen mainScreen] applicationFrame].size.width / 12.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        // Custom initialization
        _datafetcher = [[ISDataFetcher alloc] init];
        _lastSearchTerm = query;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
  
    // Regiter custom cell class with the collection view
    [self.collectionView registerClass:[ISResultsViewCell class] forCellWithReuseIdentifier:kCellReusableString];
    [self.collectionView registerClass:[ISFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterReusableString];
    [self invokeDataFetcher];
}

/*
#pragma mark - Navigation

*/

#pragma mark UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.datafetcher.results.count; //dynamic
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    ISResultsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReusableString forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    [cell setImageURL:[self.datafetcher imageURLAtIndex:indexPath.row] size:[self.datafetcher sizeOfImageAtIndex:indexPath.row availableWidth:self.view.bounds.size.width / 4.0f]];
    //[cell putImage];
    return cell;
}

#pragma mark UICollectionViewDelegate methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self invokeDataFetcher];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self invokeDataFetcher];
}


#pragma mark UICollectionViewFlowLayoutDelegate methods


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [self.datafetcher sizeOfImageAtIndex:indexPath.row availableWidth:self.view.bounds.size.width / 4.0f];
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0 && self.datafetcher.reachedEndOfResults) {
        return CGSizeMake(self.view.bounds.size.width, 40.0f);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionFooter] && self.datafetcher.reachedEndOfResults) {
             ISFooterView* footer = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kFooterReusableString forIndexPath:indexPath];
            return footer;
        }
     return nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.collectionView setAlpha:0.0f];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionView reloadData]; // layoutIfNeeded takes time, unfortunately. Could possibly override layoutSubviews method of an overridden collectionView class to reset alpha
                                      // [self.collectionView.collectionViewLayout invalidateLayout]; But reloadData is instantaneous hence a safer bet
    [UIView animateWithDuration:0.5f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];

}

#pragma mark private methods

- (void) invokeDataFetcher {

    [self.datafetcher fetchResultsForQuery:self.lastSearchTerm success:^(NSUInteger responseStartIndex,  NSUInteger responseResultsCount) {
          [UIView setAnimationsEnabled:NO];
             [self.collectionView performBatchUpdates:^{
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
             } completion:^(BOOL finished) {
                 [UIView setAnimationsEnabled:YES];
             }];
        // If the first batch of results does not fill up the screen, make a follow up request immediately to fill up the rest of the screen.
        if (self.collectionView.contentSize.height < self.view.bounds.size.height) {
            [self invokeDataFetcher];
        }
    }];
   }

@end
