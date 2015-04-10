//
//  VoiceManager.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-9.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "VoiceManager.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "iflyMSC/IFlyContact.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"
#import "RecognizerFactory.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "ISRDataHelper.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyResourceUtil.h"
#import "iflyMSC/iflySetting.h"
#import "Definition.h"
#import "VoiceViewController.h"

//#define USERWORDS @"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"开门\",\"关门\",\"投影开\",\"投影关\",\"窗帘开\",\"窗帘关\",\"空调开\"]}]}"
//#define USERWORDS @"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"开门\",\"关门\"]}]}"
#define NAME @"userwords" //生成用户词表对象

@implementation VoiceManager

-(void)initVoiceManager
{
    //创建语音配置,appid必须要传入，仅执行一次则可,与科大讯飞语音服务器连接
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID_VALUE,TIMEOUT_VALUE];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    //创建语音识别对象
    _iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];
}

-(void)upLoadUserWords:(NSArray *)userWordArray
{
    if(userWordArray==nil)
    {
        return;
    }
    if([userWordArray count]==0)
    {
        return;
    }
    
    NSString *userWords=@"{\"userword\":[{\"name\":\"iflytek\",\"words\":[";
    for(int i=0;i<[userWordArray count];i++)
    {
        NSString *word=@"\"";
        word=[word stringByAppendingString:[userWordArray objectAtIndex:i]];
        word=[word stringByAppendingString:@"\""];
        
        if(i==[userWordArray count]-1)
        {
            userWords=[userWords stringByAppendingString:word];
        }
        else
        {
            userWords=[userWords stringByAppendingString:word];
            userWords=[userWords stringByAppendingString:@","];
        }
    }
    userWords=[userWords stringByAppendingString:@"]}]}"];
    
    _upLoader=[[IFlyDataUploader alloc]init];
    
    //用户词表
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:userWords];
    
    //设置参数
    [_upLoader setParameter:@"iat" forKey:@"sub"]; [_upLoader setParameter:@"userword" forKey:@"dtt"];
    [_upLoader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error)
     {
         //接受返回的grammerID和error
         [self onUploadFinished:grammerID error:error];
         NSLog(@"%@",grammerID);
         NSLog(@"%@",error);
     } name:NAME data:[iFlyUserWords toString]];
}

-(void)startVoiceService
{
    NSLog(@"Button touch down");

    //设置为录音模式
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    //开始录音识别
    bool ret = [_iFlySpeechRecognizer startListening];
    
    if (ret) {
        //[_voiceButton setEnabled:NO];
        
    }
    else
    {
        NSLog(@"启动识别服务失败，请稍后重试");//可能是上次请求未结束，暂不支持多路并发
    }
}

-(void)stopVoiceService
{
    //停止录音识别
    NSLog(@"Button touch up inside");
    [_iFlySpeechRecognizer stopListening];
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调，当录音的声音的大小发生变化时调用
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @see
 */
- (void) onVolumeChanged: (int)volume
{
    
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    
    NSLog(@"%@",vol);
}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 *
 * @see
 */
- (void) onBeginOfSpeech
{
    NSLog(@"正在录音");
    
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 *
 * @see
 */
- (void) onEndOfSpeech
{
    NSLog(@"停止录音");
}


/**
 * @fn      onResults
 * @brief   识别结果回调，对录音的结果进行识别回调，转化成文字
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    //NSLog(@"听写结果：%@",resultString);
    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];
    NSLog(@"听写结果(json)：%@",  resultFromJson);

    self.result = [NSString stringWithFormat:@"%@",resultFromJson];
    
    
    //返回识别结果给VoiceViewController
    if(![resultFromJson isEqualToString:@""]&&![resultFromJson isEqualToString:@"。"])
    {
        [self.voiceViewController getVoiceRecognizerResult:self.result];
    }
    
}

/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *) error
{
    
}

#pragma mark - IFlyDataUploaderDelegate
/**
 * @fn  onUploadFinished
 * @brief   上传完成回调
 * @param grammerID 上传用户词、联系人为空
 * @param error 上传错误
 */
- (void) onUploadFinished:(NSString *)grammerID error:(IFlySpeechError *)error
{
    NSLog(@"%d",[error errorCode]);
    
    if (![error errorCode]) {
//        self.voiceLabel.text=@"上传成功";
        self.upLoadSuccess=TRUE;
    }
    else {
        self.upLoadSuccess=FALSE;
//        self.voiceLabel.text=@"上传失败";
    }
}

@end

