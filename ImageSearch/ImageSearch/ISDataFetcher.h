//
//  ISDataFetcher.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/25/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ISDataFetcher : NSObject


typedef enum imageType {
    defaultType,
    face,
    photo,
    clipart,
    lineart
} ImageType;

typedef enum imageColor {
    defaultColor,
    black,
    blue,
    brown,
    gray,
    green,
    orange,
    pink,
    purple,
    red,
    teal,
    white,
    yellow
} ImageColor;


@property(nonatomic, readonly) NSMutableArray* results;
@property(nonatomic, assign, readonly) BOOL reachedEndOfResults;


- (void) fetchResultsForQuery:(NSString*)query success:(void (^)(NSUInteger, NSUInteger)) success;
- (void) fetchResultsForQuery:(NSString*)query color:(ImageColor)color success:(void (^)(NSUInteger, NSUInteger)) success;
- (void) fetchResultsForQuery:(NSString*)query imgtype:(ImageType)imgType success:(void (^)(NSUInteger, NSUInteger))success;
- (void) fetchResultsForQuery:(NSString*)query color:(ImageColor)color imgtype:(ImageType)imgtype success:(void (^)(NSUInteger, NSUInteger)) success;


- (NSString*) imageURLAtIndex:(NSUInteger)index;
-(CGSize) sizeOfImageAtIndex:(NSUInteger) index;

-(CGSize) sizeOfImageAtIndex:(NSUInteger) index availableWidth:(CGFloat)width;

- (void) clearData;

@end
