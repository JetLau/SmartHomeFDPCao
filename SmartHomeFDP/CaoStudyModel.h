//
//  CaoStudyModel.h
//  SmartHomeFDP
//
//  Created by cisl on 15/9/22.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLDeviceInfo.h"
#import "RMDevice.h"
#import "SmartHomeAPIs.h"
@interface CaoStudyModel : NSObject

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

- (NSString *)caoStudyModelStart;
- (NSString *)caoGetControlData;
- (NSString *)caoSendControlData:(NSString *)data;
@end
