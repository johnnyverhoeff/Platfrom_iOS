//
//  ViewController.h
//  Platform
//
//  Created by Johnny Verhoeff on 21-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

- (IBAction)buttonPressed:(id)sender;
- (IBAction)stopButtonPressed:(id)sender;

- (IBAction)getStatus:(id)sender;

- (IBAction)selectWaterSensor:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *programStateLabel;


@property (strong, nonatomic) IBOutlet UIPickerView *waterSensorPicker;



@end

