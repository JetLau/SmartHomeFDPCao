//
//  ListDevViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "DeviceListViewController.h"
#import "BLDeviceInfo.h"
#import "LJCommonGroup.h"
#import "LJCommonItem.h"
#import "BLSP2ViewController.h"
#import "JSONKit.h"
#import "BLNetwork.h"
#import "RemoteControlDeviceViewController.h"
#import "ProgressHUD.h"
#import "InitBroadLink.h"
@interface DeviceListViewController ()
{
    dispatch_queue_t networkQueue;

}
@property (nonatomic,strong) NSMutableArray *groups;
@property (nonatomic,strong) NSMutableArray *deviceArray;
@property (nonatomic, strong) BLNetwork *network;

@end

@implementation DeviceListViewController
#pragma mark -懒加载
-(NSMutableArray *) groups
{
    if (_groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    }
    
    return _groups;
}

//屏蔽tableview的样式设置
-(id)init
{
    NSLog(@"1.init DeviceListView table view!");
    return [super init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置成no，则状态栏及导航样不为透明的，界面上的组件就是紧挨着导航栏显示了
    [self.navigationController.navigationBar setTranslucent:NO];
    
    /*Init network queue.*/
    networkQueue = dispatch_queue_create("BroadLinkNetworkQueue", DISPATCH_QUEUE_CONCURRENT);
    /*Init network library*/
    _network = [[BLNetwork alloc] init];
    _deviceArray = [self readDeviceInfoFromPlist];
    //初始化模型
    [self setupGroups];

}

-(void) viewWillAppear:(BOOL)animated
{
//    dispatch_async(networkQueue, ^{
//        InitBroadLink * initBL = [InitBroadLink initBroadLinkDevices];
//        [initBL networkInit];
//        [initBL addAllDevices];
//    });
}

-(void) setupGroups
{
    //第0组
    [self setupGroup0];
    [self setupGroup1];
}

-(void) setupGroup0
{
    //1.创建组
    LJCommonGroup *group = [LJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的基本数据
    group.groupheader = @"设备列表1";
//    group.groupfooter = @"第0组的尾部";
    
    //3.设置组中所有行的数据
    BLDeviceInfo *info;
    for(info in _deviceArray)
    {
        LJCommonItem * item = [LJCommonItem itemWithTitle:info.name icon:info.type];
        item.subtitle = [NSString stringWithFormat:@"%@ %@", info.mac, info.type];
        //item.destVcClass = [LJHotStatusViewController class];
        [group.items addObject:item];
    }
    
}

-(void) setupGroup1
{
    //1.创建组
    LJCommonGroup *group = [LJCommonGroup group];
    [self.groups addObject:group];
    
    //2.设置组的基本数据
    group.groupheader = @"设备列表2";
    //    group.groupfooter = @"第0组的尾部";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*)readDeviceInfoFromPlist{
    //NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *path = [doc stringByAppendingPathComponent:@"DeviceInfo.plist"];
    NSString *path=[[NSBundle mainBundle]pathForResource:@"DeviceInfo" ofType:@"plist"];
    //NSLog(@"device list address  %@",path);

    //读取数据
    //NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    //NSLog(@"读取数据  %@",dict);
    //return [dict objectForKey:@"DeviceInfo"];
    NSArray *list = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *array =[[NSMutableArray alloc]init];
    for (NSDictionary *item in list)
    {
        BLDeviceInfo *info = [[BLDeviceInfo alloc] init];
        [info setMac:[item objectForKey:@"mac"]];
        [info setType:[item objectForKey:@"type"]];
        [info setName:[item objectForKey:@"name"]];
        [info setLock:[[item objectForKey:@"lock"] intValue]];
        [info setPassword:[[item objectForKey:@"password"] unsignedIntValue]];
        [info setId:[[item objectForKey:@"id"] intValue]];
        [info setSubdevice:[[item objectForKey:@"subdevice"] intValue]];
        [info setKey:[item objectForKey:@"key"]];
        [array addObject:info];
        
    }
    
    //NSLog(@"读取数据  %@",array);
    
    if (array != nil) {
        return  array;
    }else{
        return [[NSMutableArray alloc]init];
    }
}

#pragma mark-点击cell的代理方法
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        BLDeviceInfo *info = [_deviceArray objectAtIndex:indexPath.row];
        
        [ProgressHUD show:@"状态查询中..."];
        self.view.userInteractionEnabled = false;
        
        if ([info.type isEqualToString:@"SP2"])
        {
            //[self enterSP2ViewController:info status:0];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSNumber numberWithInt:71] forKey:@"api_id"];
            [dic setObject:@"sp2_refresh" forKey:@"command"];
            [dic setObject:info.mac forKey:@"mac"];
            NSData *requestData = [dic JSONData];
            //NSLog(@"MAC: %@", dic);
            dispatch_async(networkQueue, ^{
                NSData *responseData = [_network requestDispatch:requestData];
                NSLog(@"%@", [responseData objectFromJSONData]);
                int code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
                if (code == 0)
                {
                    [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"" waitUntilDone:YES];
                    int state = [[[responseData objectFromJSONData] objectForKey:@"status"] intValue];
                    [self enterSP2ViewController:info status:state];
                    return;
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:[NSString stringWithFormat:@"错误码＝%i",code] waitUntilDone:YES];
                    return;
                }
            });
        }
        else
        {
            //[self enterRM2ViewController:info];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSNumber numberWithInt:131] forKey:@"api_id"];
            [dic setObject:@"rm2_refresh" forKey:@"command"];
            [dic setObject:info.mac forKey:@"mac"];
            NSData *requestData = [dic JSONData];
            
            dispatch_async(networkQueue, ^{
                NSData *responseData = [_network requestDispatch:requestData];
                NSLog(@"%@", [responseData objectFromJSONData]);
                int code = [[[responseData objectFromJSONData] objectForKey:@"code"] intValue];
                if (code == 0)
                {
                    [self performSelectorOnMainThread:@selector(successWithMessage:) withObject:@"" waitUntilDone:YES];
                    [self enterRM2ViewController:info];
                    return;
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(errorWithMessage:) withObject:[NSString stringWithFormat:@"错误码＝%i",code] waitUntilDone:YES];
                    return;
                }
            });
            
        }

    }else{
        return;
    }
}

- (void)enterSP2ViewController:(BLDeviceInfo *)info status:(int)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BLSP2ViewController *viewController = [[BLSP2ViewController alloc] init];
        [viewController setInfo:info];
        [viewController setStatus:status];
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

- (void)enterRM2ViewController:(BLDeviceInfo *)info
{
    dispatch_async(dispatch_get_main_queue(), ^{
        RemoteControlDeviceViewController *rmViewController=[[RemoteControlDeviceViewController alloc]init];
        rmViewController.navigationItem.title = @"智能遥控";
        [rmViewController setInfo:info];
        [self.navigationController pushViewController:rmViewController animated:YES];
    });
}

- (void) successWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    [ProgressHUD showError:message];
}


@end
