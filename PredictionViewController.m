//
//  PredictionViewController.m
//  Test2MBTA
//
//  Created by Rahul Puri on 12/8/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import "PredictionViewController.h"
#import "PredictStop.h"

@interface PredictionViewController ()

@end

@implementation PredictionViewController
@synthesize predictArray;
@synthesize predictStop;
@synthesize mapView;
@synthesize mapToolBar;
@synthesize latitude;
@synthesize longitude;

@synthesize stopName;
int count = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    mapView.showsUserLocation = YES;
    UIBarButtonItem *zoom = [[UIBarButtonItem alloc]initWithTitle:@"Zoom" style:UIBarButtonItemStylePlain target:self action:@selector(zoomIn:)];
    UIBarButtonItem *typeButton = [[UIBarButtonItem alloc]initWithTitle:@"Type" style:UIBarButtonItemStylePlain target:self action:@selector(changeMapType:)];
    
    NSArray *buttons = [[NSArray alloc]initWithObjects:zoom, typeButton, nil];
    mapToolBar.items = buttons;
    
    
    self.predictTextView.text = @"";
    // Do any additional setup after loading the view.
    predictStop = [[PredictStop alloc]init];
    NSString *display = [[NSString alloc]init];
    
    
    
    for(predictStop in predictArray){
        
        if(!(predictStop.direction ==nil)){
 
            NSString *dir = predictStop.direction;
            display = [display stringByAppendingString:@"Destination is:"];
            display = [display stringByAppendingString:@"\r"];
            
            display = [display stringByAppendingString:dir];
        }
            display = [display stringByAppendingString:@"Bus in next: "];
            //display = [display stringByAppendingString:@"\r"];
            count ++;
        
        
        NSString* predictedTime = predictStop.predictedTime;
        display = [display stringByAppendingString:predictedTime];
        display = [display stringByAppendingString:@" minutes"];
        display = [display stringByAppendingString:@"\r"];
        
        
        
        
    }
    
    self.predictTextView.text = display;
    //display =@"";
    count = 0;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
   
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
    CLLocationCoordinate2D annotationCoord;
    float latFloat = [latitude floatValue];
    float longFloat = [longitude floatValue];
    
    annotationCoord.latitude = latFloat;
    annotationCoord.longitude = longFloat;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = stopName;
    annotationPoint.subtitle = @"stop";
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = latFloat;
    newRegion.center.longitude = longFloat;
    newRegion.span.latitudeDelta = 0.03;
    newRegion.span.longitudeDelta = 0.03;
    [mapView addAnnotation:annotationPoint];
    [mapView setRegion:newRegion];
    
    
}
-(void) viewWillDisappear:(BOOL)animated {
    // Your Code
    [super viewWillDisappear:YES];
    [predictArray removeAllObjects];
}

- (void)zoomIn: (id)sender
{
    MKUserLocation *userLocation = mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 0.1, 0.1);
    [mapView setRegion:region animated:NO];
}


- (void) changeMapType: (id)sender
{
    if (mapView.mapType == MKMapTypeStandard)
        mapView.mapType = MKMapTypeSatellite;
    else
        mapView.mapType = MKMapTypeStandard;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
