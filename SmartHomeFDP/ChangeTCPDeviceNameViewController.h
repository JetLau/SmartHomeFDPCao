//
//  ChangeTCPDeviceNameViewController.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-23.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCPDevice;

@interface ChangeTCPDeviceNameViewController : UIViewController

@property(strong,nonatomic)TCPDevice *deviceInfo;

@property(strong,nonatomic)IBOutlet UITextField *deviceNameField;

@end