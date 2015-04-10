//
//  OEMSLoginViewController.m
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-5-28.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import "LoginViewController.h"
#import "ProgressHUD.h"
#import "RootController.h"
#import "SmartHomeAPIs.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"view  load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginInButtonClicked:(id)sender {
    
    NSString *username;
    NSString *password;
    
    username = [NSString stringWithString:self.userNameTextField.text];
    password = [NSString stringWithString:self.passwordTextField.text];
   
    
    //用来测试用的用户名密码
    if ([username isEqualToString:@""])
    {
        [ProgressHUD showError:@"用户名不能为空"];
        return;
    }
    if ([password isEqualToString:@""])
    {
        [ProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    [ProgressHUD show:@"正在登录"];
    self.view.userInteractionEnabled = false;
    
    dispatch_async(kBgQueue, ^{
        NSDictionary *status = [SmartHomeAPIs MobileLogin:username password:password];
        NSString *loginSuccess = [[status objectForKey:@"jsonMap"] objectForKey:@"result"];
//        NSString *loginSuccess = @"success";
        if ([loginSuccess isEqualToString:@"success"])//登录成功
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:username forKey:@"username"];
            [userDefaults setObject:password forKey:@"password"];

            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"登录成功" waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(switchNextViewController) withObject:nil waitUntilDone:YES];
            return ;
        }
        else//登录出错
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"登录失败！" waitUntilDone:YES];
            return ;
        }
    });

}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

- (void)switchNextViewController
{
    RootController *rootController = (RootController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController switchToMainTabBarView];
}
@end
