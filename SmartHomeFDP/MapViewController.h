//
//  MapViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 15-5-12.
//  Copyright (c) 2015年 eddie. All rights reserved.
//
//学校经纬度 121.599591 31.191533
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property(nonatomic, strong) CLLocationManager *locationManager;

//经度
//@property (nonatomic, strong) NSString * longitudeStr;
@property (nonatomic, assign) double longitude;

//纬度
//@property (nonatomic, strong) NSString * latitudeStr;
@property (nonatomic, assign) double latitude;


@end
