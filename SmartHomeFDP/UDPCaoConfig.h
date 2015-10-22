//
//  UDPCaoConfig.h
//  SmartHomeFDP
//
//  Created by cisl on 15/9/22.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"
@interface UDPCaoConfig : NSObject<AsyncUdpSocketDelegate>{
    AsyncUdpSocket *udpSocket;
}


-(void)initUDPCaoConfig;

@end
