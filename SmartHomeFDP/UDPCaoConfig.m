//
//  UDPCaoConfig.m
//  SmartHomeFDP
//
//  Created by cisl on 15/9/22.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "UDPCaoConfig.h"
#import "BLDeviceInfo.h"
#import "BLDeviceManager.h"
#import "JSONKit.h"
#import "MJExtension.h"
@implementation UDPCaoConfig
- (void)initUDPCaoConfig{
    
    udpSocket=[[AsyncUdpSocket alloc]initWithDelegate:self];
    NSError *error = nil;
    
    [udpSocket enableBroadcast:YES error:&error];
    [udpSocket bindToPort:16747 error:&error];
    
    NSTimeInterval timeout=5000;
    
    NSString *request=@"www.usr.cn";
    
    NSData *data=[NSData dataWithData:[request dataUsingEncoding:NSASCIIStringEncoding] ];
    
    UInt16 port=48899;
    
    
    
    
    [udpSocket sendData :data toHost:@"192.168.1.255" port:port withTimeout:timeout tag:0];
    
    [udpSocket receiveWithTimeout:-1 tag:0];
    
    NSLog(@"begin scan");
    
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    
    NSString* result;
    
    result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSArray *resultArray = [result componentsSeparatedByString:NSLocalizedString(@",", nil)];
    NSLog(@"didReceiveData:%@",resultArray);
    

    BLDeviceInfo *info = [[BLDeviceInfo alloc] init];
    //对应曹设备mac
    [info setMac:[resultArray objectAtIndex:1]];
    //对应曹设备version
    [info setType:[resultArray objectAtIndex:3]];
    //对应曹设备模块名称MID
    [info setName:[resultArray objectAtIndex:2]];
    //对应曹设备IP
    [info setIp:[resultArray objectAtIndex:0]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:info];
    [self saveDeviceInfoToPlist:[NSMutableArray arrayWithArray:[BLDeviceInfo keyValuesArrayWithObjectArray:array]]];
    NSLog(@"received");
    return TRUE;
    
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"not received");
    
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"%@",error);
    
    NSLog(@"not send");
    
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    NSLog(@"send");
    
}

-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    
    NSLog(@"closed");
    
}

-(NSMutableArray*)readDeviceInfoFromPlist
{
    
    BLDeviceManager *blDevManager = [BLDeviceManager createBLDeviceManager];
    return [blDevManager readBLDeviceInfoFromPlist];
}

-(void)saveDeviceInfoToPlist :(NSMutableArray *) deviceArray
{
    BLDeviceManager *blDevManager = [BLDeviceManager createBLDeviceManager];
    [blDevManager saveBLDeviceInfoToPlist:deviceArray];
}


@end
