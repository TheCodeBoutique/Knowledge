//
//  KWQueries.h
//  Knowledge
//
//  Created by Kyle Carriedo on 11/16/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWQueries : NSObject

+ (KWQueries *)sharedInstance;

-(PFQuery *)totalPostForCurrentWeek;
@end
