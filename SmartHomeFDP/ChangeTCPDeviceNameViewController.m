//
//  ChangeTCPDeviceNameViewController.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-23.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "ChangeTCPDeviceNameViewController.h"
#import "ProgressHUD.h"
#import "SmartHomeAPIs.h"
#import "TCPDeviceManager.h"
#import "TCPDevice.h"

#define tcpQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation ChangeTCPDeviceNameViewController
@synthesize deviceNameField;
@synthesize deviceInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveBarButtonItemClicked)];

    [self.navigationItem setRightBarButtonItem:saveButtonItem];
}

- (void)saveBarButtonItemClicked{
    NSString *nameText = [NSString stringWithString:deviceNameField.text];
    int deviceId=[deviceInfo.tcpDev_id intValue];
    if([nameText isEqualToString:@""])
    {
        [ProgressHUD showError:@"设备名称不可为空！"];
        return;
    }
    [ProgressHUD show:@"正在保存"];
    
    dispatch_async(tcpQueue, ^{
        TCPDeviceManager *tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];

        int isSuccess = [tcpDeviceManager saveTCPDeviceNameIntoFile:deviceId name:nameText];
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
            [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:@"已经有相同的设备名称！" waitUntilDone:YES];
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
