//
//  ViewController.m
//  Platform
//
//  Created by Johnny Verhoeff on 21-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"
#import "TabBarController.h"
#import "Platform.h"
#import "PlatformData.h"

@interface ViewController ()

@end

@implementation ViewController {
    Platform *platform;
    PlatformData *platformData_latest;
}

#pragma mark - Action buttons from settings viewcontroller

- (IBAction)cancelSettings:(UIStoryboardSegue *)segue {
    NSLog(@"Cancel settings in main viewcontroller");
    NSLog(@"Url is: %@", platform.url);
}

- (IBAction)saveSettings:(UIStoryboardSegue *)segue {
    NSLog(@"Save settings in main viewcontroller");
    
    SettingsViewController *controller = segue.sourceViewController;
    platform.url = controller.url;
    NSLog(@"The new url is: %@", platform.url);
    
}

#pragma mark - standard inherited methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //platform = [[Platform alloc] initWithStandardWaterSensors];
    //platform.delegate = self;
    
    //platform.url = @"http://192.168.215.177";
    
    TabBarController *tab = (TabBarController *)self.navigationController.tabBarController;
    
    platform = tab.platform;
    platform.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button methods


- (IBAction)reachUpperLSButton:(id)sender {
    NSLog(@"reachUpperLSButton pressed");
    [platform setProgramStateTo:reach_upper_limit_switch];
}

- (IBAction)reachLowerLSButton:(id)sender {
    NSLog(@"reachUpperLSButton pressed");
    
    [platform setProgramStateTo:reach_lower_limit_switch];
}

- (IBAction)stopButtonPressed:(id)sender {
    NSLog(@"Stop button pressed");
    [platform setProgramStateTo:none];
}

- (IBAction)getStatus:(id)sender {
    NSLog(@"get status button pressed");
    
    [platform updateStatus];
}

- (IBAction)selectWaterSensor:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick a water sensor" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:platform.waterSensors[0], platform.waterSensors[1], platform.waterSensors[2], nil];
    
    actionSheet.tag = 1;
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)controlPlatfrom:(id)sender {
    [platform setProgramStateTo:control_vlonder_on_active_water_sensor];
}

- (IBAction)reachAndControlPlatform:(id)sender {
    [platform setProgramStateTo:reach_and_control_vlonder_on_active_water_sensor];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        UINavigationController *navcontroller = segue.destinationViewController;
        SettingsViewController *controller = (SettingsViewController *)navcontroller.topViewController;
        controller.url = platform.url;
    }
    
}

#pragma mark - Action Sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag != 1)
        return;
    
    if (buttonIndex >= platform.waterSensors.count)
        return;
    
    [platform setWaterSensorTo:buttonIndex];
}

#pragma mark - Platform delegates

- (void)platformDidFinishUpdatingData:(PlatformData *)data {
    platformData_latest = data;
    [self.tableView reloadData];
}

- (void)platformDidOccurError {
    NSLog(@"PLATFORM ERRROR!!!!");
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (!platformData_latest) {
        cell.textLabel.text = @"Load data!";
        return cell;
    }
    
    NSString *text;
    
    switch (indexPath.row) {
        case 0:
            text = [NSString stringWithFormat:@"Program state: %@", platformData_latest.programStateName];
            break;
            
        case 1:
            text = [NSString stringWithFormat:@"Moving state: %@", platformData_latest.movingStateName];
            break;
            
        case 2:
            text = [NSString stringWithFormat:@"Active sensor: %@", platformData_latest.activeWaterSensorName];
            break;
            
        case 3:
            if (platformData_latest.lowerLimitSwitchStatus)
                text = @"Lower ls is reached";
            else
                text = @"Lower ls is not reached";
            break;
            
        case 4:
            if (platformData_latest.upperLimtSwitchStatus)
                text = @"Upper ls is reached";
            else
                text = @"Upper ls is not reached";
            break;
            
        default:
            text = @"Error!";
            break;
    }
    
    cell.textLabel.text = text;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
