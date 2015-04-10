//
//  StatisticFileManager.h
//  SmartHomeFDP
//
//  Created by cisl on 14-12-22.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticFileManager : NSObject

+(instancetype)createStatisticManager;
-(void)statisticOperateWithType:(NSString*)type andBtnId:(int)btnId;
-(NSMutableArray*) readStatisticInfo;
@end
