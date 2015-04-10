//
//  BLEasyConfig.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-11.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "UDPEasyConfig.h"
#import "JSONKit.h"
#import "GCDAsyncUdpSocket.h"
#import "ProgressHUD.h"

#define udpHost "10.10.100.254"
#define udpPort 49000

@interface UDPEasyConfig()

@end

@implementation UDPEasyConfig
@synthesize udpSocket;

-(void)initEasyConfig
{
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)startConfig:(NSString *)wifi password:(NSString *)password
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        char context[[wifi length]+[password length]+8];
        [self getHexDecimalContext:wifi password:password context:context];
        NSData *data=[NSData dataWithBytes:context length:[wifi length]+[password length]+8];
        
        [udpSocket sendData:data toHost:@udpHost port:udpPort withTimeout:-1 tag:0];
        
        NSError *receiveError = nil;
        [udpSocket beginReceiving:&receiveError];
        
        dispatch_async(dispatch_get_main_queue(), ^{

//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[responseData objectFromJSONData] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
        });
    });
}

-(void)getHexDecimalContext:(NSString *)wifi password:(NSString *)password context:(char *)context
{
    //报头
    char head=0xFF;
    
    //长度
    int length=[wifi length]+[password length]+4;
    char len1=(length/256)&0xFF;
    char len2=(length%256)&0xFF;
    
    //命令字
    char command=0x02;
    
    //保留字
    char unUsed=0x00;
    
    //SSID
    char ssidContext[[wifi length]];
    [self getHexDecimal:wifi context:ssidContext];
    
    //分隔符
    char delimiter1=0x0D;
    char delimiter2=0x0A;
    
    //密码
    char pwdContext[[password length]];
    [self getHexDecimal:password context:pwdContext];
    
    //校验字
    
    //组装报文
    int i=0;
    context[i++]=head;
    context[i++]=len1;
    context[i++]=len2;
    context[i++]=command;
    context[i++]=unUsed;
    
    for(int j=0;j<[wifi length];j++)
    {
        context[i++]=ssidContext[j];
    }
    
    context[i++]=delimiter1;
    context[i++]=delimiter2;
    
    for(int j=0;j<[password length];j++)
    {
        context[i++]=pwdContext[j];
    }

    //校验字
    Byte byte=0x00;
    for(int j=1;j<i;j++)
    {
        Byte ch=context[j] &0xFF;
        byte+=ch;
    }
    
    context[i]=byte&0xFF;
}

-(void)getHexDecimal:(NSString *)s context:(char *)context
{
    int len=[s length];
    for(int i=0;i<len;i++)
    {
        char ch=[s characterAtIndex:i] & 0xFF;
        context[i]=ch;
    }
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"sendata success,tag=%lu",tag);
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"sendata fail,tag=%lu",tag);
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    Byte *byte=(Byte *)[data bytes];
    
    if(byte==nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showSuccess:@"UDP配置失败"];
        });
        return;
    }
    
    if(byte[4]==1&&byte[5]==1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showSuccess:@"UDP配置成功"];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showSuccess:@"UDP配置失败"];
        });
    }
    
    NSLog(@"receive data from udp,%@",data);
}

@end
