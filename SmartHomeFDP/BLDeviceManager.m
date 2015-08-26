//
//  BLDeviceManager.m
//  SmartHomeFDP
//
//  Created by cisl on 15-1-15.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "BLDeviceManager.h"
#import "BLDeviceInfo.h"
#import "MJExtension.h"

@implementation BLDeviceManager

+(instancetype) createBLDeviceManager
{
    BLDeviceManager * blDeviceManager = [[BLDeviceManager alloc]init];
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:@"username"];
    blDeviceManager.docPath = [doc stringByAppendingPathComponent:userName];
    blDeviceManager.path = [blDeviceManager.docPath stringByAppendingPathComponent:@"DeviceInfo.plist"];
    //self.path=[[NSBundle mainBundle]pathForResource:@"RMDeviceInfo" ofType:@"plist"];
    
    NSLog(@"path = %@",blDeviceManager.path);
    [blDeviceManager readBLArrayInfoFromFile];
    return blDeviceManager;
}

-(void)initBLDeviceManage
{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:@"username"];
    self.docPath = [doc stringByAppendingPathComponent:userName];
    self.path = [self.docPath stringByAppendingPathComponent:@"DeviceInfo.plist"];
    //self.path=[[NSBundle mainBundle]pathForResource:@"RMDeviceInfo" ofType:@"plist"];
    
    //NSLog(@"%@",self.path);
    [self readBLArrayInfoFromFile];
}

-(BOOL)BLDeviceInfoPlistExist
{
    NSFileManager *fileManager;
    fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.path isDirectory:NO];
}

-(BOOL) userDocIsExist
{
    NSFileManager *fileManager;
    fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:self.docPath isDirectory:NO];
}

-(void)createBLDeviceInfoPlist
{
    BOOL plistExist=[self BLDeviceInfoPlistExist];
    if(!plistExist)
    {
        NSFileManager *fileManager;
        fileManager=[NSFileManager defaultManager];
        
        [fileManager createFileAtPath:self.path contents:nil attributes:nil];
    }
}

-(void)readBLArrayInfoFromFile
{
    BOOL docIsExist = [self userDocIsExist];
    if (!docIsExist) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // 创建目录
        [fileManager createDirectoryAtPath:self.docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        BOOL plistExist=[self BLDeviceInfoPlistExist];
        if(!plistExist)
        {
            self.BLDeviceArray=[[NSMutableArray alloc]init];
        }
        else
        {
            self.BLDeviceArray=[[NSMutableArray alloc]initWithContentsOfFile:self.path];
        }
    }
    
    
}

-(NSMutableArray*)readBLDeviceInfoFromPlist
{
    NSArray *devicesArray;
    if ([self.BLDeviceArray count] != 0) {
        devicesArray=[BLDeviceInfo objectArrayWithKeyValuesArray:self.BLDeviceArray];
    }
    
    //NSLog(@"读取数据  %@",devicesArray);
    
    if (devicesArray != nil) {
        return  [[NSMutableArray alloc] initWithArray:devicesArray];
    }else{
        return [[NSMutableArray alloc] init];
    }
}

-(void)saveBLDeviceInfoToPlist :(NSMutableArray *) deviceArray
{
    NSMutableArray *deviceDicArray = [[NSMutableArray alloc]init];
    for (NSDictionary *item in deviceArray)
    {
//        int i;
//        BLDeviceInfo *info = [[BLDeviceInfo alloc] init];
//        [info setMac:[item objectForKey:@"mac"]];
//        [info setType:[item objectForKey:@"type"]];
//        [info setName:[item objectForKey:@"name"]];
//        [info setId:[[item objectForKey:@"id"] intValue]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[item objectForKey:@"mac"] forKey:@"mac"];
        [dic setObject:[item objectForKey:@"type"] forKey:@"type"];
        [dic setObject:[item objectForKey:@"name"] forKey:@"name"];
        [dic setObject:[item objectForKey:@"id"] forKey:@"id"];
        
        [deviceDicArray addObject:dic];
    }
    
    self.BLDeviceArray = nil;
    self.BLDeviceArray = deviceDicArray;

    [self.BLDeviceArray writeToFile:self.path atomically:YES];

}

-(void)removeBLDevcie:(int)index
{
    [self.BLDeviceArray removeObjectAtIndex:index];
    [self.BLDeviceArray writeToFile:self.path atomically:YES];
}



@end
