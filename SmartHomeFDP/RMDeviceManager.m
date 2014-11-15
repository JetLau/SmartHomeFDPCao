//
//  RMDeviceManage.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "RMDeviceManager.h"
#import "RMDevice.h"
#import "RMButton.h"
#import "MJExtension.h"
@implementation RMDeviceManager

-(void)initRMDeviceManage
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.path = [doc stringByAppendingPathComponent:@"RMDeviceInfo.plist"];
    //self.path=[[NSBundle mainBundle]pathForResource:@"RMDeviceInfo" ofType:@"plist"];

    NSLog(@"%@",self.path);
    [self readRMDeviceInfoFromFile];
}

-(BOOL)RMDeviceInfoPlistExist
{
    NSFileManager *fileManager;
    fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.path isDirectory:NO];
}

-(void)createRMDeviceInfoPlist
{
    BOOL plistExist=[self RMDeviceInfoPlistExist];
    if(!plistExist)
    {
        NSFileManager *fileManager;
        fileManager=[NSFileManager defaultManager];
        
        [fileManager createFileAtPath:self.path contents:nil attributes:nil];
    }
}

-(void)readRMDeviceInfoFromFile
{
    BOOL plistExist=[self RMDeviceInfoPlistExist];
    if(!plistExist)
    {
        self.RMDeviceArray=[[NSMutableArray alloc]init];
    }
    else
    {
        self.RMDeviceArray=[[NSMutableArray alloc]initWithContentsOfFile:self.path];
    }
}

-(int)addRMDeviceInfoIntoFile:(RMDevice *)rmDevice
{
    NSMutableDictionary *deviceDic=[[NSMutableDictionary alloc]init];
    [deviceDic setValue:rmDevice.type forKey:@"type"];
    
    NSMutableArray *rmDeviceArray=[[NSMutableArray alloc]init];
    for(int i=0;i<[rmDevice.RMButtonArray count];i++)
    {
        RMButton *rmButton=[rmDevice.RMButtonArray objectAtIndex:i];
        NSMutableDictionary *rmDeviceDic=[[NSMutableDictionary alloc]init];
        [rmDeviceDic setObject:[[NSNumber alloc]initWithInt:rmButton.buttonId] forKey:@"buttonId"];
        [rmDeviceDic setObject:rmButton.sendData forKey:@"sendData"];
        [rmDeviceDic setObject:rmButton.buttonInfo forKey:@"buttonInfo"];
        [rmDeviceArray addObject:rmDeviceDic];
    }
    [deviceDic setValue:rmDeviceArray forKey:@"buttonArray"];

    [self.RMDeviceArray addObject:deviceDic];
    
    [self.RMDeviceArray writeToFile:self.path atomically:YES];
    
    //返回这个device是第几项
    return [self getRMDeviceCount]-1;
}

-(RMDevice *)getRMDevice:(int)index
{
    RMDevice *rmDevice=[[RMDevice alloc]init];
    NSDictionary *deviceDic=[self.RMDeviceArray objectAtIndex:index];
    
    NSString *type=[deviceDic objectForKey:@"type"];
    NSArray *buttonArray=[deviceDic objectForKey:@"buttonArray"];
    
    rmDevice.type=type;
    for(int i=0;i<[buttonArray count];i++)
    {
        RMButton *rmButton=[[RMButton alloc]init];
        NSDictionary *buttonDic=[buttonArray objectAtIndex:i];
        
        rmButton.buttonId=[[buttonDic objectForKey:@"buttonId"]intValue];
        rmButton.sendData=[buttonDic objectForKey:@"sendData"];
        rmButton.buttonInfo=[buttonDic objectForKey:@"buttonInfo"];
        
        [rmDevice.RMButtonArray addObject:rmButton];
    }
    
    return rmDevice;
}

-(void)removeRMDevice:(int)index
{
    [self.RMDeviceArray removeObjectAtIndex:index];
    
    if([self RMDeviceInfoPlistExist])
    {
        [self.RMDeviceArray writeToFile:self.path atomically:YES];
    }
    else
    {
        [self createRMDeviceInfoPlist];
        [self.RMDeviceArray writeToFile:self.path atomically:YES];
    }
}

-(int)getRMDeviceCount
{
    if(self.RMDeviceArray!=nil)
    {
        return [self.RMDeviceArray count];
    }
    else
    {
        return 0;
    }
}

-(BOOL)saveSendData:(int)rmDeviceIndex btnId:(int)btnId sendData:(NSString*)data
{
    NSMutableDictionary *dicDevices=[self.RMDeviceArray objectAtIndex:rmDeviceIndex];
    //RMDevice *device = [rmDeviceManager getRMDevice:super.rmDeviceIndex];
    NSMutableArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    //NSLog(@"arrayBtn %@",arrayBtn);
    NSMutableDictionary * dicBtn = [arrayBtn objectAtIndex:btnId];
    //NSLog(@"_rmDeviceIndex %i dicBtn %@",_rmDeviceIndex,dicBtn);
    [dicBtn setObject:data forKey:@"sendData"];
    
    //[dicBtn setValue:data forKey:@"sendData"];
    [arrayBtn replaceObjectAtIndex:btnId withObject:dicBtn];
    [dicDevices setObject:arrayBtn forKey:@"buttonArray"];
    [self.RMDeviceArray replaceObjectAtIndex:rmDeviceIndex withObject:dicDevices];
    return [self.RMDeviceArray writeToFile:self.path atomically:YES];

}

-(BOOL)saveVoiceInfo:(int)rmDeviceIndex btnId:(int)btnId voiceInfo:(NSString*)voiceInfo
{
    NSMutableDictionary *dicDevices=[self.RMDeviceArray objectAtIndex:rmDeviceIndex];
    //RMDevice *device = [rmDeviceManager getRMDevice:super.rmDeviceIndex];
    NSMutableArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    //NSLog(@"arrayBtn %@",arrayBtn);
    NSMutableDictionary * dicBtn = [arrayBtn objectAtIndex:btnId];
    //NSLog(@"_rmDeviceIndex %i dicBtn %@",_rmDeviceIndex,dicBtn);
    [dicBtn setValue:voiceInfo forKey:@"buttonInfo"];
    [arrayBtn replaceObjectAtIndex:btnId withObject:dicBtn];
    [dicDevices setValue:arrayBtn forKey:@"buttonArray"];
    [self.RMDeviceArray replaceObjectAtIndex:rmDeviceIndex withObject:dicDevices];
    return [self.RMDeviceArray writeToFile:self.path atomically:YES];
    
}
@end
