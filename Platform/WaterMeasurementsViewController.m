//
//  WaterMeasurementsViewController.m
//  Platform
//
//  Created by Johnny Verhoeff on 25-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import "WaterMeasurementsViewController.h"
#import "Platform.h"


@interface WaterMeasurementsViewController ()

@end

@implementation WaterMeasurementsViewController {
    Platform *platform;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    platform = [[Platform alloc] initWithStandardWaterSensors];
    platform.waterMeasurementsDelegate = self;
    
    platform.url = @"http://192.168.215.177";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)refreshButton:(id)sender {
    [platform updateWaterMeasurer];
}

#pragma mark - Water measurer delegate 

- (void)waterMeasurerDidFinishUpdatingTotalSamples:(NSInteger)samples {
    NSLog(@"Samples: %i", samples);
}
@end
