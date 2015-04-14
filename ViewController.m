//
//  ViewController.m
//  Test2MBTA
//
//  Created by Rahul Puri on 12/7/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//


#import "ViewController.h"
#import "DBManager.h"
#import "BusStopViewController.h"
#import "BusStop.h"
#import "ByLocationViewController.h"

@interface ViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrBus;


-(void)loadData;
@end

@implementation ViewController




-(id) initParser{
    if(self == [super init]){
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.busListTable.delegate = self;
    self.busListTable.dataSource = self;
    stopDictionary = [[NSMutableDictionary alloc]init];
    tagList = [[NSMutableArray alloc]init];
   
    self.dbManager = [[DBManager alloc]initWithDatabaseFilename:@"mbta.sql"];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}




-(void)loadData{
    // Form the query.
    NSString *query = @"select * from routeList";
    
    // Get the results.
    if (self.arrBus != nil) {
        self.arrBus = nil;
    }
    self.arrBus = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.busListTable reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrBus.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([[segue identifier]isEqualToString:@"busStopSegue"]){
        
    
    NSIndexPath* indexPath = [self.busListTable indexPathForSelectedRow];
    NSInteger indexOfFirstname = [self.dbManager.arrColumnNames indexOfObject:@"title"];
    NSString* title = [[self.arrBus objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname];
    NSLog(@"Title is: %@",title);
    
    NSString *stopApiString = [NSString stringWithFormat:@"http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=mbta&r=%@", title];
    NSURL *URL = [[NSURL alloc] initWithString:stopApiString];
   // NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
   // NSLog(@"STring is: %@", xmlString);
    
    NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    BusStopViewController*bStop =[segue destinationViewController];
    bStop.stopDictionary = stopDictionary;
    bStop.tagList = tagList;
    NSString* navTitle = @"Stops for Bus: ";
    navTitle =[navTitle stringByAppendingString:title];
    bStop.navigationItem.title =navTitle;
    bStop.routeID = routeID;
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //NSMutableArray *objects = [[NSMutableArray alloc]init];
    
    if([elementName isEqualToString:@"route"]){
        NSLog(@"Route Reached");
        routeID = [attributeDict objectForKey:@"tag"];
        NSLog(@"RouteTag is: %@",routeID);
    }
    if([elementName isEqualToString:@"stop"]){
        
        
        NSString* tag = [attributeDict objectForKey:@"tag"];
        NSString* titleName = [attributeDict objectForKey:@"title"];
       
        NSString* lat = [attributeDict objectForKey:@"lat"];
        
        NSString* lon = [attributeDict objectForKey:@"lon"];
    
        NSString* stopID = [attributeDict objectForKey:@"stopId"];
        
        if(!((titleName==nil) ||(lat==nil) || (lon == nil) || (stopID == nil))){
            
        
        NSString *dummy = [[NSString alloc]init];
        dummy = [dummy stringByAppendingString:titleName];
        dummy = [dummy stringByAppendingString:@","];
        dummy = [dummy stringByAppendingString:lat];
        dummy = [dummy stringByAppendingString:@","];
        dummy = [dummy stringByAppendingString:lon];
        dummy = [dummy stringByAppendingString:@","];
        dummy = [dummy stringByAppendingString:stopID];
        
        if([stopDictionary objectForKey:tag]==nil){
        
            
            [tagList addObject:tag];

        [stopDictionary setObject:dummy forKey:tag];
        }
    }
}
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger tag = [self.dbManager.arrColumnNames indexOfObject:@"title"];

    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrBus objectAtIndex:indexPath.row] objectAtIndex:tag]];
    cell.imageView.image = [UIImage imageNamed:@"images.jpeg"];
    
    
    return cell;

}

@end
