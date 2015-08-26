//
//  MapViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15-5-12.
//  Copyright (c) 2015年 eddie. All rights reserved.
//
//121.595333
//31.193495

#import "MapViewController.h"
#import "MyPoint.h"
@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏tabbar工具条
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    //显示手机位置
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//#ifdef __IPHONE_8_0
//    if(IS_OS_8_OR_LATER) {
//        // Use one or the other, not both. Depending on what you put in info.plist
//        [self.locationManager requestWhenInUseAuthorization];
//        [self.locationManager requestAlwaysAuthorization];
//    }
//#endif
//    [self.locationManager startUpdatingLocation];
    
    //设置MapView的委托为自己
    [self.mapView setDelegate:self];
    
    //标注自身位置
    [self.mapView setShowsUserLocation:YES];
    
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self annotationAction];
}
//MapView委托方法，当定位自身时调用
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    
    //放大地图到自身的经纬度位置。
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    [self.mapView setRegion:region animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//放置标注
- (void)annotationAction{
    //创建CLLocation 设置经纬度
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.latitude longitude:self.longitude];
    CLLocationCoordinate2D coord = [loc coordinate];
    //创建标题
    NSString *titile = [NSString stringWithFormat:@"%@",@"设备位置"];
    MyPoint *myPoint = [[MyPoint alloc] initWithCoordinate:coord andTitle:titile];
    //添加标注
    [self.mapView addAnnotation:myPoint];
    
    //放大到标注的位置
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
//    [self.mapView setRegion:region animated:YES];
}


@end
