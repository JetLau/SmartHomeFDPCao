//
//  RMDeviceManage.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMDevice;

@interface RMDeviceManager : NSObject

@property(strong,nonatomic)NSString *path;
@property(strong,nonatomic)NSMutableArray *RMDeviceArray;

-(void)initRMDeviceManage;
-(int)getRMDeviceCount;
-(RMDevice *)getRMDevice:(int)index;
//-(int)writeRMDeviceInfoIntoFile:(RMDevice *)rmDevice;
-(int)addRMDeviceInfoIntoFile:(RMDevice *)rmDevice;
-(void)removeRMDevice:(int)index;
-(BOOL)saveSendData:(int)rmDeviceIndex btnId:(int)btnId sendData:(NSString*)data;
-(BOOL)saveVoiceInfo:(int)rmDeviceIndex btnId:(int)btnId voiceInfo:(NSString*)voiceInfo
;
@end
