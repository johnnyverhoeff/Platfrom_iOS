//
//  WaterMeasurementsViewController.h
//  Platform
//
//  Created by Johnny Verhoeff on 25-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#import "ViewController.h"

#import "WaterMeasurementsUpdateNotifications.h"


@interface WaterMeasurementsViewController : ViewController <WaterMeasurementsUpdateNotifications>

- (IBAction)refreshButton:(id)sender;

@end
