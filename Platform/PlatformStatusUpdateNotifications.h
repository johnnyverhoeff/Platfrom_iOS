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
#import "PlatformData.h"


@protocol PlatformStatusUpdateNotifications <NSObject>

- (void)platformDidFinishUpdatingData:(PlatformData *)data;

- (void)platformDidOccurError;

@end


#endif
