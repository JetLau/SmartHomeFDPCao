//
//  LightViewController.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-23.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCPDevice;

@interface TCPDeviceViewController : UIViewController

@property(strong,nonatomic)TCPDevice *deviceInfo;


- (IBAction)buttonClicked:(UIButton *)sender;

- (IBAction)btnLongPress:(UILongPressGestureRecognizer *)sender;

@end
