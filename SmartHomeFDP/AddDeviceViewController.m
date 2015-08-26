//
//  AddDevViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "JSONKit.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "ProgressHUD.h"
#import "CaoConfig.h"

#define kDegreesToRadian(x) (M_PI * (x) / 180.0)

#define kRadianToDegrees(radian) (radian*180.0)/(M_PI)

int const discoveryTimeout = 40;

@interface AddDeviceViewController (){
    int countDown;
}

@end

@implementation AddDeviceViewController
@synthesize segmentControl;
@synthesize segmentIndex;

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
    [self.navigationItem setTitle:@"添加中控"];
    //设置成no，则状态栏及导航样不为透明的，界面上的组件就是紧挨着导航栏显示了
    [self.navigationController.navigationBar setTranslucent:NO];
    [segmentControl addTarget:self action:@selector(segmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentIndex=0;
    
    NSString *wifiSSID=[self getCurrentWiFiSSID];
    if(wifiSSID!=nil&&![wifiSSID isEqualToString:@""])
    {
        [self.wifiTextField setText:wifiSSID];
    }
    
    
    [self.searchButton.layer setMasksToBounds:YES];
    [self.searchButton.layer setCornerRadius:10.0];
    [self.searchButton.layer setBorderWidth:1.0];
    [self.searchButton setTitle:@"搜索设备，进行配置" forState:UIControlStateNormal];
    
    [self.stopBtn.layer setMasksToBounds:YES];
    [self.stopBtn.layer setCornerRadius:10.0];
    [self.stopBtn.layer setBorderWidth:1.0];
    [self.stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.1, 0.1, 0.1, 1 });
    [self.searchButton.layer setBorderColor:colorref];
    [self.stopBtn.layer setBorderColor:colorref];

    self.startConfig=false;
    self.caoConfig=[[CaoConfig alloc]init];
    //[self initEasyConfig];
    
    // add notification for discovered device
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(deviceAdded:)
//                                                 name:@"deviceFound"
//                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*获取当前连接的wifi网络名称，如果未连接，则为nil*/
- (NSString *)getCurrentWiFiSSID
{
    CFArrayRef ifs = CNCopySupportedInterfaces();       //得到支持的网络接口 eg. "en0", "en1"
    
    if (ifs == NULL)
        return nil;
    
    CFDictionaryRef info = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(ifs, 0));
    
    CFRelease(ifs);
    
    if (info == NULL)
        return nil;
    
    NSDictionary *dic = (__bridge_transfer NSDictionary *)info;
    
    // If ssid is not exist.
    if ([dic isEqual:nil])
        return nil;
    
    NSString *ssid = [dic objectForKey:@"SSID"];
    
    return ssid;
}

-(IBAction)searchButtonClick:(id)sender
{
    NSString *wifi=self.wifiTextField.text;
    NSString *password=self.passwordTextField.text;
    
    if([wifi isEqualToString:@""])
    {
        [ProgressHUD showError:@"WiFi名称不能为空"];
        return;
    }
    
    if([password isEqualToString:@""])
    {
        [ProgressHUD showError:@"WiFi密码不能为空"];
        return;
    }

    switch (segmentIndex) {
        case 0:
        {

//            if(self.startConfig==true) //cancel easyconfig
//            {
//                [self.blEasyConfig cancelConfig];
//                self.startConfig=false;
//                [self.searchButton setTitle:@"搜索设备，进行配置" forState:UIControlStateNormal];
//            }
//            else  //start easy config
//            {
//                [self.blEasyConfig startConfig:wifi password:password];
//                self.startConfig=true;
//                [self.searchButton setTitle:@"配置中...点击取消" forState:UIControlStateNormal];
//            }
            
            break;
        }
        case 1:
        {
            [self continueStartAction];
            [self.caoConfig startConfig:wifi password:password];

//            self.startConfig=true;
//            [self.searchButton setTitle:@"搜索设备，进行配置" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }

}

-(void)segmentChangedValue:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            //BroadLinkConfig
            segmentIndex=0;
            break;
        case 1:
            //UDPConfig
            segmentIndex=1;
            break;
        default:
            break;
    }
}

//点击空白区域，键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void) continueStartAction{
    self.searchButton.hidden = YES;
    self.stopBtn.hidden = NO;
    
    self.discoveryTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    countDown =  discoveryTimeout;
    self.showInfo.text = [NSString stringWithFormat:@"%d秒后停止配置",countDown];
    // start discovery using TI lib
}

-(void)updateProgress {
    countDown -= 1 ;
    self.showInfo.text = [NSString stringWithFormat:@"%d秒后停止配置",countDown];
    if (countDown <= 0) {
        [self stopDiscovery];
    }
}

-(void) stopDiscovery {
    self.showInfo.text = @"";
    [self.searchButton setHidden:NO];
    [self.stopBtn setHidden:YES];
    [self.discoveryTimer invalidate];
    [self.caoConfig stopDiscovery];
    
}
- (IBAction)stopSearch:(UIButton *)sender {
    [self stopDiscovery];
}
@end
