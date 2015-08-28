//
//  RegisterViewController.m
//  ShareBarrierFree
//
//  Created by cisl on 15-6-29.
//  Copyright (c) 2015年 LJ. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserInfo.h"
#import "ProgressHUD.h"
#import "RootController.h"
#import "OEMSQueryTableViewCell.h"
@interface RegisterViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    self.user= [[UserInfo alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(returnToLogin)];
    //修改title颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [addressSegment addTarget:self action:@selector(addressSegmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [addressTableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.city = [[NSArray alloc] initWithObjects:@"北京",@"上海",@"南京", nil];
    self.district = [[NSArray alloc] initWithObjects:@"朝阳",@"通州",@"五道口", nil];
    self.street = [[NSArray alloc] initWithObjects:@"张衡",@"蔡伦",@"张江高科", nil];
    self.addressDic=[[NSDictionary alloc]initWithObjectsAndKeys: @"",@"city",@"",@"district",@"",@"street",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)returnToLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerBtnClicked:(UIButton *)sender {
    [self.user setUsername:[NSString stringWithString:username.text]];
    [self.user setPassword:[NSString stringWithString:password.text]];
    [self.user setPhone:[NSString stringWithString:phone.text]];
    if ([genderSegment selectedSegmentIndex] == 0) {
        self.user.gender = @"man";
    }else if([genderSegment selectedSegmentIndex] == 1) {
        self.user.gender = @"woman";
    }
    BOOL isInfoRight = [self.user verifyInfo:[NSString stringWithString:verifyPassword.text]];
    if (isInfoRight== TRUE) {
        [ProgressHUD show:@"正在注册"];
        self.view.userInteractionEnabled = false;
        
//        dispatch_async(serverQueue, ^{
//            NSDictionary *resultDic = [ShareBarrierFreeAPIS RegisterUser:self.user];
//            if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"]) {
//                
//                [self.user setRoleId:[[resultDic objectForKey:@"roleId"] integerValue]];
//                [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"注册成功" waitUntilDone:YES];
//               // [self performSelectorOnMainThread:@selector(switchNextViewController) withObject:nil waitUntilDone:YES];
//
//            }else//登录出错
//            {
//                [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"注册失败！" waitUntilDone:YES];
//                return ;
//            }
//        });
        [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"注册成功" waitUntilDone:YES];
    }
}

- (IBAction)moveView:(UITextField *)sender {
    CGRect frame = self.inputView.frame;
    //NSLog(@"inputView = %f",self.inputView.frame.origin.y);
    if (sender.tag>0) {
        frame.origin.y = -25*sender.tag;
        //NSLog(@"frame = %f",frame.origin.y);

        [UIView animateWithDuration:0.5f
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0.1f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.inputView.frame = frame;}
                         completion:^(BOOL finished) {}];
    }
    
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect frame = self.inputView.frame;
    frame.origin.y = 50;
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.inputView.frame = frame;}
                     completion:^(BOOL finished) {}];
    [self.view endEditing:YES];
}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"test" forKey:@"username"];
    [userDefaults setObject:@"test" forKey:@"password"];
    [userDefaults setObject:@"test" forKey:@"phone"];
    [userDefaults setObject:@"man" forKey:@"gender"];
    [userDefaults setObject:[NSNumber numberWithInt:0] forKey:@"address"];
    [userDefaults setObject:[NSNumber numberWithInt:1] forKey:@"roleId"];

    [self returnToLogin];
}
- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

-(void)addressSegmentChangedValue:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            [addressTableView reloadData];
            addressTableView.hidden = false;
            [addressSegment setTitle:@"区" forSegmentAtIndex:1];
            //[self.addressDic setValue:@"" forKey:@"district"];
            [addressSegment setTitle:@"街道" forSegmentAtIndex:2];
            //[self.addressDic setValue:@"" forKey:@"street"];
            [addressSegment setEnabled:NO forSegmentAtIndex:2];
            break;
        case 1:
            [addressTableView reloadData];
            addressTableView.hidden = false;
            [addressSegment setTitle:@"街道" forSegmentAtIndex:2];
            //[self.addressDic setValue:@"" forKey:@"street"];
            break;
        case 2:
            [addressTableView reloadData];
            addressTableView.hidden = false;
        default:
            break;
    }
    

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (OEMSQueryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OEMSQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if([addressSegment selectedSegmentIndex] == 0) {
        cell.name.text = [self.city objectAtIndex:[indexPath row]];
    } else if([addressSegment selectedSegmentIndex] == 1) {
        cell.name.text = [self.district objectAtIndex:[indexPath row]];
    } else {
        cell.name.text = [self.street objectAtIndex:[indexPath row]];
        
        
    }
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([addressSegment selectedSegmentIndex] == 0) {
        return [self.city count];
    } else if ([addressSegment selectedSegmentIndex] == 1) {
        return [self.district count];
    } else {
        return [self.street count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([addressSegment selectedSegmentIndex] == 0) {
        [addressSegment setTitle:[self.city objectAtIndex:indexPath.row] forSegmentAtIndex:0];
        //[self.addressDic setValue:[self.city objectAtIndex:indexPath.row] forKey:@"city"];
        [addressSegment setEnabled:YES forSegmentAtIndex:1];
    } else if ([addressSegment selectedSegmentIndex] == 1) {
        [addressSegment setTitle:[self.district objectAtIndex:indexPath.row] forSegmentAtIndex:1];
        //[self.addressDic setValue:[self.district objectAtIndex:indexPath.row] forKey:@"district"];
        [addressSegment setEnabled:YES forSegmentAtIndex:2];

    } else {
        [addressSegment setTitle:[self.street objectAtIndex:indexPath.row] forSegmentAtIndex:2];
        //[self.addressDic setValue:[self.street objectAtIndex:indexPath.row] forKey:@"street"];

    }
    self.user.address = [NSNumber numberWithInt:1];
    [addressTableView setHidden:YES];
}
@end
