//
//  TVViewController.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-6.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "TVViewController.h"
#import "RMDeviceManager.h"
#import "RMButton.h"
#import "RMDevice.h"
#import "BtnStudyViewController.h"
#import "MJExtension.h"
@interface TVViewController ()

@end

@implementation TVViewController
//@synthesize mode;
//@synthesize parameterDic;

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
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked)];
    [self.navigationItem setTitle:@"电视"];
}

-(int)addDevice
{
    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
    [rmDeviceManager initRMDeviceManage];
    
    RMDevice *rmDevice=[[RMDevice alloc]init];
    rmDevice.type=@"TV";
    
    NSDictionary *dic0=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:0], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    NSDictionary *dic1=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:1], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    NSDictionary *dic2=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:2], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    NSDictionary *dic3=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:3], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    NSDictionary *dic4=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:4], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    NSDictionary *dic5=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:5], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    
    [rmDevice addRMButton:dic0];
    [rmDevice addRMButton:dic1];
    [rmDevice addRMButton:dic2];
    [rmDevice addRMButton:dic3];
    [rmDevice addRMButton:dic4];
    [rmDevice addRMButton:dic5];
    
    NSLog(@"TV add to plist");
    return [rmDeviceManager addRMDeviceInfoIntoFile:rmDevice];
}
//- (IBAction)buttonClicked:(UIButton *)sender {
//    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
//    [rmDeviceManager initRMDeviceManage];
//    NSDictionary *dicDevices=[rmDeviceManager.RMDeviceArray objectAtIndex:super.rmDeviceIndex];
//    //RMDevice *device = [rmDeviceManager getRMDevice:super.rmDeviceIndex];
//    NSArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
//    //NSLog(@"arrayBtn %@",arrayBtn);
//    UIButton *button = (UIButton *) sender;
//    NSDictionary * dicBtn = [arrayBtn objectAtIndex:button.tag];
//    //NSLog(@"dicBtn %@",dicBtn);
//    if ([[dicBtn objectForKey:@"sendData"] isEqualToString:@""]) {
//        BtnStudyViewController *btnStudyViewController = [[BtnStudyViewController alloc] init];
//        btnStudyViewController.navigationItem.title = @"学习模式";
//        btnStudyViewController.rmDeviceIndex = super.rmDeviceIndex;
//        btnStudyViewController.btnId = button.tag;
//        [self.navigationController pushViewController:btnStudyViewController animated:YES];
//    }else{
//        
//    }
//}

-(void) saveButtonClicked
{
    NSLog(@"saved");
}

@end