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
#import <ifaddrs.h>
#import <arpa/inet.h>
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
    
    NSString *broadCastIP = [NSString stringWithFormat:@"%@255",[[self getIPAddress] substringToIndex:10]];
    NSLog(@"broadCastIP==%@",broadCastIP);

    [udpSocket sendData :data toHost:broadCastIP port:port withTimeout:timeout tag:0];
    
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
    NSString *ipStr = [resultArray objectAtIndex:1];
    NSString *string = [ipStr substringWithRange:NSMakeRange(0,2)];
    
    for(int i=2;i<=10;i+=2){
        string = [string stringByAppendingFormat:@":%@",[ipStr substringWithRange:NSMakeRange(i,2)]];
    }
    NSLog(@"string = %@",string);
    
    
    [info setMac:string];
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

    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetIpNotification" object:self userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:@"成功获取",@"result",nil]];
    
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


- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;}
@end
