//
//  AddDevViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UDPEasyConfig;
@class BLEasyConfig;
@class InitBroadLink;

@interface AddDeviceViewController : UIViewController

@property(nonatomic,strong)NSString *wifi;
@property(nonatomic,strong)NSString *password;
@property(nonatomic)BOOL startConfig;
@property(strong,nonatomic)UDPEasyConfig *udpEasyConfig;
@property(strong,nonatomic)InitBroadLink *blEasyConfig;

@property(nonatomic,strong)IBOutlet UITextField *wifiTextField;
@property(nonatomic,strong)IBOutlet UITextField *passwordTextField;
@property(nonatomic,strong)IBOutlet UIButton *searchButton;
@property(nonatomic,strong)IBOutlet UISegmentedControl *segmentControl;
@property int segmentIndex;

-(IBAction)searchButtonClick:(id)sender;

@end
