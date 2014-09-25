//
//  WaterMeasurementsUpdateNotifications.h
//  Platform
//
//  Created by Johnny Verhoeff on 25-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#ifndef Platform_WaterMeasurementsUpdateNotifications_h
#define Platform_WaterMeasurementsUpdateNotifications_h


@protocol WaterMeasurementsUpdateNotifications <NSObject>

- (void)waterMeasurerDidFinishUpdatingTotalSamples:(NSInteger)samples;

@end

#endif
