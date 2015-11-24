//
//  TelstraProficiencyUtilities.m
//  TelstraProficiency
//
//  Created by  on 23/11/15.
//  Copyright (c) 2015 GANESAN. All rights reserved.
//

#import "TelstraProficiencyUtilities.h"

@implementation TelstraProficiencyUtilities
/* Method to check NULL class
 * String return type
 * parameter as string
 */
+( NSString *)emptyCheck:(id)value{
    if ([value isKindOfClass:[NSNull class]]){
        return @"";
    }
    else{
        return value;
    }
}
@end
