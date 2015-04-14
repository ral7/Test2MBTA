//
//  BusStopViewController.m
//  Test2MBTA
//
//  Created by Rahul Puri on 12/7/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import "BusStopViewController.h"
#import "PredictStop.h"
#import "PredictionViewController.h"

@interface BusStopViewController ()

@end

@implementation BusStopViewController
@synthesize stopDictionary;
@synthesize tagList;
@synthesize routeID;
@synthesize predictStop;
@synthesize predictArray;
@synthesize latitude;
@synthesize longitude;
@synthesize stopName;
int i = 0;

-(id) initParser{
    if(self == [super init]){
        
    }
    return self;
}


- (void)viewDidLoad {

    self.stopTable.delegate = self;
    self.stopTable.dataSource = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.stopTable.reloadData;
    predictStop = [[PredictStop alloc]init];
    predictArray = [[NSMutableArray alloc]init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [[segue identifier]isEqualToString:@"predictionSegue"];
    NSIndexPath* indexPath = [self.stopTable indexPathForSelectedRow];
    UITableViewCell* cell = [self.stopTable cellForRowAtIndexPath:indexPath];
    NSString* stop = cell.detailTextLabel.text;
    NSString *predictAPIString = [NSString stringWithFormat:@"http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=mbta&stopId=%@&routeTag=%@",stop,routeID];
    
    NSURL *URL = [[NSURL alloc]initWithString:predictAPIString];
    NSData *data = [[NSData alloc]initWithContentsOfURL:URL];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    PredictionViewController *pvc = [segue destinationViewController];
    pvc.predictArray = self.predictArray;
   
    pvc.latitude = latitude;
    pvc.longitude = longitude;
    pvc.stopName = stopName;

    
    
    
}



-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
   
    if([elementName isEqualToString:@"direction"]){
        NSString *direction = [attributeDict objectForKey:@"title"];
        NSLog(@"Direction: %@",direction );
        predictStop.direction = direction;
        
    }
    if([elementName isEqualToString:@"prediction"]){
        NSString *timeASof = [attributeDict objectForKey:@"epochTime"];
        
        predictStop.epochTime = timeASof;
        NSString *predictedTime = [attributeDict objectForKey:@"minutes"];
        predictStop.predictedTime = predictedTime;
        [predictArray addObject:predictStop];
        predictStop = [[PredictStop alloc]init];
    }


}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [stopDictionary count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idStopRecord" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"idStopRecord"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    if(i< [tagList count]){
    NSString *key = [tagList objectAtIndex:i];
    
    NSString *value  = [stopDictionary objectForKey:key];
    NSArray *valueArray = [value componentsSeparatedByString:@","];
        
    cell.textLabel.text = [valueArray objectAtIndex:0];
        stopName = [valueArray objectAtIndex:0];
        cell.detailTextLabel.text = [valueArray objectAtIndex:3] ;
        cell.textLabel.font = [UIFont systemFontOfSize:10];
   
        
        latitude = [valueArray objectAtIndex:1];
        longitude = [valueArray objectAtIndex:2];
        cell.imageView.image = [UIImage imageNamed:@"Bus_stop_symbol.svg.png"];
    }
    i = i+1;
        return cell;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
