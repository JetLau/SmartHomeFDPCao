//
//  NSObject+BLStudyModel.m
//  BroadLinkSDKDemo
//
//  Created by cisl on 14-10-27.
//  Copyright (c) 2014年 BroadLink. All rights reserved.
//

#import "BLRM2StudyModel.h"
#import "JSONKit.h"
#import "MJExtension.h"
#import "RMButton.h"
@interface BLRM2StudyModel ()
{
    
}

@property (nonatomic, strong) BLNetwork *network;

//@property (nonatomic, strong) NSString *data;

@end

@implementation BLRM2StudyModel

- (instancetype)initWithBLDeviceInfo :(BLDeviceInfo*)info  rmDevice:(RMDevice*) rmDevice btnId:(int)btnId;
{
    if(self = [super init])
    {
        _network = [[BLNetwork alloc] init];
        _info = info;
        _rmDevice = rmDevice;
        _btnId = btnId;
        for (RMButton *btn in rmDevice.RMButtonArray) {
            if (btn.buttonId == btnId) {
                _btnDic = [btn keyValues];
            }
        }
    }
    return self;
}
+ (instancetype)studyModelWithBLDeviceInfo :(BLDeviceInfo*)info rmDevice:(RMDevice*) rmDevice btnId:(int)btnId;
{
    return [[self alloc] initWithBLDeviceInfo:info rmDevice:rmDevice btnId:btnId];
}

//////
- (instancetype)initWithArgument :(BLDeviceInfo*)info
{
    if(self = [super init])
    {
        _network = [[BLNetwork alloc] init];
        _info = info;
    }
    return self;
}
+ (instancetype)studyModelWithArgument :(BLDeviceInfo*)info
{
    return [[self alloc] initWithArgument:info];
}
///////
- (instancetype)initWithBLDeviceInfo :(BLDeviceInfo*)info  btnDic:(NSDictionary*) btnDic btnId:(int)btnId
{
    if(self = [super init])
    {
        _network = [[BLNetwork alloc] init];
        _info = info;
        _btnDic = btnDic;
        _btnId = btnId;
    }
    return self;
}
+ (instancetype)studyModelWithBLDeviceInfo :(BLDeviceInfo*)info btnDic:(NSDictionary*) btnDic btnId:(int)btnId
{
    return [[self alloc] initWithBLDeviceInfo:info btnDic:btnDic btnId:btnId];
}
////////

/*Study model start,rm2's red bulb light up*/
- (NSString *)rm2StudyModelStart
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:132] forKey:@"api_id"];
    [dic setObject:@"rm2_study" forKey:@"command"];
    [dic setObject:_info.mac forKey:@"mac"];
    NSData *requestData = [dic JSONData];
    NSData *responseData = [_network requestDispatch:requestData];
    NSLog(@"%@", [responseData objectFromJSONData]);
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[responseData objectFromJSONData] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alertView show];
//    if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0) {
    return [[responseData objectFromJSONData] objectForKey:@"code"];
//    } else {
//        //NSLog(@"rm2 enter study mode failed, fail code: %@",[[responseData objectFromJSONData] objectForKey:@"code"]);
//        //[self performSelectorOnMainThread:@selector(enterStudyModeFailed) withObject:nil waitUntilDone:NO];
//        return @"1111";
//    }
}


/*get control data*/
- (NSString *)rm2GetControlData
{
    
    BOOL isGetData = NO;
    int times = 0;
    while (!isGetData && times< 10) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:133] forKey:@"api_id"];
        [dic setObject:@"rm2_code" forKey:@"command"];
        [dic setObject:_info.mac forKey:@"mac"];
        NSData *requestData = [dic JSONData];
        NSData *responseData = [_network requestDispatch:requestData];
        NSLog(@"%@", [responseData objectFromJSONData]);
        if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
        {
            isGetData = YES;
            NSString * data = [[responseData objectFromJSONData] objectForKey:@"data"];
            //NSLog(@"get code : %@",data);
            
            dispatch_async(remoteQueue, ^{
                NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
                [remoteDic setObject:@"rm2Study" forKey:@"command"];
                [remoteDic setObject:_info.mac forKey:@"mac"];
                [remoteDic setObject:[NSNumber numberWithInt:0] forKey:@"success"];
                [remoteDic setObject:_rmDevice.name forKey:@"name"];
                [remoteDic setObject:[NSNumber numberWithInt:_btnId] forKey:@"buttonId"];
                [remoteDic setObject:data forKey:@"sendData"];
                [SmartHomeAPIs Rm2StudyData:remoteDic];
            });
            
            
            return data;
        }else if([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == -1){
            [NSThread sleepForTimeInterval:1.0];
            times++;
        }else
        {
            break;
        }
        
    }
    return nil;
    
    
}

/*Send data command*/
- (NSString *)rm2SendControlData:(NSString *)data
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:134] forKey:@"api_id"];
    [dic setObject:@"rm2_send" forKey:@"command"];
    [dic setObject:_info.mac forKey:@"mac"];
    [dic setObject:data forKey:@"data"];
    NSData *requestData = [dic JSONData];
    NSData *responseData = [_network requestDispatch:requestData];
    //NSLog(@"%@", [responseData objectFromJSONData]);
    dispatch_async(remoteQueue, ^{
        int success = ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue]==0) ? 0:1;
        //NSLog(@"success = %d",success);
        NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
        [remoteDic setObject:@"rm2Send" forKey:@"command"];
        [remoteDic setObject:_info.mac forKey:@"mac"];
        [remoteDic setObject:_rmDevice.name forKey:@"name"];
        [remoteDic setObject:[NSNumber numberWithInt:_btnId] forKey:@"buttonId"];
        [remoteDic setObject:data forKey:@"sendData"];
        [remoteDic setObject:[NSNumber numberWithInt:success] forKey:@"success"];
        [remoteDic setObject:[NSNumber numberWithInt:0] forKey:@"op_method"];
        [SmartHomeAPIs Rm2SendData:remoteDic];
    });
    
    return [[responseData objectFromJSONData] objectForKey:@"code"];
}


@end
