//
//  PredictionViewController.h
//  Test2MBTA
//
//  Created by Rahul Puri on 12/8/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PredictStop.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface PredictionViewController : UIViewController
<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UITextView *predictTextView;

@property (strong, nonatomic) PredictStop *predictStop;
@property (strong,nonatomic) NSMutableArray *predictArray;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *mapToolBar;

@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;

@property (strong, nonatomic) NSString* stopName;

@end
