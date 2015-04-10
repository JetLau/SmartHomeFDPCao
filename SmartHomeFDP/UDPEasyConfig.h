//
//  BLEasyConfig.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-11.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"

@interface UDPEasyConfig : NSObject<GCDAsyncUdpSocketDelegate,UITextFieldDelegate>
{
    GCDAsyncUdpSocket *udpSocket;
}

@property(nonatomic,strong)GCDAsyncUdpSocket *udpSocket;

-(void)initEasyConfig;
-(void)startConfig:(NSString *)wifi password:(NSString *)password;

@end

