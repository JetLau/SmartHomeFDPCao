//
//  BtnStudyViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 14-11-9.
//  Copyright (c) 2014年 eddie. All rights reserved.
//
#import "BLDeviceInfo.h"
@interface BtnStudyViewController : UIViewController
@property (nonatomic, strong) BLDeviceInfo * info;
@property (nonatomic, assign) int rmDeviceIndex;
@property (nonatomic, assign) int btnId;

@property (strong, nonatomic) IBOutlet UITextField *vocieTextField;
- (IBAction)studyBtnClicked:(UIButton *)sender;
- (IBAction)saveVoiceTextBtnClicked:(id)sender;

@end
