//
//  ProjectorViewController.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "ProjectorViewController.h"
#import "RMDevice.h"
#import "RMDeviceManager.h"
@implementation ProjectorViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"投影仪"];
    
    UILongPressGestureRecognizer *longGesture0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];

//    _openBtn.tag = 0;
//    _closeBtn.tag = 1;
//    [_openBtn addGestureRecognizer:longGesture0];
//    UILongPressGestureRecognizer *longGesture1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [_closeBtn addGestureRecognizer:longGesture1];

}

-(int)addDevice
{
    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
    [rmDeviceManager initRMDeviceManage];
    
    RMDevice *rmDevice=[[RMDevice alloc]init];
    rmDevice.type=@"Projector";
    
    NSDictionary *dic0=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:0], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    NSDictionary *dic1=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:1], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];

    [rmDevice addRMButton:dic0];
    [rmDevice addRMButton:dic1];
    
    NSLog(@"Projector add to plist");
    return [rmDeviceManager addRMDeviceInfoIntoFile:rmDevice];
}

//- (void)longPress:(UILongPressGestureRecognizer *)sender
//{
//    UIButton *btn = (UIButton *)sender.view;
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        if ([sender.view isKindOfClass:[UIButton class]]) {
//            //UIButton *button = (UIButton *)sender.view;
//            //UIView *view = [longPress view];
//            NSLog(@"长按成功！！！！！！！！！！！%i",btn.tag);
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"重新学习" message:@"确定删除现有操作码，重新学习吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert show];
//            
//            //            BtnStudyViewController *btnStudyViewController = [[BtnStudyViewController alloc] init];
//            //            btnStudyViewController.navigationItem.title = @"学习模式";
//            //            btnStudyViewController.rmDeviceIndex = _rmDeviceIndex;
//            //            btnStudyViewController.info = _info;
//            //            btnStudyViewController.btnId = button.tag;
//            //
//            //            [self.navigationController pushViewController:btnStudyViewController animated:YES];
//        }
//    }
//}


@end
