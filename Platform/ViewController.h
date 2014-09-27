//
//  ViewController.h
//  Platform
//
//  Created by Johnny Verhoeff on 21-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlatformStatusUpdateNotifications.h"

@interface ViewController : UIViewController <UIActionSheetDelegate, PlatformStatusUpdateNotifications, UITableViewDataSource, UITableViewDelegate>

- (IBAction)reachUpperLSButton:(id)sender;
- (IBAction)reachLowerLSButton:(id)sender;

- (IBAction)selectWaterSensor:(id)sender;

- (IBAction)controlPlatfrom:(id)sender;
- (IBAction)reachAndControlPlatform:(id)sender;

- (IBAction)stopButtonPressed:(id)sender;

- (IBAction)getStatus:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

