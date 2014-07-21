//
//  Result.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/21/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Result : NSObject

@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* contentNoFormatting;
@property (nonatomic, strong) NSString* GsearchResultClass;
@property (nonatomic) NSInteger height; //height in pixels
@property (nonatomic) NSInteger tbHeight; //thumbnail height in pixels
@property (nonatomic, strong) NSString* html;
@property (nonatomic, strong) NSString* originalContextUrl;
@property (nonatomic, strong) NSString* tbUrl;
@property (nonatomic, strong) NSString* unescapedUrl;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* visibleUrl;

@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger tbWidth;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* titleNoFormatting;


@end