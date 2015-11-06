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
#import "JSONKit.h"
#import "RemoteControlDeviceViewController.h"
#import "ProgressHUD.h"
#import "TCPDeviceManager.h"
#import "TCPDevice.h"
#import "TCPDeviceViewController.h"
#import "BLDeviceManager.h"
@interface DeviceListViewController ()
{
    dispatch_queue_t networkQueue;

}
@property (nonatomic,strong) NSMutableArray *groups;
@property (nonatomic,strong) NSMutableArray *deviceArray;
@property (nonatomic,strong) NSMutableArray *tcpDeviceArray;

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
    self.view.backgroundColor = [UIColor whiteColor];
    /*Init network queue.*/
    networkQueue = dispatch_queue_create("BroadLinkNetworkQueue", DISPATCH_QUEUE_CONCURRENT);
    /*Init network library*/
    
    
    //初始化模型
    [self setupGroups];

}

-(void) viewWillAppear:(BOOL)animated
{
    [self reloadTableViewData];
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
        info.type = @"RM2";
        info.name = @"中控器";
        //if ([info.type isEqualToString:@"RM2"] || [info.type isEqualToString:@"SP2"]) {
            LJCommonItem * item = [LJCommonItem itemWithTitle:info.name icon:info.type];
            item.subtitle = [NSString stringWithFormat:@"%@ %@", info.mac, info.type];
            //item.destVcClass = [LJHotStatusViewController class];
            [group.items addObject:item];
       // }
        
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
    TCPDevice *info;
    for(info in _tcpDeviceArray)
    {
        LJCommonItem *item=[LJCommonItem itemWithTitle:info.tcpDev_name icon:info.tcpDev_type];
        item.subtitle=[NSString stringWithFormat:@"%@",info.tcpDev_mac];
        
        [group.items addObject:item];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*)readDeviceInfoFromPlist{
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *path = [doc stringByAppendingPathComponent:@"DeviceInfo.plist"];
//    NSArray *list = [[NSArray alloc] initWithContentsOfFile:path];
//    NSMutableArray *array =[[NSMutableArray alloc]init];
//    for (NSDictionary *item in list)
//    {
//        BLDeviceInfo *info = [[BLDeviceInfo alloc] init];
//        [info setMac:[item objectForKey:@"mac"]];
//        [info setType:[item objectForKey:@"type"]];
//        [info setName:[item objectForKey:@"name"]];
//        [info setLock:[[item objectForKey:@"lock"] intValue]];
//        [info setPassword:[[item objectForKey:@"password"] unsignedIntValue]];
//        [info setId:[[item objectForKey:@"id"] intValue]];
//        [info setSubdevice:[[item objectForKey:@"subdevice"] intValue]];
//        [info setKey:[item objectForKey:@"key"]];
//        [array addObject:info];
//        
//    }
//        
//    if (array != nil) {
//        return  array;
//    }else{
//        return [[NSMutableArray alloc]init];
//    }
    BLDeviceManager *blDevManager = [BLDeviceManager createBLDeviceManager];
    return blDevManager.readBLDeviceInfoFromPlist;
}

-(NSMutableArray *)readTCPDeviceInfoFromPlist
{
    TCPDeviceManager *tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:tcpDeviceManager.TCPDeviceArray];
    NSMutableArray *deviceArray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<[array count];i++)
    {
        TCPDevice *device=[[TCPDevice alloc]init];
        [device setTcpDev_id:[[array objectAtIndex:i]objectForKey:@"id"]];
        [device setTcpDev_mac:[[array objectAtIndex:i]objectForKey:@"mac"]];
        [device setTcpDev_name:[[array objectAtIndex:i]objectForKey:@"name"]];
        [device setTcpDev_state:[[array objectAtIndex:i]objectForKey:@"state"]];
        [device setTcpDev_type:[[array objectAtIndex:i]objectForKey:@"type"]];
        
        [deviceArray addObject:device];
    }
    
    return deviceArray;
}

#pragma mark-点击cell的代理方法
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        BLDeviceInfo *info = [_deviceArray objectAtIndex:indexPath.row];
        
        //self.view.userInteractionEnabled = false;
        self.tabBarController.tabBar.userInteractionEnabled = false;
//        if ([info.type isEqualToString:@"SP2"])
//        {
//            
//        }
//        else if ([info.type isEqualToString:@"USR-c322"])
//        {
            [self enterRM2ViewController:info];
            return;
//        }

    }else if (indexPath.section==1){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            TCPDevice *deviceInfo=[_tcpDeviceArray objectAtIndex:indexPath.row];
//            TCPDeviceViewController *tcpDeviceViewController=[[TCPDeviceViewController alloc]init];
//            tcpDeviceViewController.deviceInfo=deviceInfo;
//        
//            [self.navigationController pushViewController:tcpDeviceViewController animated:YES];
//        });
//        
        return;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section==0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"cell number %i",indexPath.row);
                [self removeBLDevcie:indexPath.row];
                [self reloadTableViewData];
            });
            
        }else if (indexPath.section==1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"cell number %i",indexPath.row);
                [self removeTCPDevcie:indexPath.row];
                [self reloadTableViewData];
            });
            
        }
    }
}

- (void)enterSP2ViewController:(BLDeviceInfo *)info status:(int)status
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        BLSP2ViewController *viewController = [[BLSP2ViewController alloc] init];
//        [viewController setInfo:info];
//        [viewController setStatus:status];
//        [self.navigationController pushViewController:viewController animated:YES];
//    });
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
    self.tabBarController.tabBar.userInteractionEnabled = TRUE;

    [ProgressHUD showSuccess:message];
}

- (void) errorWithMessage:(NSString *)message {
    [self.view setUserInteractionEnabled:true];
    self.tabBarController.tabBar.userInteractionEnabled = TRUE;
    [ProgressHUD showError:message];
}

-(void) reloadTableViewData {
    //初始化模型
    _deviceArray = [self readDeviceInfoFromPlist];
    _tcpDeviceArray=[self readTCPDeviceInfoFromPlist];
    self.groups=nil;
    [self setupGroups];
    [self.tableView reloadData];
}

-(void)removeBLDevcie:(int)index
{
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *path = [doc stringByAppendingPathComponent:@"DeviceInfo.plist"];
//    NSMutableArray *list = [[NSMutableArray alloc] initWithContentsOfFile:path];
//    [list removeObjectAtIndex:index];
//    [list writeToFile:path atomically:YES];
    BLDeviceManager *blDevManager = [BLDeviceManager createBLDeviceManager];
    [blDevManager removeBLDevcie:index];
}


-(void) removeTCPDevcie:(int)index
{
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *path = [doc stringByAppendingPathComponent:@"TCPDeviceInfo.plist"];
//    NSMutableArray *list = [[NSMutableArray alloc] initWithContentsOfFile:path];
//    [list removeObjectAtIndex:index];
//    [list writeToFile:path atomically:YES];
    TCPDeviceManager *tcpDevManager = [TCPDeviceManager createTCPDeviceManager];
    [tcpDevManager removeTCPDevcie:index];
    
}
@end
