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
#import "PlatformStatusUpdateNotifications.h"

@implementation Platform

- (id)initWithStandardWaterSensors {
    self = [super init];
    
    if (self) {
        _waterSensors = @[@"High boat sensor", @"Low boat sensor", @"Under water sensor"];
    }
    
    return self;
}

#pragma mark - Other stuff

- (void)showAlertWithError:(NSError *)error {
    NSString *error_message = [NSString stringWithFormat:@"%li: %@", (long)error.code, [error.userInfo objectForKey:@"NSLocalizedDescription"]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong!" message: error_message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message: message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
}

- (NSString *)getStateNameForState:(enum program_states)state {
    
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

- (void)requestStatusData {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/json", _url]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn)
        NSLog(@"GET request send succusfully");
    else
        NSLog(@"Error sending GET request");
    
    /*NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if (requestError != nil) {
        NSLog(@"Something went wrong with the GET request");
        NSLog(@"%@", requestError);
        
        [self showAlertWithError:requestError];
        
        return [NSDictionary dictionary];
    }
    
    NSLog(@"url response:");
    NSLog(@"%@", response);
    
    NSError *error;
    return [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];*/
}


- (void)updateStatus {
    [self requestStatusData];
}

- (void)sendPostRequestWithData:(NSString *)post {
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/web_control", _url]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setTimeoutInterval:5];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn)
        NSLog(@"POST request send succusfully");
    else
        NSLog(@"Error sending POST request");
}

- (void)setProgramStateTo:(enum program_states)newState {
    NSString *post = [NSString stringWithFormat:@"program_state=%i", newState];
    
    [self sendPostRequestWithData:post];
}

- (void)setWaterSensorTo:(NSInteger)newSensor {
    NSString *post = [NSString stringWithFormat:@"water_sensor=%li", (long)newSensor];
    
    [self sendPostRequestWithData:post];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    NSLog(@"didReceiveResponse");
    
    NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
    
    if (statusCode != 200) {
        [self showAlertWithTitle:@"Wrong HTTP status code" andMessage:[NSHTTPURLResponse localizedStringForStatusCode:statusCode]];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSLog(@"didReceiveData");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    NSLog(@"willCacheResponse");
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSLog(@"connectionDidFinishLoading: %@", _responseData);
    
    
    NSURL *url = connection.currentRequest.URL;
    NSURL *getUrl = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@",_url,@"/json"]];
    
    if ([url isEqual:getUrl]) {
        NSLog(@"It was from the only get request");
        
        NSError *error;
        NSDictionary *platformData = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
        
        id<PlatformStatusUpdateNotifications> strongDelegate = self.delegate;
        
        NSInteger state = [[platformData objectForKey:@"program_state"] integerValue];
        NSString *state_name = [self getStateNameForState:state];
        
        NSString *active_water_sensor = [[platformData objectForKey:@"vlonder"] objectForKey:@"active_water_sensor"];
        
        [strongDelegate platformDidFinishUpdatingProgramState:state_name];
        [strongDelegate platformDidFinishUpdatingActiveWaterSensor:active_water_sensor];
        
        
    }
    else {
        NSLog(@"It was from the only post request");
    }
        

    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"didFailWithError");
    NSLog(@"Error: %@", error);
    
    [self showAlertWithError:error];
}

@end
