//
//  ISFooterView.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/29/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISFooterView.h"

@implementation ISFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel* label = [[UILabel alloc] init];
        label.textColor = [UIColor blueColor];
        label.text = NSLocalizedString(@"End of results!", nil);
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [self.contentView addSubview:label];
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
