//
//  ProgramStates.h
//  Platform
//
//  Created by Johnny Verhoeff on 21-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#ifndef Platform_ProgramStates_h
#define Platform_ProgramStates_h

enum ProgramStates {
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

#endif
