//
//  BLDeviceInfo.h
//  BroadLinkSDKDemo
//
//  Created by yang on 3/31/14.
//  Copyright (c) 2014 BroadLink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLDeviceInfo : NSObject

@property (nonatomic, strong) NSString *mac;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, assign) NSString *password;
@property (nonatomic, assign) int id;
@end
