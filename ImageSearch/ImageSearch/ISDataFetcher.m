//
//  ISDataFetcher.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/25/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISDataFetcher.h"
#import "ISImageCache.h"
#import "ISServiceResponse.h"
#import "NSObject+IsaacJSONToObject.h"
#import "Result.h"

@interface ISDataFetcher()
@property(nonatomic) NSString* currentQuery;
@property(nonatomic, readwrite) NSMutableArray* results; //array of results
@property(nonatomic) NSMutableURLRequest* currentRequest;
@property(nonatomic, assign, readwrite) BOOL reachedEndOfResults;

@end

@implementation ISDataFetcher

const NSString* serverURL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=xxlarge&rsz=8&q=";

- (id) init {
    self = [super init];
    if (self) {
        _results = [[NSMutableArray alloc] initWithCapacity:64];
        _reachedEndOfResults = NO;
    }
    return self;
}

- (NSString*) imageURLAtIndex:(NSUInteger)index {
    if (index < self.results.count) {
        Result *result = self.results[index];
        return result.tbUrl;
    }
    return nil;
}

-(CGSize) sizeOfImageAtIndex:(NSUInteger) index {
    if (index < self.results.count) {
        Result *result = self.results[index];
        CGFloat height = result.tbHeight; //in pixels
        CGFloat width = result.tbWidth;
        return CGSizeMake(width, height);
    }
    return CGSizeZero;
}

-(CGSize) sizeOfImageAtIndex:(NSUInteger) index availableWidth:(CGFloat)width{
    CGSize size = [self sizeOfImageAtIndex:index];
    
    CGFloat height = (size.width == 0.0f) ? 0.0f : (size.height * width)/size.width;
    
    if (height == 0.0f) {
        // assume availableWidth won't be zero for practical purposes
        height = width;
        
    }

    
    return CGSizeMake(width, height);
}


- (void)sendRequest:(NSString *)query success:(void (^)(NSUInteger, NSUInteger))success {
    //send the request asynchronously over a connection
    [NSURLConnection sendAsynchronousRequest:self.currentRequest queue:[ISImageCache singletonInstance].operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
     self.currentRequest = nil;
     
     if (![query isEqualToString:self.currentQuery]) {
         //These results are for a cancelled search; ignore
         return;
     }
     if (data && [data length] > 0 && error == nil) {
         
         
         // Use the data
         NSError* jsonError = nil;
         id value = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves
                                                                    error:&jsonError];
         
         NSDictionary *jsonDict = [value isEqual:[NSNull null]] ? nil : value;
        
         
         if (jsonError) {
             //Handle error while parsing JSON

         }
         if (jsonDict) {
             
             ISServiceResponse *model =
             [jsonDict isc_objectFromJSONWithClass:[ISServiceResponse class]];
             
             if (model) {
                 
                 if (model.responseStatus == 200) {
                     NSArray* responseResults = model.responseData.results;
                     [self.results addObjectsFromArray:responseResults];
                     
                     if (self.results.count == 64) {
                         self.reachedEndOfResults = YES;
                     }
                     NSUInteger currentPageIndex = model.responseData.cursor.currentPageIndex;
                     NSUInteger responseCount = responseResults.count;
                     
                     if (success) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             success(currentPageIndex, responseCount);
                             
                         });
                     }
                 }
                 
            }
             
         }
         
         return;
     } else if ([data length] == 0 && error == nil) {
         // No response and no error! Weird
     }
     else if (error != nil) {
         //Failed..throw up an error
         //  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@":(" message:@"Something bad happened and we have an error. Try again?" delegate:self cancelButtonTitle:@"Go away" otherButtonTitles:@"Try again!", nil];
         
     }
     }];
}

- (void)createAndSendRequest:(NSString *)query requestUrl:(NSString *)requestUrl success:(void (^)(NSUInteger, NSUInteger))success {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request setValue:@"application/json, text/javascript; charset=utf-8" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    //[request setValue: @"accept" forHTTPHeaderField:@"applica"];
    self.currentRequest = request;
    
    [self sendRequest:query success:success];
}

- (void) fetchResultsForQuery:(NSString*)query success:(void (^)(NSUInteger, NSUInteger))success{
    [self fetchResultsForQuery:query color:defaultColor imgtype:defaultType success:success];
}

- (void) fetchResultsForQuery:(NSString*)query color:(ImageColor)color success:(void (^)(NSUInteger, NSUInteger))success{
    [self fetchResultsForQuery:query color:color imgtype:defaultType success:success];
}

- (void) fetchResultsForQuery:(NSString*)query imgtype:(ImageType)imgType success:(void (^)(NSUInteger, NSUInteger))success{
    [self fetchResultsForQuery:query color:defaultColor imgtype:imgType success:success];
}

- (void) fetchResultsForQuery:(NSString*)query color:(ImageColor)color imgtype:(ImageType)imgtype success:(void (^)(NSUInteger, NSUInteger))success{
    if (self.currentRequest || self.reachedEndOfResults) {
        return; //fetch in progress OR no more results
    }
    self.currentQuery = query;
    // escape the query
    NSString* escapedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    //Append all attributes
    NSMutableString* urlWithAttributes = [NSMutableString stringWithFormat:@"%@%@&start=%lu", serverURL, escapedQuery, (unsigned long)self.results.count];
    
    if (color != defaultColor)
        [urlWithAttributes appendFormat:@"&imgcolor=%@", [self imageColorToString:color]];
    
    if (imgtype != defaultType)
        [urlWithAttributes appendFormat:@"&imgtype=%@", [self imageTypeToString:imgtype]];

    [self createAndSendRequest:query requestUrl:urlWithAttributes success:success];
}

- (void) clearData {
    [self.results removeAllObjects];
    self.currentQuery = nil;
    self.currentRequest = nil;
    self.reachedEndOfResults = NO;
}


- (NSString*) imageTypeToString:(ImageType) imgType {
    NSString *result = nil;
    
    switch(imgType) {
        case face:
            result = @"face";
            break;
        case photo:
            result = @"photo";
            break;
        case clipart:
            result = @"clipart";
            break;
        case lineart:
            result = @"lineart";
            break;
        default:
            result = @"unknown";
    }
    
    return result;
}

- (NSString*) imageColorToString:(ImageColor) imgColor {
    NSString *result = nil;
    
    switch(imgColor) {
        case black:
            result = @"black";
            break;
        case blue:
            result = @"blue";
            break;
        case brown:
            result = @"brown";
            break;
        case gray:
            result = @"gray";
            break;
        case green:
            result = @"green";
            break;
        case orange:
            result = @"orange";
            break;
        case pink:
            result = @"pink";
            break;
        case purple:
            result = @"purple";
            break;
        case red:
            result = @"red";
            break;
        case teal:
            result = @"teal";
            break;
        case white:
            result = @"white";
            break;
        case yellow:
            result = @"yellow";
            break;
        default:
            result = @"unknown";
    }
    
    return result;
}


@end
