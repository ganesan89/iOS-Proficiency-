//
//  TelstraServiceCall.m
//  TelstraProficiency
//
//  Created by Cognizant on 11/26/15.
//  Copyright (c) 2015 GANESAN. All rights reserved.
//

#import "TelstraServiceCall.h"

@implementation TelstraServiceCall

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/* method to perfrom service call
 * method with void return type
 * method with parameter NSString
 */

-(void)initWithRequestUrl:(NSString*)urlString
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
       [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
           
           NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
           if (httpResponse.statusCode == 200) {
               
               NSString *responseString= [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
               NSData *responseData=[responseString dataUsingEncoding:NSUTF8StringEncoding];
               NSError *error;
               NSMutableDictionary *receivedDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
               
               [self.serviceCallDelegate serviceSuccessResponse:receivedDictionary];
               
           } else {
               
               [self.serviceCallDelegate serviceFailedStatus:connectionError];
           }
       }];
    });
}

@end
