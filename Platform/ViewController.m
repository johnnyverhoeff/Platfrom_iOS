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

@implementation ViewController

- (void)sendProgramState:(enum ProgramStates)programState
{
    // post params to send platform to upper limit switch
    NSString *post = [NSString stringWithFormat:@"program_state=%i", programState];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.215.177/web_control"]]];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
