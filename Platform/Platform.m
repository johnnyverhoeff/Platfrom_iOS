//
//  Platform.m
//  Platform
//
//  Created by Johnny Verhoeff on 22-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Platform.h"

@implementation Platform

#pragma mark - Getters and Setters for static variables

static NSString *url;
static NSArray *waterSensors;

+ (NSString *)getUrl {
    return url;
}

+ (void)setUrlTo:(NSString *)newUrl {
    url = newUrl;
}

+ (NSArray *)getWaterSensors {
    return waterSensors;
}

+ (void)setWaterSensorsTo:(NSArray *)newSensors {
    waterSensors = newSensors;
}

#pragma mark - Other stuff

+ (NSString *)getStateNameForState:(enum program_states)state {
    
    switch (state) {
        case none:
        default:
            return @"None";
            
        case reach_active_water_sensor:
            return @"Reach active water sensor";
            
        case reach_and_control_vlonder_on_active_water_sensor:
            return @"Reach and control on active water sensor";
            
        case control_vlonder_on_active_water_sensor:
            return @"Controlling on active water sensor";
            
        case reach_upper_limit_switch:
            return @"Reaching upper limit switch";
            
        case reach_lower_limit_switch:
            return @"Reaching lower limit switch";
            
        case web_control_manual_down:
            return @"Web control manual down";
            
        case web_control_manual_up:
            return @"Web control manual up";
            
        case remote_control_manual_up:
            return @"Remote control manual up";
            
        case remote_control_manual_down:
            return @"Remote control manual down";
            
    }
}

+ (NSString *)getProgramState {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/json", url]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if (requestError != nil) {
        NSLog(@"Something went wrong with the GET request");
        NSLog(@"%@", requestError);
        
        NSString *error_message = [NSString stringWithFormat:@"%li: %@", (long)requestError.code, [requestError.userInfo objectForKey:@"NSLocalizedDescription"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong!" message: error_message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        
        return [self getStateNameForState:none];
    }
    
    NSLog(@"url response:");
    NSLog(@"%@", response);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    NSInteger state = [[json objectForKey:@"program_state"] integerValue];
    
    NSString *state_name = [Platform getStateNameForState:state];
    
    NSLog(@"program_state: %@", state_name);
    
    return state_name;
}

+ (void)sendPostRequestWithData:(NSString *)post {
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/web_control", [Platform getUrl]]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn)
        NSLog(@"Connection succesful");
    else
        NSLog(@"Connection could not be made");
}

+ (void)setProgramStateTo:(enum program_states)newState {
    NSString *post = [NSString stringWithFormat:@"program_state=%i", newState];
    
    [self sendPostRequestWithData:post];
}

+ (void)setWaterSensorTo:(NSInteger)newSensor {
    NSString *post = [NSString stringWithFormat:@"water_sensor=%li", (long)newSensor];
    
    [self sendPostRequestWithData:post];
}



@end
