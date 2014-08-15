//
//  ISCollectionViewFlowLayout.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 8/15/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISCollectionViewFlowLayout.h"
#import "ISResultSeparator.h"


@implementation ISCollectionViewFlowLayout


-(void)prepareLayout
{
    // Registers decoration views.
    [self registerClass:[ISResultSeparator class] forDecorationViewOfKind:@"Vertical"];
    [self registerClass:[ISResultSeparator class] forDecorationViewOfKind:@"Horizontal"];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%3 == 2 && [decorationViewKind isEqualToString:@"Vertical"]) {
        // No need for separator; bail out
        return nil;
    }
    // Prepare some variables.
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:indexPath.row+1 inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *nextCellAttributes = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    CGRect baseFrame = cellAttributes.frame;
    CGRect nextFrame = nextCellAttributes.frame;
    
    CGFloat strokeWidth = 2;
    CGFloat spaceToNextItem = 0;
    if (nextFrame.origin.y == baseFrame.origin.y)
        spaceToNextItem = (nextFrame.origin.x - baseFrame.origin.x - baseFrame.size.width);
    
    if ([decorationViewKind isEqualToString:@"Vertical"]) {
        CGFloat padding = 10;
        
        // Positions the vertical line for this item.
        CGFloat x = baseFrame.origin.x + baseFrame.size.width + (spaceToNextItem - strokeWidth)/2;
        layoutAttributes.frame = CGRectMake(x,
                                            baseFrame.origin.y + padding,
                                            strokeWidth,
                                            baseFrame.size.height - padding*2);
    } else {
        // Positions the horizontal line for this item.
        layoutAttributes.frame = CGRectMake(baseFrame.origin.x,
                                            baseFrame.origin.y + baseFrame.size.height,
                                            baseFrame.size.width + spaceToNextItem,
                                            strokeWidth);
    }
    
    layoutAttributes.zIndex = -1;
    return layoutAttributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *baseLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * layoutAttributes = [baseLayoutAttributes mutableCopy];
    
    for (UICollectionViewLayoutAttributes *thisLayoutItem in baseLayoutAttributes) {
        if (thisLayoutItem.representedElementCategory == UICollectionElementCategoryCell) {
              UICollectionViewLayoutAttributes *newLayoutItem = [self layoutAttributesForDecorationViewOfKind:@"Vertical" atIndexPath:thisLayoutItem.indexPath];
                if (newLayoutItem) {
                    [layoutAttributes addObject:newLayoutItem];
                }
                UICollectionViewLayoutAttributes *newHorizontalLayoutItem = [self layoutAttributesForDecorationViewOfKind:@"Horizontal" atIndexPath:thisLayoutItem.indexPath];
                if (newHorizontalLayoutItem) {
                    [layoutAttributes addObject:newHorizontalLayoutItem];
                }
        }
    }
    
    return layoutAttributes;
}




@end
