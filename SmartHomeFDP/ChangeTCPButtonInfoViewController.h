//
//  ChangeTCPButtonInfoViewControl.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-23.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCPDevice;

@interface ChangeTCPButtonInfoViewController : UIViewController

@property(strong,nonatomic)TCPDevice *deviceInfo;
@property int buttonTag;

@property(strong,nonatomic)IBOutlet UITextField *buttonNameField;
@property(strong,nonatomic)IBOutlet UITextField *buttonInfoField;

-(IBAction)saveButtonNameClick:(id)sender;
-(IBAction)saveButtonInfoClick:(id)sender;

@end
