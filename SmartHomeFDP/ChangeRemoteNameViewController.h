//
//  ChangeRemoteNameViewController.h
//  NewProject
//
//  Created by eddie on 14-9-4.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLDeviceInfo.h"
@interface ChangeRemoteNameViewController : UIViewController
@property (nonatomic, strong) BLDeviceInfo * info;
@property (nonatomic, assign) int rmDeviceIndex;
@property (nonatomic, assign) int btnId;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@end
