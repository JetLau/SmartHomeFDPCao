//
//  StatisticFileManager.m
//  SmartHomeFDP
//
//  Created by cisl on 14-12-22.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "StatisticFileManager.h"
@interface StatisticFileManager()
{}
@property(strong,nonatomic)NSString *path;
@property(strong,nonatomic)NSMutableArray * statisticArray;
@end


@implementation StatisticFileManager
+(instancetype)createStatisticManager
{
    StatisticFileManager *statisticManager = [[StatisticFileManager alloc] init];
    //NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    statisticManager.path = [[NSBundle mainBundle]pathForResource:@"StatisticInfo" ofType:@"plist"];
    NSLog(@"statistic path:%@",statisticManager.path);
    [statisticManager readStatisticArray];
    return  statisticManager;
}

-(void)readStatisticArray
{
    BOOL plistIsExist = [self StatisticFileIsExist];
    if (plistIsExist) {
        self.statisticArray = [[NSMutableArray alloc] initWithContentsOfFile:self.path];
    }else{
        self.statisticArray = [[NSMutableArray alloc] init];
    }
}

-(BOOL)StatisticFileIsExist
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:NO];
}

-(void)statisticOperateWithType:(NSString*)type andBtnId:(int)btnId
{
    NSMutableDictionary *typeInfo;
    int index;
    if ([type isEqualToString:@"TV"]) {
        index=0;
        typeInfo = [self.statisticArray objectAtIndex:0];
    } else if ([type isEqualToString:@"AirCondition"]) {
        index=1;
        typeInfo = [self.statisticArray objectAtIndex:1];
    }else if ([type isEqualToString:@"Curtain"]) {
        index=2;
        typeInfo = [self.statisticArray objectAtIndex:2];
    }else if ([type isEqualToString:@"Projector"]) {
        index=3;
        typeInfo = [self.statisticArray objectAtIndex:3];
    }else if ([type isEqualToString:@"Custom"]) {
        index=4;
        typeInfo = [self.statisticArray objectAtIndex:4];
    }else if ([type isEqualToString:@"Voice"]) {
        index=5;
        typeInfo = [self.statisticArray objectAtIndex:5];
    }else if ([type isEqualToString:@"light"]) {
        index=6;
        typeInfo = [self.statisticArray objectAtIndex:6];
    }else{
        return;
    }
    
    int times;
    
    if (![type isEqualToString:@"Custom"] && ![type isEqualToString:@"Voice"]) {
        times= [[typeInfo objectForKey:@"times"] intValue] + 1;
        [typeInfo setValue:[NSNumber numberWithInt:times] forKey:@"times"];

        NSMutableArray *arrayBtn = [typeInfo objectForKey:@"buttonArray"];
        NSMutableDictionary * dicBtn = [arrayBtn objectAtIndex:btnId];
        times = [[dicBtn objectForKey:@"times"] intValue] + 1;
        [dicBtn setValue:[NSNumber numberWithInt:times] forKey:@"times"];
        [arrayBtn replaceObjectAtIndex:btnId withObject:dicBtn];
        [typeInfo setValue:arrayBtn forKey:@"buttonArray"];
    }else if ([type isEqualToString:@"Custom"])
    {
        times= [[typeInfo objectForKey:@"times"] intValue] + 1;
        [typeInfo setValue:[NSNumber numberWithInt:times] forKey:@"times"];
    }else if ([type isEqualToString:@"Voice"])
    {
        if (btnId == 0) {
            times= [[typeInfo objectForKey:@"successTimes"] intValue] + 1;
            [typeInfo setValue:[NSNumber numberWithInt:times] forKey:@"successTimes"];
        }else{
            times= [[typeInfo objectForKey:@"failTimes"] intValue] + 1;
            [typeInfo setValue:[NSNumber numberWithInt:times] forKey:@"failTimes"];
        }
        times= [[typeInfo objectForKey:@"times"] intValue] + 1;
        [typeInfo setValue:[NSNumber numberWithInt:times] forKey:@"times"];
    }
    [self.statisticArray replaceObjectAtIndex:index withObject:typeInfo];
    
    [self.statisticArray writeToFile:self.path atomically:YES];
}

-(NSMutableArray*) readStatisticInfo
{
    return self.statisticArray;
}
@end
