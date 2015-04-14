//
//  ByLocationViewController.m
//  Test2MBTA
//
//  Created by Rahul Puri on 12/9/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import "ByLocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BusStop.h"
#import "NearByBusStopViewController.h"
#import "LocationBus.h"

@interface ByLocationViewController ()


@property (weak, nonatomic) IBOutlet MKMapView *mapCurrent;
- (IBAction)getCurrentLocation:(id)sender;
@property(strong, nonatomic) NSString *currentLat;
@property(strong, nonatomic) NSString *currentLong;
@property (weak, nonatomic) IBOutlet UIButton *nearByBusStopButton;
- (IBAction)showNearByBusStopClick:(id)sender;
@property (strong, nonatomic) BusStop* busStop;
@property (strong, nonatomic) NSMutableArray* busStopArray;
@property (strong, nonatomic) NSString* xmlContentFlag;
@property (strong, nonatomic) LocationBus *locationBus;
@property (strong, nonatomic) NSMutableArray* locationBusArray;



@end

@implementation ByLocationViewController
@synthesize mapCurrent;
@synthesize busStop;
@synthesize busStopArray;
@synthesize xmlContentFlag;
@synthesize locationBus;
@synthesize locationBusArray;

-(id) initParser{
    if(self == [super init]){
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapCurrent setDelegate:self];

    busStopArray = [[NSMutableArray alloc]init];
    busStop = [[BusStop alloc]init];
    locationBus = [[LocationBus alloc]init];
    locationBusArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorized ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [locationManager startUpdatingLocation];
        mapCurrent.showsUserLocation = YES;
        
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    [self.nearByBusStopButton setEnabled:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    self.currentLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    self.currentLong = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
}
- (IBAction)getCurrentLocation:(id)sender {
    
   
    // Used for showing a demo location near my school.
    CLLocationCoordinate2D annotationCoord;
    float latFloat = [@"42.338503" floatValue];
    float longFloat = [@"-71.092492" floatValue];
    self.currentLat = @"42.338503";
    self.currentLong = @"-71.092492";
    
    
    
    annotationCoord.latitude = latFloat;
    annotationCoord.longitude = longFloat;

    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = @"Current Location";
   
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = latFloat;
    newRegion.center.longitude = longFloat;
    newRegion.span.latitudeDelta = 0.03;
    newRegion.span.longitudeDelta = 0.03;
    [mapCurrent addAnnotation:annotationPoint];
    [mapCurrent setRegion:newRegion];
    [self.nearByBusStopButton setEnabled:YES];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (pinView ==nil) {
        
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        if([[annotation title] isEqualToString:@"Current Location"]){
        pinView.pinColor = MKPinAnnotationColorRed;
            
            
            
        }
        else{
            pinView.pinColor = MKPinAnnotationColorGreen;
            pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
        }
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        
    }
    return pinView;
}



- (IBAction)showNearByBusStopClick:(id)sender {
    
    NSString *stopApiString = [NSString stringWithFormat:@"http://realtime.mbta.com/developer/api/v2/stopsbylocation?api_key=hL9CTWmmz06o80Vv8cYuJw&lat=%@&lon=%@&format=xml",self.currentLat, self.currentLong];
    NSURL *URL = [[NSURL alloc] initWithString:stopApiString];
    NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
    xmlContentFlag = @"Stops";
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    
    for(busStop in busStopArray){
    CLLocationCoordinate2D annotationCoord;
    float latFloat = [busStop.lat floatValue];
    float longFloat = [busStop.lon floatValue];
    
    annotationCoord.latitude = latFloat;
    annotationCoord.longitude = longFloat;
        
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
        NSString* aTitle = busStop.title;
        aTitle = [aTitle stringByAppendingString:@","];
        aTitle = [aTitle stringByAppendingString:busStop.stopID];
        annotationPoint.title =aTitle;
        
    NSString *sub = busStop.distance;
    sub = [sub stringByAppendingString:@" miles away"];
    annotationPoint.subtitle = sub;
    

    MKCoordinateRegion newRegion;
    newRegion.center.latitude = latFloat;
    newRegion.center.longitude = longFloat;
    newRegion.span.latitudeDelta = 0.03;
    newRegion.span.longitudeDelta = 0.03;
    [mapCurrent addAnnotation:annotationPoint];
    [mapCurrent setRegion:newRegion];
        aTitle = [[NSString alloc]init];
        sub = [[NSString alloc]init];
    }
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MKPointAnnotation *ann = view.annotation;
    
    [self performSegueWithIdentifier:@"busForStopSegue" sender:view];
    NSArray *subString = [ann.title componentsSeparatedByString:@","];
    NSString *stopid = [subString objectAtIndex:1];
    
    NSString *predictAPIString = [NSString stringWithFormat:@"http://realtime.mbta.com/developer/api/v2/predictionsbystop?api_key=wX9NwuHnZU2ToO7GmGR9uw&stop=%@&format=xml",stopid];
    NSLog(@"%@",predictAPIString);
    NSURL *URL = [[NSURL alloc]initWithString:predictAPIString];
    xmlContentFlag = @"Buses";
    NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self];
    [parser parse];

    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"busForStopSegue"])
    {

        NearByBusStopViewController *nbvc = [segue destinationViewController];
        
        nbvc.locationBusArray = self.locationBusArray;
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([xmlContentFlag isEqualToString:@"Stops"]){
    
    if([elementName isEqualToString:@"stop"]){
        
        NSString *stopID = [attributeDict objectForKey:@"stop_id"];
        NSString *title = [attributeDict objectForKey:@"stop_name"];
        NSString *tag = [attributeDict objectForKey:@"parent_station_name"];
        NSString *lat = [attributeDict objectForKey:@"stop_lat"];
        NSString *lon = [attributeDict objectForKey:@"stop_lon"];
        NSString *distance = [attributeDict objectForKey:@"distance"];
        
        busStop.stopID = stopID;
        busStop.title = title;
        busStop.tag = tag;
        busStop.lat = lat;
        busStop.lon = lon;
        busStop.distance = distance;
        
        
        [busStopArray addObject:busStop];
        busStop = [[BusStop alloc]init];
        
    }
    }
    if([xmlContentFlag isEqualToString:@"Buses"]){
        
        
            if([elementName isEqualToString:@"trip"]){
                
                
                NSString *tripName = [attributeDict objectForKey:@"trip_name"];
                NSString *predict = [attributeDict objectForKey:@"pre_away"];
                double pCal = [predict doubleValue] / 60;
                NSString *pBus = [[NSString alloc]initWithFormat:@"%ld",lround(pCal)];
                
                locationBus.tripName = tripName;
                locationBus.predict =pBus;
                
                [locationBusArray addObject:locationBus];
                locationBus = [[LocationBus alloc]init];
            
            
        }
    
    }
    
}
@end
