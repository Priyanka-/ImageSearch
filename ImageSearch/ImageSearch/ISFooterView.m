//
//  ISFooterView.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/29/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISFooterView.h"

@implementation ISFooterView

#define kLabelTag 0x6003

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel* label = [[UILabel alloc] init];
        label.textColor = [UIColor blueColor];
        label.text = NSLocalizedString(@"EndOfResultsText", nil);
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [self.contentView addSubview:label];
        self.backgroundColor = [UIColor grayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange:) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) localeDidChange:(NSNotification*) notification {
    UIView* view = [self.contentView viewWithTag:kLabelTag];
    if ([view isKindOfClass:[UILabel class]]) {
        ((UILabel*)view).text = NSLocalizedString(@"EndOfResultsText", nil);
        [view setNeedsLayout];
    }
}

@end
