//
//  Platform.h
//  Platform
//
//  Created by Johnny Verhoeff on 22-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#ifndef Platform_Platform_h
#define Platform_Platform_h

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

@interface Platform : NSObject

+ (NSString *)getUrl;
+ (void)setUrlTo:(NSString *)newUrl;

+ (NSArray *)getWaterSensors;
+ (void)setWaterSensorsTo:(NSArray *)newSensors;

+ (NSString *)getStateNameForState:(enum program_states)state;

+ (NSString *)getProgramState;

+ (NSString *)getActiveWaterSensor;

+ (void)setProgramStateTo:(enum program_states)newState;

+ (void)setWaterSensorTo:(NSInteger)newSensor;

@end

#endif
