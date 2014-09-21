//
//  ViewController.m
//  Platform
//
//  Created by Johnny Verhoeff on 21-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import "ViewController.h"
#import "ProgramStates.h"
@interface ViewController ()
@end

@implementation ViewController {
    NSString *url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    url = @"http://192.168.215.177/";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendProgramState:(enum ProgramStates)programState
{
    // post params to send platform to upper limit switch
    NSString *post = [NSString stringWithFormat:@"program_state=%i", programState];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@web_control", url]]];
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

- (IBAction)buttonPressed:(id)sender {
    NSLog(@"Button pressed");
    
    NSLog(@"Attempt to send HTTP Post");
    
    [self sendProgramState:reach_upper_limit_switch];
}

- (IBAction)stopButtonPressed:(id)sender {
    NSLog(@"Stop button pressed");
    [self sendProgramState:none];
}

- (IBAction)getStatus:(id)sender {
    NSLog(@"get status button pressed");
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@json", url]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if (requestError != nil) {
        NSLog(@"Something went wrong with the GET request");
        NSLog(@"%@", requestError);
        return;
    }
    
    NSLog(@"url response:");
    NSLog(@"%@", response);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    enum ProgramStates state = [[json objectForKey:@"program_state"] integerValue];
    
    NSString *state_name = [ProgramStatesMethods getStateNameForState:state];
    
    NSLog(@"program_state: %@", state_name);
    
    [self programStateLabel].text = state_name;
    
}


@end
