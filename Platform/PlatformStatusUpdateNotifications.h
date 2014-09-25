//
//  PlatformStatusUpdateNotifications.h
//  Platform
//
//  Created by Johnny Verhoeff on 24-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#ifndef Platform_PlatformStatusUpdateNotifications_h
#define Platform_PlatformStatusUpdateNotifications_h

#import "Platform.h"


@protocol PlatformStatusUpdateNotifications <NSObject>

- (void)platformDidFinishUpdatingProgramState:(NSString *)state_name;
- (void)platformDidFinishUpdatingActiveWaterSensor:(NSString *)sensor_name;

- (void)platformDidFinishUpdatingUpperLimitSwitchStatus:(BOOL)state;
- (void)platformDidFinishUpdatingLowerLimitSwitchStatus:(BOOL)state;

- (void)platformDidFinishUpdatingButtonsStatus:(NSArray *)buttons;

- (void)platformDidOccurError;

@end


#endif
