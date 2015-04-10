//
//  TCPDevice.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-22.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCPDevice : NSObject

@property(strong,nonatomic)NSNumber *tcpDev_id;
@property(strong,nonatomic)NSString *tcpDev_mac;
@property(strong,nonatomic)NSString *tcpDev_name;
@property(strong,nonatomic)NSNumber * tcpDev_state;
@property(strong,nonatomic)NSString *tcpDev_type;

@property(strong,nonatomic)NSMutableArray *buttonArray;

@end
