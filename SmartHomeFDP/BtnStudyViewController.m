//
//  BtnStudyViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-9.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BtnStudyViewController.h"
#import "RMDeviceManager.h"
#import "ProgressHUD.h"
#import "SmartHomeAPIs.h"
#import "CaoStudyModel.h"
#import "LGSocketServe.h"
#import "JSONKit.h"
#import "NetworkStatus.h"

@interface BtnStudyViewController()
{
    dispatch_queue_t networkQueue;
}

@end

@implementation BtnStudyViewController
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
    /*Init network queue.*/
    networkQueue = dispatch_queue_create("BroadLinkNetworkQueue", DISPATCH_QUEUE_CONCURRENT);
    //NSLog(@"view  load");
}

-(void)viewWillAppear:(BOOL)animated
{
    RMDeviceManager * rmDeviceManager = [RMDeviceManager createRMDeviceManager];
    NSString * voice = [[rmDeviceManager getRMButton:_rmDeviceIndex btnId:_btnId] objectForKey:@"buttonInfo"];
    [_voiceTextField setText:voice];
    rmDeviceManager = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)studyBtnClicked:(UIButton *)sender
{
    NSString *wifiName = [[NetworkStatus sharedNetworkStatus] getCurrentWiFiSSID];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"wifiname == %@",[defaults objectForKey:@"wifiName"]);
    if ([wifiName isEqualToString:[defaults objectForKey:@"wifiName"]]) {

        [ProgressHUD show:@"正在学习按键"];
        //    self.view.userInteractionEnabled = NO;
        //    self.navigationController.navigationBar.userInteractionEnabled=NO;
        //dispatch_async(networkQueue, ^{
        
        
        //        BLRM2StudyModel * rm2StudyModel = [BLRM2StudyModel studyModelWithBLDeviceInfo:_info rmDevice:btnDevice btnId:_btnId];
        //        NSString * code = [rm2StudyModel rm2StudyModelStart];
        
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:102] forKey:@"api_id"];
        [dic setObject:@"study mode" forKey:@"command"];
        [dic setObject:_info.mac forKey:@"mac"];
        [dic setObject:[NSNumber numberWithInt:0] forKey:@"message_id"];
        
        
        LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
        socketServe.mac = _info.mac;
        
        socketServe.block = ^(NSDictionary *dic){
            
            NSString * code = [dic objectForKey:@"code"];
            if ([code intValue] == 0) {
                //成功进入学习模式，提示用户操作遥控器
                //data = [caoStudyModel caoGetControlData];
                
                [ProgressHUD showSuccess:@"成功进入学习模式！"];
                
            } else {
                [ProgressHUD showError:@"未能成功进入学习模式，请重试！"];
            }
            
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
        [ProgressHUD show:@"正在学习按键"];
        //        self.view.userInteractionEnabled = NO;
        //        self.navigationController.navigationBar.userInteractionEnabled=NO;
        dispatch_async(networkQueue, ^{
            
            RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
            [rmDeviceManager initRMDeviceManage];
            RMDevice *btnDevice = [rmDeviceManager getRMDevice:_rmDeviceIndex];
            CaoStudyModel *caoStudyModel = [CaoStudyModel studyModelWithBLDeviceInfo:_info rmDevice:btnDevice btnId:_btnId];
            NSString * code = [caoStudyModel caoStudyModelStart];
            if ([code intValue] == 0) {
                //成功进入学习模式，提示用户操作遥控器
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD showSuccess:@"成功进入学习模式！"];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD showError:@"未能成功进入学习模式，请重试！"];
                });
            }

            
        });
    }
}

- (IBAction)saveVoiceTextBtnClicked:(id)sender {
    NSString *voiceText = [NSString stringWithString:self.voiceTextField.text];
    if([voiceText isEqualToString:@""])
    {
        [ProgressHUD showError:@"语音命令不可为空！"];
        return;
    }
    [ProgressHUD show:@"正在保存"];
    dispatch_async(networkQueue, ^{
        RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
        [rmDeviceManager initRMDeviceManage];
        //NSLog(@"btnId--%i",button.tag);
        NSString * name = [[rmDeviceManager getRMDevice:_rmDeviceIndex] name];
        BOOL TORF = [rmDeviceManager saveVoiceInfo:_rmDeviceIndex btnId:_btnId voiceInfo:voiceText];
        
        if (TORF) {
            dispatch_async(networkQueue, ^{
                NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                [remoteDic setObject:@"saveButtonVoice" forKey:@"command"];
                [remoteDic setObject:_info.mac forKey:@"mac"];
                [remoteDic setObject:name forKey:@"name"];
                [remoteDic setObject:[NSNumber numberWithInt:_btnId] forKey:@"buttonId"];
                [remoteDic setObject:voiceText forKey:@"buttonInfo"];
                [SmartHomeAPIs SaveButtonVoice:remoteDic];
            });
            
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"成功保存" waitUntilDone:YES];
            return;
        }else
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"保存失败" waitUntilDone:YES];
            return;
        }
    });
    
}

- (IBAction)dataSaveBtnClicked:(UIButton *)sender {
    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
    [rmDeviceManager initRMDeviceManage];
    RMDevice *btnDevice = [rmDeviceManager getRMDevice:_rmDeviceIndex];
    __block NSString * data;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:103] forKey:@"api_id"];
    [dic setObject:@"save data" forKey:@"command"];
    [dic setObject:_info.mac forKey:@"mac"];
    [dic setObject:[NSNumber numberWithInt:0] forKey:@"message_id"];
    
    
    //NSDictionary *result = [SmartHomeAPIs CaoGetCode:dic];
    
    NSString *wifiName = [[NetworkStatus sharedNetworkStatus] getCurrentWiFiSSID];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([wifiName isEqualToString:[defaults objectForKey:@"wifiName"]]) {
        LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
        socketServe.mac = _info.mac;
        
        socketServe.block = ^(NSDictionary *dic){
            
            if ([[dic objectForKey:@"code"] intValue] == 0)
            {
                data = [dic objectForKey:@"data"];
                //NSLog(@"get code : %@",data);
                
                
                
            }else{
                
            }
            
            if (data != nil) {
                //成功获得学习码
                //NSLog(@"get--%@",data);
                //NSLog(@"btnId--%i",button.tag);
                dispatch_async(serverQueue, ^{
                    NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                    [remoteDic setObject:@"rm2Study" forKey:@"command"];
                    [remoteDic setObject:_info.mac forKey:@"mac"];
                    [remoteDic setObject:[NSNumber numberWithInt:0] forKey:@"success"];
                    [remoteDic setObject:btnDevice.name forKey:@"name"];
                    [remoteDic setObject:[NSNumber numberWithInt:_btnId] forKey:@"buttonId"];
                    [remoteDic setObject:data forKey:@"sendData"];
                    [SmartHomeAPIs Rm2StudyData:remoteDic];
                });
                
                
                
                [rmDeviceManager saveSendData:_rmDeviceIndex btnId:_btnId sendData:data];
                [ProgressHUD showSuccess:@"学习成功！"];
                return;
            } else {
                //学习码获取失败
                NSLog(@"\n学习码获取失败\n");
                [ProgressHUD showError:@"学习失败，请重试！"];
                
                return;
            }
            
            
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
        [ProgressHUD show:@"正在获取操作码"];
        //        self.view.userInteractionEnabled = NO;
        //        self.navigationController.navigationBar.userInteractionEnabled=NO;
        dispatch_async(networkQueue, ^{
            
            RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
            [rmDeviceManager initRMDeviceManage];
            RMDevice *btnDevice = [rmDeviceManager getRMDevice:_rmDeviceIndex];
            CaoStudyModel *caoStudyModel = [CaoStudyModel studyModelWithBLDeviceInfo:_info rmDevice:btnDevice btnId:_btnId];
            NSString * data = [caoStudyModel caoGetControlData];
            if (data != nil) {
                //成功进入学习模式，提示用户操作遥控器
                [rmDeviceManager saveSendData:_rmDeviceIndex btnId:_btnId sendData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD showSuccess:@"学习成功！"];
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD showError:@"学习失败，请重试！"];
                });
            }
            
        });

    }
}


- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    self.navigationController.navigationBar.userInteractionEnabled=YES;
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    self.navigationController.navigationBar.userInteractionEnabled=YES;
    [ProgressHUD showError:message];
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end