//
//  ByLocationViewController.h
//  Test2MBTA
//
//  Created by Rahul Puri on 12/9/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ByLocationViewController : UIViewController <CLLocationManagerDelegate,NSXMLParserDelegate, MKMapViewDelegate>{
    CLLocationManager *locationManager;
}
-(id)initParser;

@end
