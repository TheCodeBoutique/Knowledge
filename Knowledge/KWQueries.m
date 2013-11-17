//
//  KWQueries.m
//  Knowledge
//
//  Created by Kyle Carriedo on 11/16/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//
#import <Parse/Parse.h>
#import "KWQueries.h"

@implementation KWQueries

+ (KWQueries *)sharedInstance
{
    static KWQueries *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KWQueries alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(PFQuery *)totalPostForCurrentWeek
{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    NSDate *now = [NSDate date];
    
    NSDateComponents *days = [NSDateComponents new];
    [days setDay:1];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *fiveDaysAgo = [cal dateByAddingComponents:days toDate:now options:0];
    
    [query whereKey:@"createdAt" lessThanOrEqualTo:fiveDaysAgo];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user_name"];
    
    return query;
}
@end
