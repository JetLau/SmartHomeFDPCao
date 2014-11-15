//
//  OEMSLoginViewController.h
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-5-28.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginInButtonClicked:(id)sender;

@end
