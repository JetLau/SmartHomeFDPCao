//
//  CustomRemoteViewController.h
//  SmartHomeFDP
//
//  Created by Looping on 14-2-8.
//  Copyright (c) 2014年 RidgeCorn. All rights reserved.
//

#import "CustomRemoteViewController.h"
#import "AddOrChangeCustomBtnViewController.h"
#import "RMDeviceManager.h"
#import "StatisticFileManager.h"
#import "CaoStudyModel.h"
#import "LGSocketServe.h"
#import "JSONKit.h"
#import "ProgressHUD.h"
#import "NetworkStatus.h"
@interface CustomRemoteViewController ()
{
    dispatch_queue_t networkQueue;
}
@end

@implementation CustomRemoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*Init network queue.*/
    networkQueue = dispatch_queue_create("BroadLinkNetworkQueue", DISPATCH_QUEUE_CONCURRENT);
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomButton)];
    UIBarButtonItem *changeNameItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(changeBarButtonItemClicked:)];
    NSArray *itemArray=[[NSArray alloc]initWithObjects:addButtonItem,changeNameItem, nil];
    [self.navigationItem setRightBarButtonItems:itemArray];
    
    //[self loadAvatarInCustomView];
    //[self addControlButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    RMDeviceManager * rmDeviceManager = [RMDeviceManager createRMDeviceManager];
    NSDictionary *dicDevices=[rmDeviceManager.RMDeviceArray objectAtIndex:self.rmDeviceIndex];
    [self.navigationItem setTitle:[dicDevices objectForKey:@"name"]];
    NSArray *btnArray = [rmDeviceManager getBtnArray:self.rmDeviceIndex];
    for (NSDictionary *dic in btnArray) {
        [self loadAvatarInView:dic];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadAvatarInView:(NSDictionary*)buttonDic{
    RCDraggableButton *avatar = [[RCDraggableButton alloc] initInView:self.view WithFrame:CGRectMake([[buttonDic valueForKey:@"btnX"] floatValue], [[buttonDic valueForKey:@"btnY"] floatValue], 80, 44)];
    avatar.buttonId=[[buttonDic objectForKey:@"buttonId"]intValue];
    avatar.tag = avatar.buttonId;
    avatar.sendData=[buttonDic objectForKey:@"sendData"];
    avatar.buttonInfo=[buttonDic objectForKey:@"buttonInfo"];
    avatar.btnName = [buttonDic objectForKey:@"btnName"];
    [avatar setBackgroundColor:[UIColor colorWithRed:102/255.0 green:142/255.0 blue:226/255.0 alpha:1]];
    [avatar setTitle:avatar.btnName forState:UIControlStateNormal];
    [avatar setAutoDocking:NO];
    
    avatar.longPressBlock = ^(RCDraggableButton *avatar) {
        //NSLog(@"\n\tAvatar in customView ===  LongPress!!! ===");
        self.btnId = avatar.buttonId;
        [self customBtnLongPress:avatar];
    };
    
    avatar.tapBlock = ^(RCDraggableButton *avatar) {
        //NSLog(@"\n\tAvatar in customView ===  Tap!!! ===%d",avatar.buttonId);
        self.btnId = avatar.buttonId;
        [self customBtnClicked:avatar];
        
    };
    
    avatar.draggingBlock = ^(RCDraggableButton *avatar) {
        //NSLog(@"\n\tAvatar in customView === Dragging!!! ===");
        //More todo here.
        
    };
    
    avatar.dragDoneBlock = ^(RCDraggableButton *avatar) {
        //NSLog(@"\n\tAvatar in customView === DragDone!!! ===");
        //More todo here.
        self.btnId = avatar.buttonId;
        RMDeviceManager * rmDeviceManager = [RMDeviceManager createRMDeviceManager];
        BOOL isSuccess = [rmDeviceManager saveBtnOrigin:self.rmDeviceIndex btnId:avatar.buttonId btnX:avatar.frame.origin.x btnY:avatar.frame.origin.y];
        if (!isSuccess) {
            NSLog(@"error");
        }
    };
    
    avatar.autoDockingBlock = ^(RCDraggableButton *avatar) {
        //NSLog(@"\n\tAvatar in customView === AutoDocking!!! ===");
        //More todo here.
        
    };
    
    avatar.autoDockingDoneBlock = ^(RCDraggableButton *avatar) {
        //NSLog(@"\n\tAvatar in customView === AutoDockingDone!!! ===");
        //More todo here.
        
    };
}


-(void)addCustomButton
{
    AddOrChangeCustomBtnViewController *aOrChCustomBtnViewController = [[AddOrChangeCustomBtnViewController alloc] init];
    aOrChCustomBtnViewController.navigationItem.title = @"编辑按钮";
    aOrChCustomBtnViewController.rmDeviceIndex = self.rmDeviceIndex;
    aOrChCustomBtnViewController.info = self.info;
    //新建button，button由aOrChCustomBtnViewController自己设置
    aOrChCustomBtnViewController.style = @"add";
    [self.navigationController pushViewController:aOrChCustomBtnViewController animated:YES];
}

-(void)customBtnClicked:(RCDraggableButton *) btn
{
    //[self operateStatistics:@"Custom"];
    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
    [rmDeviceManager initRMDeviceManage];
    NSDictionary * dicBtn = [rmDeviceManager getRMButton:self.rmDeviceIndex btnId:btn.buttonId];
    
    //NSLog(@"_rmDeviceIndex %i dicBtn %@",_rmDeviceIndex,dicBtn);
    if ([[dicBtn objectForKey:@"sendData"] isEqualToString:@""]) {
        AddOrChangeCustomBtnViewController *aOrChCustomBtnViewController = [[AddOrChangeCustomBtnViewController alloc] init];
        aOrChCustomBtnViewController.navigationItem.title = @"编辑按钮";
        aOrChCustomBtnViewController.rmDeviceIndex = self.rmDeviceIndex;
        aOrChCustomBtnViewController.info = self.info;
        //已有button设置ID
        aOrChCustomBtnViewController.btnId = btn.buttonId;
        aOrChCustomBtnViewController.style = @"edit";
        [self.navigationController pushViewController:aOrChCustomBtnViewController animated:YES];
    }else{
        
        RMDevice *btnDevice = [rmDeviceManager getRMDevice:self.rmDeviceIndex];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:104] forKey:@"api_id"];
        [dic setObject:@"send data" forKey:@"command"];
        [dic setObject:self.info.mac forKey:@"mac"];
        [dic setObject:[dicBtn objectForKey:@"sendData"] forKey:@"data"];
        [dic setObject:[NSNumber numberWithInt:0] forKey:@"message_id"];
        
        NSString *wifiName = [[NetworkStatus sharedNetworkStatus] getCurrentWiFiSSID];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([wifiName isEqualToString:[defaults objectForKey:@"wifiName"]]) {
            
            LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
            socketServe.mac = self.info.mac;
            
            socketServe.block = ^(NSDictionary *dic){
                NSString * code = [dic objectForKey:@"code"];
                if ([code intValue] == 0) {
                    //成功进入学习模式，提示用户操作遥控器
                    //data = [caoStudyModel caoGetControlData];
                    
                    [ProgressHUD showSuccess:@"操作成功"];
                    
                } else {
                    [ProgressHUD showError:[NSString stringWithFormat:@"错误码＝%i",[code intValue]]];
                }
                
                //NSLog(@"%@", [responseData objectFromJSONData]);
                dispatch_async(serverQueue, ^{
                    int success = ([[dic objectForKey:@"code"] intValue]==0) ? 0:1;
                    //NSLog(@"success = %d",success);
                    NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                    [remoteDic setObject:@"rm2Send" forKey:@"command"];
                    [remoteDic setObject:self.info.mac forKey:@"mac"];
                    [remoteDic setObject:btnDevice.name forKey:@"name"];
                    [remoteDic setObject:[NSNumber numberWithInt:btn.buttonId] forKey:@"buttonId"];
                    [remoteDic setObject:[dicBtn objectForKey:@"sendData"] forKey:@"sendData"];
                    [remoteDic setObject:[NSNumber numberWithInt:success] forKey:@"success"];
                    [remoteDic setObject:[NSNumber numberWithInt:0] forKey:@"op_method"];
                    [SmartHomeAPIs Rm2SendData:remoteDic];
                });
            };
            
            //socket连接前先断开连接以免之前socket连接没有断开导致闪退
            [socketServe cutOffSocket];
            socketServe.socket.userData = SocketOfflineByServer;
            [socketServe startConnectSocket];
            //[dic setObject:@"54:4A:16:2E:2F:F3" forKey:@"mac"];
            //NSLog(@"dic=%@",dic);
            //发送消息 @"hello world"只是举个列子，具体根据服务端的消息格式
            NSData *requestData = [dic JSONData];
            NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
            
            [socketServe sendMessage:josnString];
        }else{
            dispatch_async(networkQueue, ^{
                RMDevice *btnDevice = [rmDeviceManager getRMDevice:self.rmDeviceIndex];
                CaoStudyModel *caoStudyModel = [CaoStudyModel studyModelWithBLDeviceInfo:self.info rmDevice:btnDevice btnId:btn.buttonId];
                int code = [[caoStudyModel caoSendControlData:[dicBtn objectForKey:@"sendData"]] intValue];
                
                if (code == 0) {
                    [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"操作成功" waitUntilDone:YES];
                } else {
                    [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:[NSString stringWithFormat:@"错误码＝%i",code] waitUntilDone:YES];
                    
                }
            });
            
        }
        
    }
}

-(void) customBtnLongPress:(RCDraggableButton *) btn
{
    //NSLog(@"长按成功！！！！！！！！！！！%i",btn.tag);
    self.btnId = btn.buttonId;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"编辑Button" message:@"删除或重新编辑按钮？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"编辑", @"删除",nil];
    [alert show];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NSLog(@"buttonIndex = %d", buttonIndex);
    if(buttonIndex==1)
    {
        AddOrChangeCustomBtnViewController *aOrChCustomBtnViewController = [[AddOrChangeCustomBtnViewController alloc] init];
        aOrChCustomBtnViewController.navigationItem.title = @"编辑按钮";
        aOrChCustomBtnViewController.rmDeviceIndex = self.rmDeviceIndex;
        aOrChCustomBtnViewController.info = self.info;
        //已有button设置ID
        aOrChCustomBtnViewController.btnId = self.btnId;
        aOrChCustomBtnViewController.style = @"edit";
        [self.navigationController pushViewController:aOrChCustomBtnViewController animated:YES];
        
    } else if(buttonIndex==2) {
        NSLog(@"删除");
        RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
        [rmDeviceManager initRMDeviceManage];
        [rmDeviceManager deleteCustomBtn:self.rmDeviceIndex btnId:self.btnId];
        for (id view in [self.view subviews]) {
            if ([view isKindOfClass:[RCDraggableButton class]] && [view tag] == self.btnId) {
                [view removeFromSuperview];
            }
        }
        RMDevice * rmDevice = [rmDeviceManager getRMDevice:self.rmDeviceIndex];
        dispatch_async(networkQueue, ^{
            NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
            
            [remoteDic setObject:@"deleteBtn" forKey:@"command"];
            [remoteDic setObject:self.info.mac forKey:@"mac"];
            [remoteDic setObject:rmDevice.name forKey:@"name"];
            [remoteDic setObject:[NSNumber numberWithInt:self.btnId] forKey:@"buttonId"];
            [SmartHomeAPIs deleteBtn:remoteDic];
        });
    }
}

-(void) operateStatistics :(NSString*)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        StatisticFileManager * statisticManager = [StatisticFileManager createStatisticManager];
        [statisticManager statisticOperateWithType:type andBtnId:0];
    });
}
@end
