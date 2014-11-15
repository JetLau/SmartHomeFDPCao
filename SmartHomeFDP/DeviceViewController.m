//
//  LJHotStatusViewController.m
//  NewProject
//
//  Created by eddie on 14-9-4.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "DeviceViewController.h"
#import "RMDeviceManager.h"
#import "BtnStudyViewController.h"
#import "BLRM2StudyModel.h"
#import "ProgressHUD.h"
@interface DeviceViewController ()
{
    dispatch_queue_t networkQueue;
    
}
@end

@implementation DeviceViewController

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
    networkQueue = dispatch_queue_create("BroadLinkRM2NetworkQueue", DISPATCH_QUEUE_SERIAL);
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    
    NSLog(@"plist中第 %d 项",_rmDeviceIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)addDevice
{
    NSLog(@"NO device add to plist!");
    return 0;
}

- (IBAction)buttonClicked:(UIButton *)sender {
    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
    [rmDeviceManager initRMDeviceManage];
    NSDictionary *dicDevices=[rmDeviceManager.RMDeviceArray objectAtIndex:_rmDeviceIndex];
    //RMDevice *device = [rmDeviceManager getRMDevice:super.rmDeviceIndex];
    NSArray *arrayBtn = [dicDevices objectForKey:@"buttonArray"];
    //NSLog(@"arrayBtn %@",arrayBtn);
    UIButton *button = (UIButton *) sender;
    NSDictionary * dicBtn = [arrayBtn objectAtIndex:button.tag];
    //NSLog(@"_rmDeviceIndex %i dicBtn %@",_rmDeviceIndex,dicBtn);
    if ([[dicBtn objectForKey:@"sendData"] isEqualToString:@""]) {
        BtnStudyViewController *btnStudyViewController = [[BtnStudyViewController alloc] init];
        btnStudyViewController.navigationItem.title = @"学习模式";
        btnStudyViewController.rmDeviceIndex = _rmDeviceIndex;
        btnStudyViewController.info = _info;
        btnStudyViewController.btnId = button.tag;
        [self.navigationController pushViewController:btnStudyViewController animated:YES];
    }else{
        dispatch_async(networkQueue, ^{
            BLRM2StudyModel * rm2StudyModel = [BLRM2StudyModel studyModelWithArgument:_info];
            
            NSString * code = [rm2StudyModel rm2SendControlData:[dicBtn objectForKey:@"sendData"]];
            if ([code intValue] == 0) {
                [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"操作成功" waitUntilDone:YES];
            } else {
                [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"失败，请重试！" waitUntilDone:YES];
                
            }
        });
        //NSLog(@"发送 %@",[dicBtn objectForKey:@"sendData"]);
        
    }
}


- (void) successWithMessage:(NSString *)message {
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [ProgressHUD showError:message];
}

- (IBAction)btnLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([sender.view isKindOfClass:[UIButton class]]) {
            //UIButton *button = (UIButton *)sender.view;
            //UIView *view = [longPress view];
            UIButton *btn = (UIButton *)sender.view;
            NSLog(@"长按成功！！！！！！！！！！！%i",btn.tag);
            _btnId = btn.tag;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"重设Button" message:@"重新设置按钮的语音命令或者操作码？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
  
        }
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        //// Yes condition
        NSLog(@"Yes");
        
        BtnStudyViewController *btnStudyViewController = [[BtnStudyViewController alloc] init];
        btnStudyViewController.navigationItem.title = @"学习模式";
        btnStudyViewController.rmDeviceIndex = _rmDeviceIndex;
        btnStudyViewController.info = _info;
        btnStudyViewController.btnId = _btnId;
        
        [self.navigationController pushViewController:btnStudyViewController animated:YES];
       
    } else {
        NSLog(@"No");
        ///// No condition
    }
}
@end

