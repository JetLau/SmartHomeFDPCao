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
#define remoteQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

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
                [dic setObject:[NSNumber numberWithInt:103] forKey:@"api_id"];
                [dic setObject:@"send data" forKey:@"command"];
                [dic setObject:mac forKey:@"mac"];
                [dic setObject:sendData forKey:@"data"];
                [dic setObject:[NSNumber numberWithInt:0] forKey:@"message_id"];
                NSDictionary *result = [SmartHomeAPIs CaoSendCode:dic];

                dispatch_async(remoteQueue, ^{
                    int success = ([[result objectForKey:@"code"] intValue]==0) ? 0:1;
                    //NSLog(@"success = %d",success);
                    NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                    [remoteDic setObject:@"rm2Send" forKey:@"command"];
                    [remoteDic setObject:mac forKey:@"mac"];
                    [remoteDic setObject:name forKey:@"name"];
                    [remoteDic setObject:buttonId forKey:@"buttonId"];
                    [remoteDic setObject:sendData forKey:@"sendData"];
                    [remoteDic setObject:[NSNumber numberWithInt:success] forKey:@"success"];
                    [remoteDic setObject:[NSNumber numberWithInt:1] forKey:@"op_method"];

                    NSString *result=[SmartHomeAPIs Rm2SendData:remoteDic];
                    if([result isEqualToString:@"success"])
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ProgressHUD showSuccess:@"语音控制成功"];
                        });
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [ProgressHUD showSuccess:@"语音控制失败，请检查中控器"];
                        });
                    }
                });

                return;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"未找到匹配的语音命令"];
    });
    
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
