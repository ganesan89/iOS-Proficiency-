//
//  TelstraServiceCall.h
//  TelstraProficiency
//
//  Created by Cognizant on 11/26/15.
//  Copyright (c) 2015 GANESAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TelstraServiceProtocol <NSObject>

-(void)serviceSuccessResponse:(NSMutableDictionary*)responseDictionary;
-(void)serviceFailedStatus:(NSError *)error;

@end

@interface TelstraServiceCall : NSObject
@property (strong,nonatomic) id<TelstraServiceProtocol>serviceCallDelegate;

-(void)initWithRequestUrl:(NSString*)urlString;
@end
