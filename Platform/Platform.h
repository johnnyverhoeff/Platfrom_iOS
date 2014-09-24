//
//  Platform.h
//  Platform
//
//  Created by Johnny Verhoeff on 22-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#ifndef Platform_Platform_h
#define Platform_Platform_h

@protocol PlatformStatusUpdateNotifications;

enum program_states {
    none = 0,
    reach_active_water_sensor,
    reach_and_control_vlonder_on_active_water_sensor,
    control_vlonder_on_active_water_sensor,
    
    reach_upper_limit_switch,
    reach_lower_limit_switch,
    
    web_control_manual_up,
    web_control_manual_down,
    
    remote_control_manual_up,
    remote_control_manual_down,
    
};


@interface Platform : NSObject <NSURLConnectionDataDelegate> {
    NSMutableData *_responseData;
}


@property (nonatomic, assign) id<PlatformStatusUpdateNotifications> delegate;

@property (copy) NSString *url;
@property (copy) NSArray *waterSensors;

- (id)initWithStandardWaterSensors;

- (void)updateStatus;

- (NSString *)getStateNameForState:(enum program_states)state;

- (void)setProgramStateTo:(enum program_states)newState;

- (void)setWaterSensorTo:(NSInteger)newSensor;

@end

#endif
