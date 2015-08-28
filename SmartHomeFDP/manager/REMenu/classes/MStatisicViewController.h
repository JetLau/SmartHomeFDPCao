//
//  MStatisicViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 15/8/27.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMenu.h"



@interface MStatisicViewController : UIViewController{
    
    __weak IBOutlet UISegmentedControl *addressSegment;
    __weak IBOutlet UITableView *addressTableView;
    __weak IBOutlet UISegmentedControl *enquiryTypeSegment;
}




@property (strong,nonatomic) NSArray *city;
@property (strong,nonatomic) NSArray *district;
@property (strong,nonatomic) NSArray *street;

//查询的地址范围
@property (strong,nonatomic) NSNumber *address;

@end
