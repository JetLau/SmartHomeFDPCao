//
//  OEMSRootController.m
//  OfficeEMS_iPhone
//
//  Created by cisl on 14-5-27.
//  Copyright (c) 2014年 WangShengYin. All rights reserved.
//

#import "RootController.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"

@interface RootController ()

@property(nonatomic, strong) LoginViewController *loginViewController;
@property(nonatomic, strong) MainTabBarViewController *mainTabBarViewController;

@end

@implementation RootController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults stringForKey:@"username"];
    NSString *password = [userDefaults stringForKey:@"password"];
    //[userDefaults setObject:password forKey:@"password"];
    if ([userName isEqualToString:@"fudan"] && [password isEqualToString:@"admin"]) {
        self.mainTabBarViewController = [[MainTabBarViewController alloc] init];
        [self.view addSubview:self.mainTabBarViewController.view];
    } else {
        self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.view addSubview:self.loginViewController.view];
    }
    NSLog(@"%@%@",userName,password);

}

- (void)switchToMainTabBarView
{
    [self.loginViewController.view removeFromSuperview];
    self.loginViewController = nil;
    
    self.mainTabBarViewController = [[MainTabBarViewController alloc] init];
    [self.view addSubview:self.mainTabBarViewController.view];
}

- (void)switchToLoginView
{
    [self.mainTabBarViewController.view removeFromSuperview];
    self.mainTabBarViewController = nil;
    
    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.view addSubview:self.loginViewController.view];
}


@end
