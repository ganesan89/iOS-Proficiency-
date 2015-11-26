//
//  TelstraProficiencyTests.m
//  TelstraProficiencyTests
//
//  Created by  on 23/11/15.
//  Copyright (c) 2015 GANESAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "TelstraProficiencyConstants.h"

@interface TelstraProficiencyTests : XCTestCase

@property (strong,nonatomic) ViewController *testViewController;
@end

@implementation TelstraProficiencyTests

- (void)setUp {
    [super setUp];
    
    self.testViewController = [[ViewController alloc]init];
    [self.testViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [self.testViewController view];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


#pragma mark - View loading tests
-(void)testViewLoaded
{
    XCTAssertNotNil(self.testViewController.view, @"View controller not initiated");
}

-(void)testTableViewLoaded
{
    XCTAssertNil(self.testViewController.self.feedsListView, @"TableView not initiated");
}

- (void)testViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.testViewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.testViewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}


#pragma mark - TestCase for lazy Loading

-(void)testWebserviceCall {
    
    NSString *urlString = @"http://files.turbosquid.com/Preview/Content_2009_07_14__10_25_15/trebucheta.jpgdf3f3bf4-935d-40ff-84b2-6ce718a327a9Larger.jpg";
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode == 200) {
            
            XCTAssertTrue(data,@"Image should be nil");
        } else {
            
              XCTAssertFalse(data,@" Image should not be nil");
        }
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
