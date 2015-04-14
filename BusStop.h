//
//  BusStop.h
//  Test2MBTA
//
//  Created by Rahul Puri on 12/7/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStop : NSObject
@property (strong, nonatomic) NSString* tag;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* lat;
@property (strong, nonatomic) NSString* lon;
@property (strong, nonatomic) NSString* stopID;
@property (strong, nonatomic) NSString* distance;



@end
