//
//  CaoConfig.h
//  SmartHomeFDP
//
//  Created by cisl on 15/8/25.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SmartConfigDiscoverMDNS.h"
#import "FirstTimeConfig.h"
@interface CaoConfig : NSObject
@property(strong,nonatomic) NSString *wifiSSID;
@property(strong,nonatomic) NSString *password;
@property ( nonatomic) FirstTimeConfig *firstTimeConfig;

@property (weak, nonatomic) NSTimer *mdnsTimer;
//@property (retain) NSTimer *updateTimer;
@property (retain, atomic) NSData *freeData;
@property (nonatomic) SmartConfigDiscoverMDNS *mdnsService;

-(void)startConfig:(NSString *)wifi password:(NSString *)password;
-(void) stopDiscovery;
@end
