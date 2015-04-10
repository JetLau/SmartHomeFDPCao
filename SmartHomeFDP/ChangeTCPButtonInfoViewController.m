//
//  ChangeTCPButtonInfoViewControl.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-23.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "ChangeTCPButtonInfoViewController.h"
#import "TCPDevice.h"
#import "ProgressHUD.h"
#import "SmartHomeAPIs.h"
#import "TCPDeviceManager.h"

#define tcpQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation ChangeTCPButtonInfoViewController
@synthesize deviceInfo;

-(void)viewDidLoad
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    int deviceId=[deviceInfo.tcpDev_id intValue];
    int buttonId=self.buttonTag;
    TCPDeviceManager *tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
    NSString * voice = [[tcpDeviceManager getRMButton:deviceId btnId:buttonId] objectForKey:@"buttonInfo"];
    [_buttonInfoField setText:voice];
    tcpDeviceManager = nil;
}

-(IBAction)saveButtonNameClick:(id)sender;
{
    if([self.buttonNameField.text isEqualToString:@""])
    {
        [ProgressHUD showError:@"按钮名称不可为空！"];
        return;
    }
    [ProgressHUD show:@"正在保存"];
    
    
    int deviceId=[deviceInfo.tcpDev_id intValue];
    int buttonId=self.buttonTag;
    NSString *buttonName=self.buttonNameField.text;
    
    dispatch_async(tcpQueue, ^{
        TCPDeviceManager *tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
        
        int isSuccess = [tcpDeviceManager saveTCPButtonNameIntoFile:deviceId buttonId:buttonId name:buttonName];
        if (isSuccess == 1) {
            
            //            NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
            //            [remoteDic setObject:@"changeName" forKey:@"command"];
            //            [remoteDic setObject:_info.mac forKey:@"mac"];
            //            [remoteDic setObject:nameText forKey:@"name"];
            //            SmartHomeAPIs Rm2StudyData:remoteDic];
            
            
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"保存成功" waitUntilDone:YES];
            return;
        }else if(isSuccess == 0)
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"保存失败" waitUntilDone:YES];
            return;
        }else{
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"已经有相同的按钮名称！" waitUntilDone:YES];
            return;
        }
    });

}

-(IBAction)saveButtonInfoClick:(id)sender;
{
    if([self.buttonInfoField.text isEqualToString:@""])
    {
        [ProgressHUD showError:@"语音信息不可为空！"];
        return;
    }
    [ProgressHUD show:@"正在保存"];
    
    
    int deviceId=[deviceInfo.tcpDev_id intValue];
    int buttonId=self.buttonTag;
    NSString *buttonInfo=self.buttonInfoField.text;
    
    dispatch_async(tcpQueue, ^{
        TCPDeviceManager *tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
        
        int isSuccess = [tcpDeviceManager saveTCPButtonInfoIntoFile:deviceId buttonId:buttonId info:buttonInfo];
        if (isSuccess == 1) {
            
            //            NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
            //            [remoteDic setObject:@"changeName" forKey:@"command"];
            //            [remoteDic setObject:_info.mac forKey:@"mac"];
            //            [remoteDic setObject:nameText forKey:@"name"];
            //            SmartHomeAPIs Rm2StudyData:remoteDic];
            
            
            [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"保存成功" waitUntilDone:YES];
            return;
        }else if(isSuccess == 0)
        {
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"保存失败" waitUntilDone:YES];
            return;
        }else{
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"已经有相同的按钮名称！" waitUntilDone:YES];
            return;
        }
    });

}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
