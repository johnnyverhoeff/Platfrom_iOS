//
//  WaterMeasurement.h
//  Platform
//
//  Created by Johnny Verhoeff on 25-09-14.
//  Copyright (c) 2014 Johnny Verhoeff. All rights reserved.
//

#ifndef Platform_WaterMeasurement_h
#define Platform_WaterMeasurement_h

@interface WaterMeasurement : NSObject

@property NSInteger totalSamples;
@property NSInteger waterRisingHits;
@property NSInteger waterDroppingHits;
@property NSInteger samplePeriod;
@property NSInteger sampleTime;
@property NSInteger motorOnTime;
@property NSInteger lowerThreshold;
@property NSInteger upperThreshold;
@property BOOL sampleInProgress;
@property NSInteger currentSample;

@end


#endif
