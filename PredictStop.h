//
//  PredictStop.h
//  Test2MBTA
//
//  Created by Rahul Puri on 12/8/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PredictStop : NSObject

@property (strong, nonatomic) NSString *direction;
@property (strong, nonatomic) NSString *epochTime;
@property (strong, nonatomic) NSString *predictedTime;

@end
