//
//  DeviceInfoManagerForCell.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-24.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMDeviceManager;
@class TCPDeviceManager;

@interface DeviceInfoManagerForCell : NSObject

@property(strong,nonatomic)RMDeviceManager *rmDeviceManager;
@property(strong,nonatomic)TCPDeviceManager *tcpDeviceManager;

+(instancetype)createDeviceInfoManagerForCell;

@end
