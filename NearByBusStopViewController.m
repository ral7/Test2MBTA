//
//  NearByBusStopViewController.m
//  Test2MBTA
//
//  Created by Rahul Puri on 12/11/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import "NearByBusStopViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationBus.h"

@interface NearByBusStopViewController ()
@property (nonatomic, strong) LocationBus *locationBus;

@end

@implementation NearByBusStopViewController
@synthesize locationBusArray;
@synthesize locationBus;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.busTable.delegate = self;
    self.busTable.dataSource = self;
    self.busTable.reloadData;
    locationBus = [[LocationBus alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(void) viewWillDisappear:(BOOL)animated {
    // Your Code
    [super viewWillDisappear:YES];
    [locationBusArray removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.busTable reloadData]; // to reload selected cell
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [locationBusArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationBusID" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"locationBusID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LocationBus *l = [self busAtIndex:indexPath.row];
    NSString *p = [[NSString alloc]init];
    cell.textLabel.text = l.tripName;
    p = [p stringByAppendingString:@"Next Vehicle in "];
    p = [p stringByAppendingString:l.predict];
    p = [p stringByAppendingString:@" minutes"];
    cell.detailTextLabel.text =p;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    return cell;
    
}
-(LocationBus*) busAtIndex: (NSInteger) index
{
    return [locationBusArray objectAtIndex:index] ;
}

@end
