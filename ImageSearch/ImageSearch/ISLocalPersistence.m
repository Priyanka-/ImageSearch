//
//  ISLocalPersistence.m
//  ImageSearch
//
//  Created by Joshi, Priyanka on 6/29/14.
//  Copyright (c) 2014 testsample. All rights reserved.
//

#import "ISLocalPersistence.h"

#define kSearchHistory @"SearchHistory"

@interface ISLocalPersistence ()
//Keep the persisted search history saved in a cached dictionary
@property NSDictionary* searchHistory;

@end

@implementation ISLocalPersistence


+ (ISLocalPersistence*)singletonInstance {
    static ISLocalPersistence *theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theInstance = [[ISLocalPersistence alloc] init];
    });
    return theInstance;
}

-(id) init {
    self = [super init];
    if (self) {
          self.searchHistory = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSearchHistory];
    }
    return self;
}

- (void) writeToDefaults:(NSDictionary*)dictionary {
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:kSearchHistory];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.searchHistory = dictionary;
}

/*
 We save only last ten searches. We use a dictionary to save the order. We really need a queue, but NSUserDefaults doesn't allow it.
 */
- (void) saveSearch:(NSString *)query{
   if (!self.searchHistory) {
        NSString* number = [NSString stringWithFormat:@"%d",0];
        NSDictionary* dictionary = @{number : query};
        [self writeToDefaults:dictionary];
    } else {
        NSMutableDictionary* mutableSearchHistory = [self.searchHistory mutableCopy];
        
        NSUInteger index = (mutableSearchHistory.count == 10) ? mutableSearchHistory.count - 1 : mutableSearchHistory.count;
        
        NSString* number = [NSString stringWithFormat:@"%lu",(unsigned long)index];
        
        //Save the query
        [mutableSearchHistory setValue:query forKey:number];
        NSDictionary* dictionary = [[NSDictionary alloc] initWithDictionary:mutableSearchHistory];
        [self writeToDefaults:dictionary];
    }
}

- (NSUInteger) numberOfSavedQueries {
    if (!self.searchHistory) {
        return 0;
    }
    return self.searchHistory.count;
}

/* TODO
+ (NSUInteger) indexInReverseOrder:(NSUInteger)index {
    //do magic to fetch in reverse order: largestIndex - index
    NSDictionary* searchHistory = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSearchHistory];
    if (!searchHistory) {
        return 0;
    }
    return (searchHistory.count - 1) - index;
}*/

- (NSString*) queryAtIndex:(NSUInteger) index {
   if (!self.searchHistory) {
        return nil;
    }
    NSString* number = [NSString stringWithFormat:@"%lu",(unsigned long)index];
    return [self.searchHistory valueForKey:number];
}

@end
