//
//  WaterMeasurementsViewController.h
//  Platform
//
//  Created by Johnny Verhoeff on 25-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import "ViewController.h"

#import "WaterMeasurementsUpdateNotifications.h"


@interface WaterMeasurementsViewController : ViewController <WaterMeasurementsUpdateNotifications,UITableViewDelegate, UITableViewDataSource>

- (IBAction)refreshButton:(id)sender;
- (IBAction)timerStartStopButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
