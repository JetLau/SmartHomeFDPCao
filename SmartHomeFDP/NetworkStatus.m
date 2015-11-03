//
//  NetworkStatus.m
//  SmartHomeFDP
//
//  Created by cisl on 15/10/26.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "NetworkStatus.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation NetworkStatus


static NetworkStatus *networkStatus = nil;

#pragma mark public static methods


+ (NetworkStatus *)sharedNetworkStatus {
    @synchronized(self) {
        if(networkStatus == nil) {
            networkStatus = [[[self class] alloc] init];
        }
    }
    return networkStatus;
}

/*获取当前连接的wifi网络名称，如果未连接，则为nil*/
- (NSString *)getCurrentWiFiSSID
{
    CFArrayRef ifs = CNCopySupportedInterfaces();       //得到支持的网络接口 eg. "en0", "en1"
    
    if (ifs == NULL)
        return nil;
    
    CFDictionaryRef info = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(ifs, 0));
    
    CFRelease(ifs);
    
    if (info == NULL)
        return nil;
    
    NSDictionary *dic = (__bridge_transfer NSDictionary *)info;
    
    // If ssid is not exist.
    if ([dic isEqual:nil])
        return nil;
    
    NSString *ssid = [dic objectForKey:@"SSID"];
    
    return ssid;
}
@end
