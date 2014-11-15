//
//  LJCommonItem.m
//  NewProject
//
//  Created by eddie on 14-9-2.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "LJCommonItem.h"

@implementation LJCommonItem

+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon type:(NSString *)type
{
    LJCommonItem *item = [[self alloc] init];
    item.title=title;
    item.icon=icon;
    item.type=type;
    
    return item;
}

+(instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    LJCommonItem *item = [[self alloc] init];
    item.title=title;
    item.icon=icon;
    
    return item;
}

+(instancetype)itemWithTitle:(NSString *)title
{
    LJCommonItem *item = [[LJCommonItem alloc] init];
    item.title = title;
    return item;
}

@end
