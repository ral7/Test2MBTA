//
//  NearByBusStopViewController.h
//  Test2MBTA
//
//  Created by Rahul Puri on 12/11/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface NearByBusStopViewController : UIViewController <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UITableView *busTable;

@property (nonatomic, strong) NSMutableArray *locationBusArray;

@end
