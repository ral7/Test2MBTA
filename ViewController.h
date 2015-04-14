//
//  ViewController.h
//  Test2MBTA
//
//  Created by Rahul Puri on 12/7/14.
//  Copyright (c) 2014 Rahul Puri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSXMLParserDelegate>
{
    NSMutableDictionary *stopDictionary;
    NSMutableArray *tagList;
    NSString* routeID;
}

@property (weak, nonatomic) IBOutlet UITableView *busListTable;





-(id)initParser;
@end

