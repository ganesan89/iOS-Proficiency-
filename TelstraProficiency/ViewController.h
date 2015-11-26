//
//  ViewController.h
//  TelstraProficiency
//
//  Created by  on 23/11/15.
//  Copyright (c) 2015 GANESAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedListCell.h"
#import "Reachablity/Reachability.h"
#import "TelstraProficiencyConstants.h"
#import "TelstraProficiencyUtilities.h"
#import "JsonModel.h"
#import "TelstraServiceCall.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,TelstraServiceProtocol>
{
}
//Display the list
@property (strong,nonatomic) UITableView *feedsListView;
// Holds the data to display the item in the list
@property (strong,nonatomic) NSMutableArray *feedsListArray;

@end

