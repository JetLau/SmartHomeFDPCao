//
//  NSObject+InitBroadLink.h
//  SmartHomeFDP
//
//  Created by cisl on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLNetwork.h"
#import "BLDeviceInfo.h"

@interface InitBroadLink : NSObject
//@property (nonatomic, strong) BLDeviceInfo *info;
@property (nonatomic, strong) BLNetwork *network;

+ (instancetype)initBroadLinkDevices;

- (void)networkInit;
- (void)listRefresh;
- (void)addAllDevices;
-(NSMutableArray*)readDeviceInfoFromPlist;
-(void)saveDeviceInfoToPlist :(NSMutableArray *) deviceArray;

-(void)startConfig:(NSString *)wifi password:(NSString *)password;
-(void)cancelConfig;

@end
