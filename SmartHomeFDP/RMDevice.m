//
//  RMDevice.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "RMDevice.h"
#import "RMButton.h"
#import "MJExtension.h"
@implementation RMDevice

+(instancetype) itemDevice
{
    RMDevice *rmDevice = [[RMDevice alloc] init];
    rmDevice.RMButtonArray = [[NSMutableArray alloc] init];
    return rmDevice;
}

-(void)addRMButton:(NSDictionary *)buttonDic
{
    if(self.RMButtonArray==nil)
    {
        self.RMButtonArray=[[NSMutableArray alloc]init];
    }
    
    RMButton *rmButton=[[RMButton alloc]init];
    rmButton.buttonId=[[buttonDic objectForKey:@"buttonId"]intValue];
    rmButton.sendData=[buttonDic objectForKey:@"sendData"];
    rmButton.buttonInfo=[buttonDic objectForKey:@"buttonInfo"];
    rmButton.btnName=[buttonDic objectForKey:@"btnName"];

    [self.RMButtonArray addObject:rmButton];
}
@end
