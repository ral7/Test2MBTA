//
//  BusStopViewController.h
//  Test2MBTA
//
//  Created by Rahul Puri on 12/7/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PredictStop.h"
@interface BusStopViewController : UIViewController<NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *stopTable;

@property (strong, nonatomic) NSMutableDictionary *stopDictionary;
@property (strong, nonatomic) NSMutableArray *tagList;
@property (strong, nonatomic) NSString* routeID;
@property (strong, nonatomic) PredictStop *predictStop;
@property (strong,nonatomic) NSMutableArray *predictArray;

@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;
@property (strong, nonatomic) NSString* stopName;


-(id)initParser;
@end
