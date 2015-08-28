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
#import "RegisterViewController.h"
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
        loginSuccess = @"success";
        if ([loginSuccess isEqualToString:@"success"])//登录成功
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"test" forKey:@"username"];
            [userDefaults setObject:@"test" forKey:@"password"];
            [userDefaults setObject:@"test" forKey:@"phone"];
            [userDefaults setObject:@"man" forKey:@"gender"];
            [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"address"];
            [userDefaults setObject:[NSNumber numberWithInt:1] forKey:@"roleId"];
            
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

- (IBAction)registerNewUser:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerVC];
    [nav.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:130/255.0 green:206/255.0 blue:59/255.0 alpha:1]];

    [registerVC.navigationItem setTitle:@"注册新用户"];
    [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
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
    int id = 0;
    if (id == 0) {
        [rootController switchToManagerView];
    }else if (id == 1) {
        [rootController switchToMainTabBarView];
    }
}
@end
