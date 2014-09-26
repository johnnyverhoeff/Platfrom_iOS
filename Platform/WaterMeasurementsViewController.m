//
//  WaterMeasurementsViewController.m
//  Platform
//
//  Created by Johnny Verhoeff on 25-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import "WaterMeasurementsViewController.h"
#import "Platform.h"
#import "TabBarController.h"
#import "WaterMeasurement.h"

@interface WaterMeasurementsViewController ()

@end

@implementation WaterMeasurementsViewController {
    Platform *platform;
    WaterMeasurement *measurement_latest;
    NSTimer *timer;
    BOOL timer_running;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    TabBarController *tab = (TabBarController *)self.navigationController.tabBarController;
    
    platform = tab.platform;
    platform.waterMeasurementsDelegate = self;
    
    self.progressBar.progress = 0.0;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [self startTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    timer_running = YES;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(timerStartStopButton:)] ;
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)stopTimer {
    [timer invalidate];
    timer = nil;
    timer_running = NO;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(timerStartStopButton:)] ;
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - Buttons

- (IBAction)refreshButton:(id)sender {
    [platform updateWaterMeasurer];
}

- (IBAction)timerStartStopButton:(id)sender {
    if (timer_running) {
        [self stopTimer];
    } else {
        [self startTimer];        
    }
}

- (void)update {
    NSLog(@"timer");
    [platform updateWaterMeasurer];
}

#pragma mark - Water measurer delegate 

- (void)waterMeasurementDidFinishUpdating:(WaterMeasurement *)measurement {
    NSLog(@"%hhd", measurement.sampleInProgress);
    NSLog(@"current_sample: %i", measurement.currentSample);
    NSLog(@"total_samples: %i", measurement.totalSamples);
    
    self.progressBar.progress = (float)measurement.currentSample / (float)measurement.totalSamples;
    
    measurement_latest = measurement;
    [self.tableView reloadData];
    
}

- (void)waterMeasurementDidOccurError {
    
    [self stopTimer];
}

#pragma mark - Calculations

- (float)calculateRemainingTime:(WaterMeasurement *)measurement {
    NSInteger remainingSamples = measurement.totalSamples - measurement.currentSample;
    float remainingTime = (float)remainingSamples * (float)measurement.sampleTime / 10.0;
    return remainingTime;
}

- (NSString *)calculateCurrentDecision:(WaterMeasurement *)measurement {
    float water_rising_percentage = measurement.waterRisingHits * 100.0 / measurement.currentSample;
    float water_dropping_percentage = measurement.waterDroppingHits * 100.0 / measurement.currentSample;
    
    if (water_dropping_percentage <= measurement.lowerThreshold && water_rising_percentage >= measurement.upperThreshold)
        return @"Up";
    else if (water_dropping_percentage >= measurement.upperThreshold && water_rising_percentage <= measurement.lowerThreshold)
        return @"Down";
    else
        return @"Stay";
}

#pragma mark - UITableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *text;
    
    switch (indexPath.row) {
            
        case 0:
            text = [NSString stringWithFormat:@"Current decision: %@", [self calculateCurrentDecision:measurement_latest]];
            break;
        
        case 1:
            text = [NSString stringWithFormat:@"Remaining time: %.02f s", [self calculateRemainingTime:measurement_latest]];
            break;
            
        case 2:
            text = [NSString stringWithFormat:@"Total samples: %i", measurement_latest.totalSamples];
            break;
            
        case 3:
            text = [NSString stringWithFormat:@"Current Sample: %i", measurement_latest.currentSample];
            break;
            
        case 4:
            text = [NSString stringWithFormat:@"Dropping hits: %i", measurement_latest.waterDroppingHits];
            break;
            
        case 5:
            text = [NSString stringWithFormat:@"Rising hits: %i", measurement_latest.waterRisingHits];
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
