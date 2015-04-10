//
//  BLDeviceManager.h
//  SmartHomeFDP
//
//  Created by cisl on 15-1-15.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLDeviceManager : NSObject


@property(strong,nonatomic)NSString *path;
@property(strong,nonatomic)NSString *docPath;

@property(strong,nonatomic)NSMutableArray *BLDeviceArray;

+(instancetype) createBLDeviceManager;
-(NSMutableArray*)readBLDeviceInfoFromPlist;
-(void)saveBLDeviceInfoToPlist :(NSMutableArray *) deviceArray;
-(void)removeBLDevcie:(int)index;
@end
