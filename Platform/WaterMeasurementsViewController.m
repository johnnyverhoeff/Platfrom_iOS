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
}

- (void)stopTimer {
    [timer invalidate];
    timer = nil;
    timer_running = NO;
}

#pragma mark - Buttons

- (IBAction)refreshButton:(id)sender {
    [platform updateWaterMeasurer];
}

- (IBAction)timerStartStopButton:(id)sender {
    if (timer_running) {
        [self stopTimer];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(timerStartStopButton:)] ;
        self.navigationItem.rightBarButtonItem = barButtonItem;
        
    } else {
        [self startTimer];
        
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(timerStartStopButton:)] ;
        self.navigationItem.rightBarButtonItem = barButtonItem;
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

}
@end
