//
//  HomeViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "HomeViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "CustomCollectionViewCell.h"
#import "RMDeviceManager.h"
#import "TCPDeviceManager.h"
#import "DeviceViewController.h"
#import "AirConditionViewController.h"
#import "TVViewController.h"
#import "CurtainViewController.h"
#import "ProjectorViewController.h"
#import "LightViewController.h"
#import "CustomRemoteViewController.h"
#import "TCPDeviceViewController.h"
#import "TCPDevice.h"

#define homeViewQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize rmDeviceManager;
@synthesize tcpDeviceManager;
@synthesize rmDeviceArray;
@synthesize tcpDeviceArray;

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
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"customCollectionViewCell"];
    
    [self.navigationItem setTitle:@"首页"];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    rmDeviceManager=[RMDeviceManager createRMDeviceManager];
    tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
    rmDeviceArray=rmDeviceManager.RMDeviceArray;
    tcpDeviceArray=tcpDeviceManager.TCPDeviceArray;
    
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [rmDeviceArray count]+[tcpDeviceArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCollectionViewCell *cell;
    
    cell= (CustomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"customCollectionViewCell" forIndexPath:indexPath];
    
    if(!cell)
    {
        cell=[[CustomCollectionViewCell alloc]init];
    }
    
    int index=indexPath.row;
    NSString *type;
    NSString *name;
    
    if(index<[rmDeviceArray count]) //RMDevice
    {
        NSDictionary *rmDic=[rmDeviceArray objectAtIndex:index];
        type=[rmDic objectForKey:@"type"];
        name=[rmDic objectForKey:@"name"];
    }
    else//TCPDevice
    {
        int tcpIndex=index-[rmDeviceArray count];
        NSDictionary *rmDic=[tcpDeviceArray objectAtIndex:tcpIndex];
        type=[rmDic objectForKey:@"type"];
        name=[rmDic objectForKey:@"name"];
    }
    //NSLog(@"type = %@",type);
    cell.imageView.image=[UIImage imageNamed:[type lowercaseString]];
    cell.label.text=name;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index=indexPath.row;
    
    if(index<[rmDeviceArray count])//RMDevice
    {
        DeviceViewController *deviceViewController;
        NSDictionary *rmDic=[rmDeviceArray objectAtIndex:index];
        NSString *type=[rmDic objectForKey:@"type"];
        NSString *mac=[rmDic objectForKey:@"mac"];
        
        if([type isEqualToString:@"AirCondition"])
        {
            deviceViewController=[[AirConditionViewController alloc]init];
        }
        else if([type isEqualToString:@"TV"])
        {
            deviceViewController=[[TVViewController alloc]init];
        }
        else if([type isEqualToString:@"Curtain"])
        {
            deviceViewController=[[CurtainViewController alloc]init];
        }
        else if([type isEqualToString:@"Projector"])
        {
            deviceViewController=[[ProjectorViewController alloc]init];
        }
        else if([type isEqualToString:@"Light"])
        {
            deviceViewController=[[LightViewController alloc]init];
        }
        else if([type isEqualToString:@"Custom"])
        {
            deviceViewController=[[CustomRemoteViewController alloc]init];
        }
        else
        {
            deviceViewController=[[DeviceViewController alloc]init];
        }
        
        [deviceViewController setRemoteType:type];
        deviceViewController.rmDeviceIndex=index;
        BLDeviceInfo *info=[[BLDeviceInfo alloc]init];
        info.mac=mac;
        [deviceViewController setInfo:info];
        
        [self.navigationController pushViewController:deviceViewController animated:YES];
    }
    else//TCPDevice
    {
        TCPDeviceViewController *tcpDeviceViewController=[[TCPDeviceViewController alloc]init];
        
        int tcpIndex=index-[rmDeviceArray count];
        NSDictionary *tcpDic=[tcpDeviceArray objectAtIndex:tcpIndex];
        
        TCPDevice *device=[[TCPDevice alloc]init];
        [device setTcpDev_id:[tcpDic objectForKey:@"id"]];
        [device setTcpDev_mac:[tcpDic objectForKey:@"mac"]];
        [device setTcpDev_name:[tcpDic objectForKey:@"name"]];
        [device setTcpDev_state:[tcpDic objectForKey:@"state"]];
        [device setTcpDev_type:[tcpDic objectForKey:@"type"]];
        tcpDeviceViewController.deviceInfo=device;
        
        [self.navigationController pushViewController:tcpDeviceViewController animated:YES];
    }
}
@end
