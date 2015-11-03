//
//  VoiceCommandRecognizer.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-13.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "VoiceCommandRecognizer.h"
#import "TCPDeviceManager.h"
#import "RMDeviceManager.h"
#import "JSONKit.h"
#import "SmartHomeAPIs.h"
#import "ProgressHUD.h"
#import "StatisticFileManager.h"
#import "LGSocketServe.h"
#import "BLDeviceManager.h"
#import "BLDeviceInfo.h"
#import "NetworkStatus.h"
#import "CaoStudyModel.h"
#define remoteQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@interface VoiceCommandRecognizer ()
{
    
}
@end

@implementation VoiceCommandRecognizer

+(instancetype)createVoiceCommandRecognizer
{
    VoiceCommandRecognizer *voiceCommandRecognizer=[[VoiceCommandRecognizer alloc]init];
    voiceCommandRecognizer.rmDeviceManager=[RMDeviceManager createRMDeviceManager];
    voiceCommandRecognizer.tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
    
    return voiceCommandRecognizer;
}

-(void)voiceCommandRecognize:(NSString *)voiceCommandStr
{
    NSArray *rmDeviceArray=self.rmDeviceManager.RMDeviceArray;
    NSArray *tcpDeviceArray=self.tcpDeviceManager.TCPDeviceArray;
    
    
    //匹配Remote设备
    for(int i=0;i<[rmDeviceArray count];i++)
    {
        NSDictionary *dic=[rmDeviceArray objectAtIndex:i];
        NSArray *buttonArray=[dic objectForKey:@"buttonArray"];
        for(int j=0;j<[buttonArray count];j++)
        {
            NSDictionary *buttonDic=[buttonArray objectAtIndex:j];
            NSString *buttonInfo=[buttonDic objectForKey:@"buttonInfo"];
            
            if([buttonInfo isEqualToString:@""])
            {
                continue;
            }
            NSMutableString *voiceCommandPY=[[NSMutableString alloc]initWithString:voiceCommandStr];
            NSMutableString *buttonInfoPY=[[NSMutableString alloc]initWithString:buttonInfo];
            CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformMandarinLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformStripCombiningMarks, NO);
            CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformMandarinLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformStripCombiningMarks, NO);
            
            NSRange range=[voiceCommandPY rangeOfString:buttonInfoPY];
           // NSLog(@"拼音    %@  %@",voiceCommandPY,buttonInfoPY);
            //NSRange range=[voiceCommandStr rangeOfString:buttonInfo];
            if(range.location !=NSNotFound)
            {
                //匹配成功
               // [self operateStatistics:0];
                NSString *mac=[dic objectForKey:@"mac"];
                NSString *name=[dic objectForKey:@"name"];
                NSNumber *buttonId=[buttonDic objectForKey:@"buttonId"];
                NSString *sendData=[buttonDic objectForKey:@"sendData"];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:[NSNumber numberWithInt:104] forKey:@"api_id"];
                [dic setObject:@"send data" forKey:@"command"];
                [dic setObject:mac forKey:@"mac"];
                [dic setObject:sendData forKey:@"data"];
                [dic setObject:[NSNumber numberWithInt:0] forKey:@"message_id"];
                NSLog(@"dic=%@",dic);

                NSString *wifiName = [[NetworkStatus sharedNetworkStatus] getCurrentWiFiSSID];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if ([wifiName isEqualToString:[defaults objectForKey:@"wifiName"]]) {
                    LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
                    socketServe.mac = mac;
                    
                    
                    socketServe.block = ^(NSDictionary *dic){
                        NSString * code = [dic objectForKey:@"code"];
                        if ([code intValue] == 0) {
                            //成功进入学习模式，提示用户操作遥控器
                            //data = [caoStudyModel caoGetControlData];
                            
                            [ProgressHUD showSuccess:@"语音控制成功"];
                            
                        } else {
                            [ProgressHUD showError:[NSString stringWithFormat:@"错误码＝%i",[code intValue]]];
                        }
                        
                        //NSLog(@"%@", [responseData objectFromJSONData]);
                        dispatch_async(serverQueue, ^{
                            int success = ([[dic objectForKey:@"code"] intValue]==0) ? 0:1;
                            //NSLog(@"success = %d",success);
                            NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                            [remoteDic setObject:@"rm2Send" forKey:@"command"];
                            [remoteDic setObject:mac forKey:@"mac"];
                            [remoteDic setObject:name forKey:@"name"];
                            [remoteDic setObject:buttonId forKey:@"buttonId"];
                            [remoteDic setObject:sendData forKey:@"sendData"];
                            [remoteDic setObject:[NSNumber numberWithInt:success] forKey:@"success"];
                            [remoteDic setObject:[NSNumber numberWithInt:1] forKey:@"op_method"];
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
                    
                    return;

                }else{
                    dispatch_async(remoteQueue, ^{
                        RMDeviceManager *rmDeviceManager = [RMDeviceManager createRMDeviceManager];
                        RMDevice *btnDevice = [rmDeviceManager getRMDevice:i];
                        BLDeviceInfo *info=[[BLDeviceInfo alloc]init];
                        info.mac=mac;
                        CaoStudyModel *caoStudyModel = [CaoStudyModel studyModelWithBLDeviceInfo:info rmDevice:btnDevice btnId:[[buttonDic objectForKey:@"buttonId"] intValue]];
                        int code = [[caoStudyModel caoSendControlData:sendData] intValue];
                        if (code == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [ProgressHUD showSuccess:@"语音控制成功"];
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [ProgressHUD showError:[NSString stringWithFormat:@"错误码＝%i",code]];
                            });
                        }
                    });

                }
            }
        }
    }
    
    //匹配TCP设备
    for(int i=0;i<[tcpDeviceArray count];i++)
    {
        NSDictionary *dic=[tcpDeviceArray objectAtIndex:i];
        NSArray *buttonArray=[dic objectForKey:@"buttonArray"];
        for(int j=0;j<[buttonArray count];j++)
        {
            NSDictionary *buttonDic=[buttonArray objectAtIndex:j];
            NSString *buttonInfo=[buttonDic objectForKey:@"buttonInfo"];
            
            if([buttonInfo isEqualToString:@""])
            {
                continue;
            }
            
            NSMutableString *voiceCommandPY=[[NSMutableString alloc]initWithString:voiceCommandStr];
            NSMutableString *buttonInfoPY=[[NSMutableString alloc]initWithString:buttonInfo];
            CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformMandarinLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)voiceCommandPY, 0, kCFStringTransformStripCombiningMarks, NO);
            CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformMandarinLatin, NO);
            CFStringTransform((__bridge CFMutableStringRef)buttonInfoPY, 0, kCFStringTransformStripCombiningMarks, NO);
            
            NSRange range=[voiceCommandPY rangeOfString:buttonInfoPY];
            //NSLog(@"拼音    %@  %@",voiceCommandPY,buttonInfoPY);
            //NSRange range=[voiceCommandStr rangeOfString:buttonInfo];
            if(range.location !=NSNotFound)
            {
                //匹配成功
               // [self operateStatistics:0];
                NSString *sendData=[buttonDic objectForKey:@"sendData"];
                
                NSString *success=[SmartHomeAPIs OperateVoiceCommand:sendData];
                if([success isEqualToString:@"fail"])
                {
                    NSString *type=[buttonDic objectForKey:@"type"];
                    NSString *mac=[buttonDic objectForKey:@"mac"];
                    [SmartHomeAPIs AuthTCPDevice:mac type:type];
                    success=[SmartHomeAPIs OperateVoiceCommand:sendData];
                }
                
                if([success isEqualToString:@"success"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:@"语音控制成功"];
                    });
                }
                else if([success isEqualToString:@"Fail"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:@"操作失败，请检查网络！"];
                    });
                }else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:[NSString stringWithString:success]];
                    });
                }
                return;
            }
        }
    }
    
    //[self operateStatistics:1];
    [ProgressHUD showSuccess:@"未找到匹配的语音命令"];
    
    return;
}

-(void) operateStatistics:(int)btnId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        StatisticFileManager * statisticManager = [StatisticFileManager createStatisticManager];
        [statisticManager statisticOperateWithType:@"Voice" andBtnId:btnId];
    });
}



@end
