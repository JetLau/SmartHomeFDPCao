//
//  BLRM2StudyModel.h
//  BroadLinkSDKDemo
//
//  Created by cisl on 14-10-27.
//  Copyright (c) 2014年 BroadLink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLNetwork.h"
#import "BLDeviceInfo.h"
#import "RMDevice.h"
#import "SmartHomeAPIs.h"
#define remoteQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@interface BLRM2StudyModel : NSObject

@property (nonatomic, strong) BLDeviceInfo *info;
@property (nonatomic,strong) NSDictionary *btnDic;
@property (nonatomic, strong) RMDevice *rmDevice;
@property (nonatomic, assign) int btnId;

- (instancetype)initWithArgument :(BLDeviceInfo*)info;
- (instancetype)initWithBLDeviceInfo :(BLDeviceInfo*)info  btnDic:(NSDictionary*) btnDic btnId:(int)btnId;
+ (instancetype)studyModelWithArgument :(BLDeviceInfo*)info;
+ (instancetype)studyModelWithBLDeviceInfo :(BLDeviceInfo*)info btnDic:(NSDictionary*) btnDic btnId:(int)btnId;

- (instancetype)initWithBLDeviceInfo :(BLDeviceInfo*)info  rmDevice:(RMDevice*) rmDevice btnId:(int)btnId;
+ (instancetype)studyModelWithBLDeviceInfo :(BLDeviceInfo*)info rmDevice:(RMDevice*) rmDevice btnId:(int)btnId;

- (NSString *)rm2StudyModelStart;
- (NSString *)rm2GetControlData;
- (NSString *)rm2SendControlData:(NSString *)data;
@end
