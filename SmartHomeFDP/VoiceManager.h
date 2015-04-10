//
//  VoiceManager.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-9.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class VoiceViewController;

@interface VoiceManager : NSObject<IFlySpeechRecognizerDelegate,UIActionSheetDelegate>

@property(nonatomic,weak)VoiceViewController *voiceViewController;
@property (nonatomic, strong) IFlySpeechRecognizer * iFlySpeechRecognizer;
@property (nonatomic,strong) IFlyDataUploader *upLoader;
@property (nonatomic) BOOL upLoadSuccess;
//@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString             * result;

-(void)initVoiceManager;
-(void)startVoiceService;
-(void)stopVoiceService;

@end