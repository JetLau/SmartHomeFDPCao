//
//  NSObject+InitBroadLink.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//
//broadlink设备首次配置要四步
//1.network_init对库进行初始化
//2.easyconfig配置联网参数，使设备上网
//3.probe_list搜索所有局域网内的设备
//4.device_add对要控制的搜索到的设备进行设备初始化

//设备联网以后，每次控制设备需要两步
//1.network_init对库进行初始化
//2.device_add对要控制的搜索到的设备进行设备初始化


#import "InitBroadLink.h"
#import "BLNetwork.h"
#import "JSONKit.h"
#import "MJExtension.h"

@interface InitBroadLink ()
{
    dispatch_queue_t networkQueue;
}
@property (nonatomic, strong) BLNetwork *network;
@end

@implementation InitBroadLink

+ (instancetype)initBroadLinkDevices
{
    InitBroadLink * initBL = [[InitBroadLink alloc] init];
    [initBL initNetwork];
    return initBL;
}

-(void) initNetwork
{
    networkQueue = dispatch_queue_create("BroadLinkSP2NetworkQueue", DISPATCH_QUEUE_SERIAL);
    _network = [[BLNetwork alloc] init];
}

- (void)networkInit
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:1] forKey:@"api_id"];
    [dic setObject:@"network_init" forKey:@"command"];
    //warning input your license.
    [dic setObject:@"U6mRbMpK5CLN5eikSIRuWuagtVKqWtjenPq/g/2Ttu2oOxJy8X4W2DW9uhsmcFyRZfgu3Y8bAoYR3BskKIH44p5BGQMZqg1X653Cg2jggev3yZ6Hag8=" forKey:@"license"];
    NSData *requestData = [dic JSONData];
    
    NSData *responseData = [_network requestDispatch:requestData];
    if ([[[responseData objectFromJSONData] objectForKey:@"code"] intValue] == 0)
    {
        NSLog(@"Init success!");
    }
    else
    {
        NSLog(@"Init failed!");
    }
}

- (void)listRefresh
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:11] forKey:@"api_id"];
    [dic setObject:@"probe_list" forKey:@"command"];
    
    NSData *requestData = [dic JSONData];
    NSMutableArray *oldDeviceArray = [[NSMutableArray alloc] initWithArray:[self readDeviceInfoFromPlist]];
    
    dispatch_async(networkQueue, ^{
        
        NSData *responseData = [_network requestDispatch:requestData];
        NSLog(@"-------%d",[[[responseData objectFromJSONData] objectForKey:@"code"] intValue]);
        int code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
        if (code == 0)
        {
            NSArray *newDeviceDicArray = [[responseData objectFromJSONData] objectForKey:@"list"];
            NSArray *newDeviceArray = [BLDeviceInfo keyValuesArrayWithObjectArray:newDeviceDicArray];
#warning 应该是直接把存的旧的device列表全删掉，直接存新的列表。但是现在搜索不到设备，所以现在算法是保存新设备列表且旧设备列表只改变状态
            int count = oldDeviceArray.count;
            for (BLDeviceInfo *info in newDeviceArray) {
                int i = 0;
                for (i = 0; i < count; i++)
                {
                    BLDeviceInfo *tmp = [oldDeviceArray objectAtIndex:i];
                    
                    if ([tmp.mac isEqualToString:info.mac])
                    {
                        [oldDeviceArray replaceObjectAtIndex:i withObject:info];
                        break;
                    }
                }
                
                if (i >= count && ![info.type isEqualToString:@"Unknown"])
                {
                    [oldDeviceArray addObject:info];
                    [self deviceAdd:info];
                    NSLog(@"add device %@",info.mac);
                }
                
            }
            
            //        for (BLDeviceInfo *info in oldDeviceArray) {
            //            [self deviceAdd:info];
            //            NSLog(@"info.name %@",info.name);
            //        }
            
            [self saveDeviceInfoToPlist:oldDeviceArray];
            NSLog(@"硬件列表数量：%d",[oldDeviceArray count]);
        }else{
            NSLog(@"probe_list error");
        }
    });
    
}

-(NSArray*)readDeviceInfoFromPlist
{
    //NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *path = [doc stringByAppendingPathComponent:@"DeviceInfo.plist"];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"DeviceInfo" ofType:@"plist"];
    
    //读取数据
    //NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    //NSLog(@"读取数据  %@",dict);
    //return [dict objectForKey:@"DeviceInfo"];
    NSArray *dictArray = [[NSArray alloc] initWithContentsOfFile:path];
    NSArray *devicesArray =[BLDeviceInfo objectArrayWithKeyValuesArray:dictArray];
    
    NSLog(@"读取数据  %@",devicesArray);
    
    if (devicesArray != nil) {
        return  devicesArray;
    }else{
        return [[NSArray alloc]init];
    }
}

- (void)addAllDevices
{
    NSArray *deviceArray = [[NSArray alloc] initWithArray:[self readDeviceInfoFromPlist]];
    for (BLDeviceInfo *info in deviceArray) {
        [self deviceAdd:info];
        //NSLog(@"add device %@",info.mac);
    }
}


- (void)deviceAdd:(BLDeviceInfo *)info
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[info keyValues]];
    //NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:12] forKey:@"api_id"];
    [dic setObject:@"device_add" forKey:@"command"];
    //    [dic setObject:info.mac forKey:@"mac"];
    //    [dic setObject:info.type forKey:@"type"];
    //    [dic setObject:info.name forKey:@"name"];
    //    [dic setObject:[NSNumber numberWithInt:info.lock] forKey:@"lock"];
    //    [dic setObject:[NSNumber numberWithUnsignedInt:info.password] forKey:@"password"];
    //    [dic setObject:[NSNumber numberWithInt:info.id] forKey:@"id"];
    //    [dic setObject:[NSNumber numberWithInt:info.subdevice] forKey:@"subdevice"];
    //    [dic setObject:info.key forKey:@"key"];
    //NSLog(@"%@", dic);
    //NSLog(@"dic %@", dic);
    NSData *requestData = [dic JSONData];
    
    dispatch_async(networkQueue, ^{
        NSData *responseData = [_network requestDispatch:requestData];
        int code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
        if (code == 0)
        {
            NSLog(@"Add %@ success!", info.mac);
        }
        else
        {
            NSLog(@"Add %@ failed! code = %i", info.mac, code);
            //TODO:
        }
    });
}

-(void)saveDeviceInfoToPlist :(NSMutableArray *) deviceArray
{
    //获取应用程序根目录
    //NSString *home = NSHomeDirectory();
    // NSUserDomainMask 在用户目录下查找
    // YES 代表用户目录的~
    // NSDocumentDirectory 查找Documents文件夹
    // 建议使用如下方法动态获取
    //NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接文件路径
    //NSString *path = [doc stringByAppendingPathComponent:@"DeviceInfo.plist"];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"DeviceInfo" ofType:@"plist"];
    NSLog(@"DeviceInfo.plist path : %@", path);
    
    
    //NSArray *deviceArray=[[NSArray alloc]initWithArray:deviceArray];
    //    [array writeToFile:path atomically:YES];
    NSArray *deviceDicArray = [BLDeviceInfo keyValuesArrayWithObjectArray:deviceArray];
    //    [_deviceArray writeToFile:path atomically:YES];
    [deviceDicArray writeToFile:path atomically:YES];
    
    //读取数据
    //NSDictionary *dict1 = [NSDictionary dictionaryWithContentsOfFile:path];
    // NSLog(@"读取数据1  %@",[[NSMutableArray alloc] initWithContentsOfFile:path]);
}

@end
