//
//  LJHotStatusViewController.h
//  NewProject
//
//  Created by eddie on 14-9-4.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLDeviceInfo.h"
@interface DeviceViewController : UIViewController
//plist中模版设备device的item编号
@property(assign,nonatomic)int rmDeviceIndex;
//当前学习所用的RM2
@property (nonatomic, strong) BLDeviceInfo *info;
@property (nonatomic, assign) int btnId;

-(int)addDevice;
- (IBAction)buttonClicked:(UIButton *)sender;

- (IBAction)btnLongPress:(UILongPressGestureRecognizer *)sender;

@end
