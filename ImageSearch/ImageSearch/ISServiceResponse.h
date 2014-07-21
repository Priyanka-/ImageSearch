//
//  ISServiceResponse.h
//  ImageSearch
//
//  Created by Joshi, Priyanka on 7/18/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ResponseData.h"

@interface ISServiceResponse : NSObject

@property(nonatomic, strong) ResponseData* responseData;
@property(nonatomic, strong) NSString* responseDetails;
@property(nonatomic) NSInteger responseStatus;

@end