//
//  NetworkStatus.h
//  SmartHomeFDP
//
//  Created by cisl on 15/10/26.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkStatus : NSObject
#pragma mark public static methods

+ (NetworkStatus *)sharedNetworkStatus;
- (NSString *)getCurrentWiFiSSID;

@end
