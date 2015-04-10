//
//  VoiceViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "VoiceViewController.h"
#import "VoiceManager.h"
#import "VoiceCommandRecognizer.h"

@interface VoiceViewController ()

@end

@implementation VoiceViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"语音控制"];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.voiceRecognizering=false;
    
    self.voiceLightImage.backgroundColor=[UIColor clearColor];
    self.voiceManager=[[VoiceManager alloc]init];
    self.voiceManager.voiceViewController=self;
    [self.voiceManager initVoiceManager];
}

-(IBAction)voiceButtonTouchDown:(id)sender
{
    if(self.voiceRecognizering==true)
    {
        return;
    }
    
    self.voiceLightImage.image=[UIImage imageNamed:@"voiceImgLight.jpg"];
    self.voiceImage.image=nil;
    self.voiceImage.backgroundColor=[UIColor clearColor];
    
    [self.voiceManager startVoiceService];
    self.voiceRecognizering=true;
}

- (void)getVoiceRecognizerResult:(NSString *)resultStr
{
    [self.voiceManager stopVoiceService];
    self.voiceRecognizering=false;
    
    //设置UIImage属性
    self.voiceImage.image=[UIImage imageNamed:@"voiceImg.jpg"];
    self.voiceLightImage.image=nil;
    self.voiceLightImage.backgroundColor=[UIColor clearColor];
    
    //处理识别结果字符串
    NSLog(@"resultStr=%@",resultStr);
    VoiceCommandRecognizer *voiceCommandRecognizer=[VoiceCommandRecognizer createVoiceCommandRecognizer];
    [voiceCommandRecognizer voiceCommandRecognize:resultStr];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
