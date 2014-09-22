//
//  ViewController.m
//  Platform
//
//  Created by Johnny Verhoeff on 21-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"

#import "Platform.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSString *url;
    NSArray *_waterSensors;
}

#pragma mark - Action buttons from settings viewcontroller

- (IBAction)cancelSettings:(UIStoryboardSegue *)segue {
    NSLog(@"Cancel settings in main viewcontroller");
    NSLog(@"Url is: %@", url);
}

- (IBAction)saveSettings:(UIStoryboardSegue *)segue {
    NSLog(@"Save settings in main viewcontroller");
    
    SettingsViewController *controller = segue.sourceViewController;
    url = controller.url;
    NSLog(@"The new url is: %@", url);
    
}

#pragma mark - standard inherited methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    url = @"http://192.168.215.177";
    
    _waterSensors = @[@"High boat sensor", @"Low boat sensor", @"Under water sensor"];
    
    self.waterSensorPicker.delegate = self;
    self.waterSensorPicker.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button methods


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
    
    [self getProgramState];
}

- (IBAction)selectWaterSensor:(id)sender {
    self.waterSensorPicker.hidden = false;
}

#pragma mark - Get and Post methods

- (void)getProgramState {
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
        
        return;
    }
    
    NSLog(@"url response:");
    NSLog(@"%@", response);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    NSInteger state = [[json objectForKey:@"program_state"] integerValue];
    
    NSString *state_name = [Platform getStateNameForState:state];
    
    NSLog(@"program_state: %@", state_name);
    
    [self programStateLabel].text = state_name;
}

- (void)sendPostRequestWithData:(NSString *)post {
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/web_control", url]]];
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

- (void)sendProgramState:(enum program_states)programState {
    // post params to send platform to upper limit switch
    NSString *post = [NSString stringWithFormat:@"program_state=%i", programState];
    
    [self sendPostRequestWithData:post];
}

- (void)sendActiveWaterSensor:(NSInteger)activeWaterSensor {
    NSString *post = [NSString stringWithFormat:@"water_sensor=%li", (long)activeWaterSensor];
    
    [self sendPostRequestWithData:post];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        UINavigationController *navcontroller = segue.destinationViewController;
        SettingsViewController *controller = (SettingsViewController *)navcontroller.topViewController;
        controller.url = url;
    }
    
}

#pragma mark - Picker view delegate and data source 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _waterSensors.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _waterSensors[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Row selected: %li", (long)row);
    NSLog(@"Selected sensor: %@", _waterSensors[row]);
    pickerView.hidden = true;
    
    [self sendActiveWaterSensor:row];
}

@end
