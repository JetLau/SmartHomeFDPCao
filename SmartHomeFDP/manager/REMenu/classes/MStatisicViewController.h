//
//  MStatisicViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 15/8/27.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface MStatisicViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *adressTableView;
@property (weak, nonatomic) IBOutlet UILabel *currentAdress;
@property (weak, nonatomic) IBOutlet UISegmentedControl *moldSegmentControl;


@property (strong,nonatomic) NSArray *district;
@property (strong,nonatomic) NSArray *street;
@property int currentRank; //0:市，1:区，2:街道

@end
