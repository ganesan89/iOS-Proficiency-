//
//  ViewController.h
//  TelstraProficiency
//
//  Created by  on 23/11/15.
//  Copyright (c) 2015 GANESAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedListCell.h"
#import "TelstraProficiencyConstants.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
}
//Display the list
@property (strong,nonatomic) UITableView *feedsListView;
// Holds the data to display the item in the list
@property (strong,nonatomic) NSMutableArray *feedsListArray;

@end

