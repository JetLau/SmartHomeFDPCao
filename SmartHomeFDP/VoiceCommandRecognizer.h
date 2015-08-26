//
//  VoiceCommandRecognizer.h
//  SmartHomeFDP
//
//  Created by eddie on 14-11-13.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMDeviceManager;
@class TCPDeviceManager;

@interface VoiceCommandRecognizer : NSObject

@property(strong,nonatomic)RMDeviceManager *rmDeviceManager;
@property(strong,nonatomic)TCPDeviceManager *tcpDeviceManager;

+(instancetype)createVoiceCommandRecognizer;

-(void)voiceCommandRecognize:(NSString *)voiceCommandStr;
@end
