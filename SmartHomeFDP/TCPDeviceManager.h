//
//  TCPDeviceManager.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-22.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCPDeviceManager : NSObject

@property(strong,nonatomic)NSMutableArray *TCPDeviceArray;
@property(strong,nonatomic)NSString *docPath;
@property(strong,nonatomic)NSString *path;

+(instancetype)createTCPDeviceManager;
-(void)saveTCPDeviceInfoToFile:(NSArray *)deviceArray;
-(int)saveTCPDeviceNameIntoFile:(int)deviceId name:(NSString *)name;
-(int)saveTCPButtonNameIntoFile:(int)deviceId buttonId:(int)buttonId name:(NSString *)name;
-(int)saveTCPButtonInfoIntoFile:(int)deviceId buttonId:(int)buttonId info:(NSString *)info;
-(NSDictionary *)getRMButton:(int)deviceId btnId:(int)btnId;
-(void) removeTCPDevcie:(int)index;

@end
