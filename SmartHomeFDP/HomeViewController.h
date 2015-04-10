//
//  HomeViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//


#import <UIKit/UIKit.h>
@class RMDeviceManager;
@class TCPDeviceManager;

@interface HomeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong,nonatomic)IBOutlet UICollectionView *collectionView;

@property(strong,nonatomic)RMDeviceManager *rmDeviceManager;
@property(strong,nonatomic)TCPDeviceManager *tcpDeviceManager;
@property(strong,nonatomic)NSArray *rmDeviceArray;
@property(strong,nonatomic)NSArray *tcpDeviceArray;

@end
