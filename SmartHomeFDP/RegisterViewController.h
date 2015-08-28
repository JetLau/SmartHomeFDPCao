//
//  RegisterViewController.h
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface RegisterViewController : UIViewController{

    __weak IBOutlet UITextField *username;
    __weak IBOutlet UITextField *password;
    __weak IBOutlet UITextField *verifyPassword;
    __weak IBOutlet UITextField *phone;
    __weak IBOutlet UISegmentedControl *addressSegment;
    __weak IBOutlet UISegmentedControl *genderSegment;
    __weak IBOutlet UITableView *addressTableView;
}

@property (strong, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic)UserInfo *user;

- (IBAction)registerBtnClicked:(UIButton *)sender;
- (IBAction)moveView:(UITextField *)sender;

@property(strong, nonatomic)NSDictionary * addressDic;
@property (strong,nonatomic) NSArray *city;
@property (strong,nonatomic) NSArray *district;
@property (strong,nonatomic) NSArray *street;


@end
