//
//  PlatformData.h
//  Platform
//
//  Created by Johnny Verhoeff on 27-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#ifndef Platform_PlatformData_h
#define Platform_PlatformData_h


@interface PlatformData : NSObject

@property NSString *programStateName;
@property NSString *activeWaterSensorName;
@property NSString *movingStateName;

@property BOOL upperLimtSwitchStatus;
@property BOOL lowerLimitSwitchStatus;

@property NSArray *buttonsStates;

@end

#endif
