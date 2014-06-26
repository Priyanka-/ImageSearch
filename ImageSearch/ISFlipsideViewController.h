//
//  ISFlipsideViewController.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/25/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISFlipsideViewController;

@protocol ISFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(ISFlipsideViewController *)controller;
@end

@interface ISFlipsideViewController : UIViewController

@property (weak, nonatomic) id <ISFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
