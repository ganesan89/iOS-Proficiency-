//
//  ViewController.m
//  TelstraProficiency
//
//  Created by  on 23/11/15.
//  Copyright (c) 2015 GANESAN. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    // Pull down Refresh
    UIRefreshControl *refreshControl;
    //Loading Indicator
    UIActivityIndicatorView *activityView;
    
    //Dictionary to store the Image for Caching
    NSMutableDictionary *imageCacheDictionary;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //For Loading List View
    [self onLoadListView];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Create UIActivityIndicatorView
    activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = self.view.center;
    [self.view addSubview:activityView];
    
    //Create UIRefreshControl
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onPullDownRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.feedsListView addSubview:refreshControl];
    
    //Orientation Handling
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationChanged:)  name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    //Dictionary to store Images to avoid repeated downloading
    imageCacheDictionary = [[NSMutableDictionary alloc]init];
}

-(void)viewWillAppear:(BOOL)animated {
    [self onPerformSerivceCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPullDownRefresh:(UIRefreshControl *)refreshControlobj{
    //Server call using background Thread
    [self onPerformSerivceCall];
    [self.feedsListView reloadData];
    [refreshControlobj endRefreshing];
}

/* Method for Loading ListView
 * Assigning list view Delegate
 * void return type
 */
-(void) onLoadListView {
    
   self.feedsListView  = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    self.feedsListView.delegate = self;
    self.feedsListView.dataSource = self;
    [self.view addSubview:self.feedsListView];
}

#pragma mark Serivce call
/*
 * Method for fetching data from server
 * void return type
 */
-(void)onPerformSerivceCall {
    //set loading activity at center for all orientation
    activityView.center = self.view.center;
    BOOL isCheckReachablityForNetwork = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
    if (isCheckReachablityForNetwork) {
       
        // Class to invoke Webservice call to fetch JSON Response
        TelstraServiceCall *telstraServiceCall = [[TelstraServiceCall alloc]init];
        telstraServiceCall.serviceCallDelegate = self;
        [telstraServiceCall initWithRequestUrl:serviceUrl];
        [self startActivityIndicator];
        
    }else{
        
        [self stopActivityIndicator];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:internetErrorType message:internetConnectivityError delegate:nil cancelButtonTitle:alertOkText otherButtonTitles:nil];
        [alert show];
    }
}

//Method for start activity Indicator
-(void)startActivityIndicator {
    //For displaying the loading activity for entire application
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
     [activityView startAnimating];
}

//Method for stop activityIndicator
-(void)stopActivityIndicator {
    
    [activityView stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

#pragma mark Service Response 
// delegate method which contains the service response
-(void)serviceSuccessResponse:(NSMutableDictionary*)responseDictionary {
    
    [self stopActivityIndicator];
    self.feedsListArray = [[NSMutableArray alloc]init];
    // Iterating number of records in json feeds
    for(NSDictionary *rowItem in [responseDictionary objectForKey:@"rows"]) {
        
        JsonModel *jsonModelObj = [[JsonModel alloc]init];
        jsonModelObj.titleString = [TelstraProficiencyUtilities emptyCheck:[rowItem objectForKey:@"title"]];
        jsonModelObj.descriptionString = [TelstraProficiencyUtilities emptyCheck:[rowItem objectForKey:@"description"]];
        jsonModelObj.imageUrl = [TelstraProficiencyUtilities emptyCheck:[rowItem objectForKey:@"imageHref"]];
        
        if (!([jsonModelObj.titleString isEqualToString:@""] && [jsonModelObj.descriptionString isEqualToString:@""] && [jsonModelObj.imageUrl isEqualToString:@""])) {
            
            //Storing Model Objects
            [self.feedsListArray addObject:jsonModelObj];
        }
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.feedsListView reloadData];
    });
}

//delegate method which contains the error message at the time of failure
-(void)serviceFailedStatus:(NSError *)error {
    
    [self stopActivityIndicator];
    NSString *errorDescription=[error.userInfo objectForKey:@"NSLocalizedDescription"];
    NSLog(@"serviceFailsErrror:%@",errorDescription);
    
    UIAlertView *failureAlert = [[UIAlertView alloc]initWithTitle:serviceCallAlertTitle message:errorDescription delegate:nil cancelButtonTitle:alertOkText otherButtonTitles:nil];
    [failureAlert show];
}

#pragma mark Orientation Handling
/* Method for setting Table view frame for all Orientation.
 * Reloads data for All orientation
 * void return type
 * parameter as Notification Object
 */
- (void) onOrientationChanged:(NSNotification *)note
{
    [self.feedsListView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.feedsListView reloadData];
}

#pragma mark TableView Delegate
//Returns the number of the Rows to be Display
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.feedsListArray count];
}

//Display TableView cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = tableCellIdentifier;
    FeedListCell *feedListCell = (FeedListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    feedListCell.backgroundColor=[UIColor clearColor];
    
    if (feedListCell == nil){
        feedListCell = [[FeedListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    JsonModel *jsonModelObj = [self.feedsListArray objectAtIndex:indexPath.row];
    //Display title text from Model Class
    feedListCell.titleLabel.text = jsonModelObj.titleString;
    
    //Display descriptopm text from Model Class
    feedListCell.descriptionLabel.text = jsonModelObj.descriptionString;
    
    // Method which returns the height based on the text
    CGRect descriptionRect = [self calculateTextHeight:jsonModelObj.descriptionString];
    //Adjust the label to the new height.
    CGRect descriptionFrame = feedListCell.descriptionLabel.frame;
    // Set Description text frame
    [feedListCell.descriptionLabel setFrame:CGRectMake(descriptionFrame.origin.x, descriptionFrame.origin.y, descriptionFrame.size.width, descriptionRect.size.height)];
 
    //setting dummy image
    [feedListCell.cellImageView setImage:noImage];
    
    if (![jsonModelObj.imageUrl isEqualToString:@""]) {
        
        if (![imageCacheDictionary valueForKey:jsonModelObj.imageUrl]) {
            // Image lazyloading
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:jsonModelObj.imageUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                if (httpResponse.statusCode == 200) {
                    feedListCell.cellImageView.image = [UIImage imageWithData:data];
                    //Caching Image once downloaded
                    [imageCacheDictionary setObject:data forKey:jsonModelObj.imageUrl];
                } else {
                    // Load empty Image
                    [feedListCell.cellImageView setImage:noImage];
                    NSData *emptyImageData = UIImagePNGRepresentation(noImage);
                    [imageCacheDictionary setObject:emptyImageData forKey:jsonModelObj.imageUrl];
                }
            }];
        } else {
            // assign image from local cache
            feedListCell.cellImageView.image = [UIImage imageWithData:[imageCacheDictionary valueForKey:jsonModelObj.imageUrl]];
        }
    }
    return feedListCell;
}

// Returns Tableview height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Models for json feed
    JsonModel *jsonModel = [self.feedsListArray objectAtIndex:indexPath.row];
    NSString *descriptionText = jsonModel.descriptionString.length > 0 ? jsonModel.descriptionString : @"Description not Available";
    //Expected height
    CGSize expectedDescSize = [self calculateTextHeight:descriptionText].size;
    
    CGFloat totalHeight = expectedDescSize.height;
    if (totalHeight > imageSize)
        return totalHeight + titleLabelHeight;
    else
        return tableCellHeight;
}

/* Calculate Height based on text size
 * CGRect return type
 * parameter as String
 */
-(CGRect)calculateTextHeight:(NSString *)text
{
    //Calculate height of the description text
   CGSize descSize = CGSizeMake(screenWidth - (imageSize+50) ,0);
   UIFont *descFont = [UIFont systemFontOfSize:13];

    NSAttributedString *attrString =
    [[NSAttributedString alloc] initWithString:text
                                    attributes:@{ NSFontAttributeName:descFont}];
    
    return [attrString boundingRectWithSize:descSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
}

@end
