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

@implementation ViewController

#pragma mark - Action buttons from settings viewcontroller

- (IBAction)cancelSettings:(UIStoryboardSegue *)segue {
    NSLog(@"Cancel settings in main viewcontroller");
    NSLog(@"Url is: %@", [Platform getUrl]);
}

- (IBAction)saveSettings:(UIStoryboardSegue *)segue {
    NSLog(@"Save settings in main viewcontroller");
    
    SettingsViewController *controller = segue.sourceViewController;
    [Platform setUrlTo:controller.url];
    NSLog(@"The new url is: %@", [Platform getUrl]);
    
}

#pragma mark - standard inherited methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Platform setUrlTo:@"http://192.168.215.177"];
    
    NSArray *waterSensors = @[@"High boat sensor", @"Low boat sensor", @"Under water sensor"];
    [Platform setWaterSensorsTo:waterSensors];
    
    self.waterSensorPicker.delegate = self;
    self.waterSensorPicker.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button methods


- (IBAction)reachUpperLSButton:(id)sender {
    NSLog(@"reachUpperLSButton pressed");
    
    [Platform setProgramStateTo:reach_upper_limit_switch];
}

- (IBAction)reachLowerLSButton:(id)sender {
    NSLog(@"reachUpperLSButton pressed");
    
    [Platform setProgramStateTo:reach_lower_limit_switch];
}

- (IBAction)stopButtonPressed:(id)sender {
    NSLog(@"Stop button pressed");
    [Platform setProgramStateTo:none];
}

- (IBAction)getStatus:(id)sender {
    NSLog(@"get status button pressed");
    
    NSString *state_name = [Platform getProgramState];
    self.programStateLabel.text = state_name;
}

- (IBAction)selectWaterSensor:(id)sender {
    self.waterSensorPicker.hidden = false;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        UINavigationController *navcontroller = segue.destinationViewController;
        SettingsViewController *controller = (SettingsViewController *)navcontroller.topViewController;
        controller.url = [Platform getUrl];
    }
    
}

#pragma mark - Picker view delegate and data source 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [Platform getWaterSensors].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [Platform getWaterSensors][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Row selected: %li", (long)row);
    NSLog(@"Selected sensor: %@", [Platform getWaterSensors][row]);
    pickerView.hidden = true;
    
    [Platform setWaterSensorTo:row];
}

@end
